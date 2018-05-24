//
//  NCacheManager.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/22.
//  Copyright © 2018年 a. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NCacheManager.h"
#import "NMemoryCache.h" //内存缓存
#import "NFileCache.h" //磁盘缓存

@implementation NCacheManager
//单例
+ (instancetype)share
{
    static NCacheManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NCacheManager  alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.memoryCache = [NMemoryCache  share];
        self.fileCache = [NFileCache share];
        [self  registerClass:[NSException  class]];//默认类
    }return self;
}

//注册要保存对象的类型
- (void)registerClass:(Class)aClass
{
    _aClass = aClass;
}

/////////////////////////////////////////////////
/// 是否含有某个key对应的值
- (BOOL)hasObjectForKey:(NSString *)key
{
    //去内存读
    BOOL isHave = [self  hasMemoryCacheForKey:key];
    NSLog(@"从内存读的,isHave: %d", isHave);
    if (NO == isHave) {
        //去磁盘里读
        isHave = [self  hasFileCacheForKey:key];
        NSLog(@"从文件读的, isHave: %d", isHave);
    }
    return isHave;
}

- (BOOL)hasFileCacheForKey:(NSString *)key
{
    NSString *md5Key = [self  md5HashWithString:key];
    return [self.fileCache  hasObjectForKey:md5Key];
}

- (BOOL)hasMemoryCacheForKey:(NSString *)key
{
    NSString *md5Key = [self  md5HashWithString:key];
    return [self.memoryCache  hasObjectForKey:md5Key];
}

/// 添加key-value
- (void)setObject:(id)object forKey:(NSString *)key isAsync:(BOOL)isAsync
{
#warning copy https://blog.csdn.net/u013883974/article/details/77645212
    if (isAsync) {
        /////////////////////// 异步缓存 /////////////////
        /*
         外部 直接for循环,  程序会崩溃。
         原因:[self setMemoryCacheObject:object forKey:key]方法里面, 属性cacheObjDic字典的语义是
         nonatomic, 不保证线程安全
         */
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self setFileCacheObject:object forKey:key];
                [self setMemoryCacheObject:object forKey:key];
        });
    }else{
        
        /////////////////////// 二种同步缓存方法 /////////////////
        
        /*第一种: 外部 直接for循环 调用setObject:(id)object forKey:(NSString *)key isAsync:(BOOL)isAsync时, for循环内部不开启子线程时, 程序不崩溃; for 内部开启子线程时, 程序会崩溃。
        
         原因:[self setMemoryCacheObject:object forKey:key]方法里面, 属性cacheObjDic字典的语义是
         nonatomic, 不保证线程安全
         推荐第一种, 但是 for 循序内部 一定不要开启子线程, 创建数据本身就是同步事件
         下一步需要学习barrier函数, 解决线程安全问题
         */
        
        [self setFileCacheObject:object forKey:key];
        [self setMemoryCacheObject:object forKey:key];
        
        /*第二种: 外部 直接for循环 调用setObject:(id)object forKey:(NSString *)key isAsync:(BOOL)isAsync时,
         for循环内部禁止开启子线程, 因为这里已经开启了子线程;
         for 内部开启子线程时, 程序会崩溃。
         
         不建议使用第二种方式, 因为会开启大量子线程, 性能消耗大。
         */
        
        /*
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //同步缓存
            //加锁, 保证线程同步, 必须将所有参数放在锁里面
            @synchronized(self){
                [self setFileCacheObject:object forKey:key];
                [self setMemoryCacheObject:object forKey:key];
            }
        });
         */
    }
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    //默认同步保存
    [self  setObject:object forKey:key isAsync:NO];
}

- (void)setFileCacheObject:(id)object forKey:(NSString *)key
{
    NSString *md5Key = [self  md5HashWithString:key];
    [self.fileCache setObject:object forKey:md5Key];
}

- (void)setMemoryCacheObject:(id)object forKey:(NSString *)key
{
    NSString *md5Key = [self  md5HashWithString:key];
    [self.memoryCache setObject:object forKey:md5Key];
}

/// 取key对应的value
- (id)objectForKey:(NSString *)key
{
    //先读内存缓存
    id object = [self  memoryCacheObjectForKey:key];
    NSLog(@"从内存读, object:%@", object);
    if (object == nil) {
        //内存缓存为空, 再读文件缓存
        object = [self fileCacheObjectForKey:key];
        NSLog(@"从文件读, object:%@", object);
    }
    return object;
}

- (id)fileCacheObjectForKey:(NSString *)key
{
    NSString *md5Key = [self  md5HashWithString:key];
    id object = nil;
    //判断是否有value
    if ([self.fileCache  hasObjectForKey:md5Key]) {
        //取出对象, 并知道对象类型
        object = [self.fileCache  objectForKey:md5Key objectClass:_aClass];
        if (object) {
            //读取到对象后, 写进内存缓存, 保证下次从内存缓存里读
            [self.memoryCache  setObject:object forKey:md5Key];
        }
        return object;
    }
    
    return object;
}

- (id)memoryCacheObjectForKey:(NSString *)key
{
    NSString *md5Key = [self  md5HashWithString:key];
    id object = nil;
    //判断内存缓存是否有value
    if ([self.memoryCache  hasObjectForKey:md5Key]) {
        object = [self.memoryCache  objectForKey:md5Key];
        if (object && [object isKindOfClass:_aClass]) {
            //返回对象, 并且知道对象类型
            return object;
        }else if (object && 1){
            return object;
        }
    }
    return object;
}

/// 删除对应key的值
- (void)removeObjectForKey:(NSString *)key
{
    [self  removeFileCacheObjectForKey:key];
    [self  removeMemoryCacheObjectForKey:key];
}

- (void)removeFileCacheObjectForKey:(NSString *)key
{
    NSString *md5Key = [self  md5HashWithString:key];
    [self.fileCache  removeObjectForKey:md5Key];
}

- (void)removeMemoryCacheObjectForKey:(NSString *)key
{
    NSString *md5Key = [self  md5HashWithString:key];
    [self.memoryCache  removeObjectForKey:md5Key];
}

/// 删除全部数据 - 清除当前 diskCachePath 所有的文件
- (void)removeAllObjects
{
    [self  removeAllFileCacheObjects];
    [self  removeAllMemoryCacheObjects];
}

- (void)removeAllFileCacheObjects
{
    [self.fileCache  removeAllObjects];
}

- (void)removeAllMemoryCacheObjects
{
    [self.memoryCache  removeAllObjects];
}

#pragma mark - Function Helper
- (NSString *)md5HashWithString:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    NSString *md5Result = [NSString stringWithFormat:
                           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return md5Result;
}
@end
