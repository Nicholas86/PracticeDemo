//
//  NFileCache.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/22.
//  Copyright © 2018年 a. All rights reserved.
//

#import "NFileCache.h"
#import "NSObject+NAutoCoding.h"
#import "NFileCacheBackgroundClean.h"

//加锁(默认信号量为1, 现在减1)
#define Lock(semaphonre_t) dispatch_semaphore_wait(semaphonre_t, DISPATCH_TIME_FOREVER)
//解锁
#define UnLock(semaphonre_t) dispatch_semaphore_signal(semaphonre_t)


@interface NFileCache()
{
    dispatch_semaphore_t _semaphonre_t;//信号量, 相当于锁🔐
    dispatch_queue_t _queue;//队列
}
@property (nonatomic, strong) NSFileManager *fileManager;//文件对象
- (NSDictionary *)info;
@end


@implementation NFileCache
//单例
+ (instancetype)share
{
    static NFileCache *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NFileCache  alloc] init];
    });
    return instance;
}


- (id)init
{
    return [self initWithDiskPath:@"default"];
}

- (id)initWithDiskPath:(NSString *)diskPath
{
    NSAssert(diskPath.length > 0, @"diskPath 必须得有");
    
    self = [super init];
    if ( self ){
        //缓存的磁盘路径
        _diskCachePath = [[self defaultDiskCachePath] stringByAppendingPathComponent:diskPath];
        
        //NSLog(@"缓存的磁盘路径: %@", _diskCachePath);

        //缓存时长, 默认1天
        _maxCacheTimeInterval = NFileCache_fileExpires;
        //缓存大小
        _maxCacheSize = 0;
        //文件对象
        _fileManager = [NSFileManager defaultManager];
        
        //初始化信号量
        _semaphonre_t = dispatch_semaphore_create(1);
        //创建并行队列: YYMemoryCache用的串行队列
        _queue = dispatch_queue_create("com.nicholas.disk.cache", DISPATCH_QUEUE_CONCURRENT);
        
        [[NFileCacheBackgroundClean share] setFileCacheInfo:[self info] forKey:_diskCachePath];
    }
    return self;
}


///便利构造器
+ (id)fileCacheWithDiskPath:(NSString *)diskPath
{
    return [[self  alloc] initWithDiskPath:diskPath];
}

- (NSDictionary *)info
{
    return @{
             @"path" : _diskCachePath,
             @"maxCacheTimeInterval": @(_maxCacheTimeInterval),
             @"maxCacheSize": @(_maxCacheSize)
             };
}


/// 返回key对应的文件路径
- (NSString *)filePathForKey:(NSString *)key
{
    NSString *filePath = _diskCachePath;
    
    if ([self.fileManager  fileExistsAtPath:filePath] == NO) {
        //磁盘路径不存在, 新建一个磁盘路径
        [self.fileManager  createDirectoryAtPath:filePath
                     withIntermediateDirectories:YES
                                      attributes:nil
                                           error:nil];
    }
    
    filePath = [filePath stringByAppendingPathComponent:key];
    
    NSAssert(filePath.length > 0, @"路径得有");
    
    //NSLog(@"key对应的文件路径: %@", filePath);
    return filePath;
}

/*
 /Users/a/Library/Developer/CoreSimulator/Devices/E4B24D7E-0219-4045-80B0-1384734EA209/data/Containers/Data/Application/5EC72421-1E0D-4601-BB2A-606E63910EC4/Library/Caches/nicholas/name
 */

/// 返回 类对象
- (id)objectForKey:(NSString *)key objectClass:(Class)aClass
{
    if (aClass != nil) {
        //返回传入的数据类型, 类方法
        //加锁🔐
        Lock(_semaphonre_t);
        id object = [aClass objectWithContentsOfFile:[self  filePathForKey:key]];
        UnLock(_semaphonre_t);
        return object;
    }else{
        //默认返回NSData数据类型
        return [self  objectForKey:key];
    }
}

/// 清除当前 diskCachePath 所有的文件
- (void)clearDisk
{
    [self  clearDiskOnCompletion:nil];
}

