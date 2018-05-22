//
//  NFileCache.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/22.
//  Copyright © 2018年 a. All rights reserved.
//

#import "NFileCache.h"

@interface NFileCache()
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
    NSAssert(diskPath.length > 0, @"Namespace 必须得有");
    
    self = [super init];
    if ( self ){
        //缓存的磁盘路径
        _diskCachePath = [[self defaultDiskCachePath] stringByAppendingPathComponent:diskPath];
        
        NSLog(@"缓存的磁盘路径: %@", _diskCachePath);

        //缓存时长, 默认1天
        _maxCacheTimeInterval = NFileCache_fileExpires;
        //缓存大小
        _maxCacheSize = 0;
        //文件对象
        _fileManager = [NSFileManager defaultManager];
        
//        [[XYFileCacheBackgroundClean sharedInstance] setFileCacheInfo:[self info] forKey:_diskCachePath];
    }
    return self;
}

- (NSDictionary *)info
{
    return @{@"path" : _diskCachePath,
             @"maxCacheTimeInterval": @(_maxCacheTimeInterval),
             @"maxCacheSize": @(_maxCacheSize)};
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
    
    NSLog(@"key对应的文件路径: %@", filePath);
    return filePath;
}

#pragma mark - Private Methods
//是否含有某个key对应的文件
- (BOOL)hasObjectForKey:(NSString *)key
{
    return [self.fileManager  fileExistsAtPath:[self filePathForKey:key]];
}

//添加key-value
- (void)setObject:(id)object forKey:(NSString *)key
{
    if ([key length] == 0) {
        NSLog(@"key is null");
        return;
    }
    
    if ( nil == object ){
        //清空文件下的数据
        [self removeObjectForKey:key];
    }else{
        // 用的是AutoCoding里的方法
        //写进本地文件
        [object writeToFile:[self filePathForKey:key] atomically:YES];
    }
}

//取key对应的value
- (id)objectForKey:(NSString *)key
{
    // 建议用 objectForKey:objectClass: 可以直接返回对象
    return [NSData dataWithContentsOfFile:[self filePathForKey:key]];
}

//删除对应key的值
- (void)removeObjectForKey:(NSString *)key
{
    [self.fileManager removeItemAtPath:[self filePathForKey:key] error:nil];
}

//删除全部数据
- (void)removeAllObjects
{
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    //    if ([self folderSize] > self.diskCapacity) {
    //        [self  deleteCacheFolder];
    //    }
    //});
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


@end