/// 清除当前 diskCachePath 所有的文件
- (void)clearDiskOnCompletion:(void(^)(void))completion
{
    //异步清除
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        /*
         /Users/a/Library/Developer/CoreSimulator/Devices/E4B24D7E-0219-4045-80B0-1384734EA209/data/Containers/Data/Application/5EC72421-1E0D-4601-BB2A-606E63910EC4/Library/Caches/nicholas/
         */
        //清空自定义的文件路径以及里面所有数据
        [self.fileManager removeItemAtPath:_diskCachePath error:nil];
        //磁盘路径不存在, 新建一个磁盘路径
        [self.fileManager  createDirectoryAtPath:_diskCachePath
                     withIntermediateDirectories:YES
                                      attributes:nil
                                           error:nil];
        if (completion){
            dispatch_async( dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

#pragma mark - Private Methods
//是否含有某个key对应的文件
- (BOOL)hasObjectForKey:(NSString *)key
{
    if ([key length] == 0) {
        NSLog(@"key is null");
        return NO;
    }
    //加锁🔐
    Lock(_semaphonre_t);
    BOOL isHave = [self.fileManager  fileExistsAtPath:[self filePathForKey:key]];
    //解锁
    UnLock(_semaphonre_t);
    return isHave;
}

//添加key-value
- (void)setObject:(NSObject *)object forKey:(NSString *)key
{
    if ([key length] == 0) {
        NSLog(@"key is null");
        return;
    }
    
    if ( nil == object ){
        //清空文件下的数据
        [self removeObjectForKey:key];
    }else{
        
#warning 加锁🔐(信号量) _semaphonre_t 减 1 = 0 , 一直等待, 直到信号量 _semaphonre_t = 1
        dispatch_semaphore_wait(_semaphonre_t, DISPATCH_TIME_FOREVER);
        // 用的是NSObject + NAutoCoding里的方法
        // 写进本地文件,object类型必须是NSObject *子类, 不可以是id类型
        //id类型就进不了NSObject + NAutoCoding里的方法
        [object writeToFile:[self filePathForKey:key] atomically:YES];
#warning 解锁🔐(信号量) _semaphonre_t 加 1 = 1 , 1_semaphonre_t = 1
        dispatch_semaphore_signal(_semaphonre_t);
    }
}

//取key对应的value
- (id)objectForKey:(NSString *)key
{
    // 建议用 objectForKey:objectClass: 可以直接返回对象
    // 默认返回NSData数据类型
    if ([key length] == 0) {
        NSLog(@"key is null");
        return nil;
    }
    //加锁🔐
    Lock(_semaphonre_t);
    NSData *data = [NSData dataWithContentsOfFile:[self filePathForKey:key]];
    UnLock(_semaphonre_t);
    return data;
}

//删除对应key的值
- (void)removeObjectForKey:(NSString *)key
{
    if ([key length] == 0) {
        NSLog(@"key is null");
        return ;
    }
    //加锁🔐
    Lock(_semaphonre_t);
    [self.fileManager removeItemAtPath:[self filePathForKey:key] error:nil];
    //解锁
    UnLock(_semaphonre_t);
}

- (void)removeObjectForKey:(NSString *)key withBlock:(void(^)(NSString *key))block {
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;
        [self removeObjectForKey:key];
        if (block) block(key);
    });
}

//删除全部数据
- (void)removeAllObjects
{
    [self  clearDisk];
}


#pragma mark setter & getter
//缓存路径
- (NSString *)defaultDiskCachePath
{
    NSString  *cacheDirectory= [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return cacheDirectory;
}


//缓存大小
- (void)setMaxCacheSize:(NSUInteger)maxCacheSize
{
    _maxCacheSize = maxCacheSize;
}

//缓存有效期
- (void)setMaxCacheTimeInterval:(NSTimeInterval)maxCacheTimeInterval
{
    _maxCacheTimeInterval = maxCacheTimeInterval;
}

/*
 NSError *error=nil;
 
 NSDictionary *dict= [_fileManager attributesOfItemAtPath:[self filePathForKey:key] error:&error];
 if(dict!=nil)
 {
 NSLog(@"filesize =  %llu ",[dict fileSize]);
 NSLog(@"fileModificationDate = %@",[dict fileModificationDate]);
 NSLog(@"fileType =  %@ ",[dict fileType]);
 NSLog(@"filePosixPermissions =  %lo ",(unsigned long)[dict filePosixPermissions]);
 NSLog(@"fileOwnerAccountName =  %@ ",[dict fileOwnerAccountName]);
 NSLog(@"fileGroupOwnerAccountName =  %@ ",[dict fileGroupOwnerAccountName]);
 NSLog(@"fileSystemNumber =  %ld ",(long)[dict fileSystemNumber]);
 NSLog(@"fileSystemFileNumber =  %lu ",(unsigned long)[dict fileSystemFileNumber]);
 NSLog(@"fileExtensionHidden =  %d ",[dict fileExtensionHidden]);
 NSLog(@"fileHFSCreatorCode =  %u ",(unsigned int)[dict fileHFSCreatorCode]);
 NSLog(@"fileHFSTypeCode =  %u ",(unsigned int)[dict fileHFSTypeCode]);
 NSLog(@"fileIsImmutable =  %d ",[dict fileIsImmutable]);
 NSLog(@"fileIsAppendOnly =  %d ",[dict fileIsAppendOnly]);
 NSLog(@"fileCreationDate =  %@ ",[dict fileCreationDate]);
 NSLog(@"fileOwnerAccountID =  %@ ",[dict fileOwnerAccountID]);
 NSLog(@"fileGroupOwnerAccountID =  %@ ",[dict fileGroupOwnerAccountID]);
 }
 */
@end







