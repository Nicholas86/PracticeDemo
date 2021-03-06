//
//  __  __          ____           _          _
//  \ \/ / /\_/\   /___ \  _   _  (_)   ___  | | __
//   \  /  \_ _/  //  / / | | | | | |  / __| | |/ /
//   /  \   / \  / \_/ /  | |_| | | | | (__  |   <
//  /_/\_\  \_/  \___,_\   \__,_| |_|  \___| |_|\_\
//
//  Copyright (C) Heaven.
//
//	https://github.com/uxyheaven/XYQuick
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "XYFileCache.h"
#import "XYAutoCoding.h"
#import "XYThread.h"
#import "XYFileCacheBackgroundClean.h"


#pragma mark- XYFileCache
@interface XYFileCache ()

@property (nonatomic, strong) NSFileManager *fileManager;

- (NSDictionary *)info;

@end

@implementation XYFileCache

+ (instancetype)sharedInstance
{
    static dispatch_once_t __singletonToken;
    static id __singleton__;
    dispatch_once( &__singletonToken, ^{ __singleton__ = [[self alloc] init]; } );
    return __singleton__;
}

- (id)init
{
    return [self initWithNamespace:@"default"];
}

- (id)initWithNamespace:(NSString *)ns
{
    NSAssert(ns.length > 0, @"Namespace 必须得有");
    
    self = [super init];
    if ( self )
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _diskCachePath = [paths[0] stringByAppendingPathComponent:ns];
        _maxCacheAge = XYFileCache_fileExpires;
        _maxCacheSize = 0;
        _fileManager = [NSFileManager defaultManager];
        
        [[XYFileCacheBackgroundClean sharedInstance] setFileCacheInfo:[self info] forKey:_diskCachePath];
    }
    return self;
}

- (NSDictionary *)info
{
    return @{@"path" : _diskCachePath,
             @"maxCacheAge": @(_maxCacheAge),
             @"maxCacheSize": @(_maxCacheSize)};
}

- (void)dealloc
{
    
}
#pragma mark-
- (NSString *)fileNameForKey:(NSString *)key
{
    NSString *pathName = _diskCachePath;
    
    if ( NO == [_fileManager fileExistsAtPath:pathName] )
    {
        [_fileManager createDirectoryAtPath:pathName
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:NULL];
    }
    
    pathName = [pathName stringByAppendingPathComponent:key];
    
    NSAssert(pathName.length > 0, @"路径得有");
    
    return pathName;
}

- (id)objectForKey:(id)key objectClass:(Class)aClass
{
    if (aClass != nil)
    {
        // 用的是AutoCoding里的方法
        return [aClass uxy_objectWithContentsOfFile:[self fileNameForKey:key]];
    }
    else
    {
        return [self objectForKey:key];
    }
}

// 清除当前 XYFileCache 所有的文件
- (void)clearDisk
{
    [self clearDiskOnCompletion:nil];
}

- (void)clearDiskOnCompletion:(void (^)(void))completion
{
    dispatch_async( [XYGCD sharedInstance].writeFileQueue, ^{
        [_fileManager removeItemAtPath:_diskCachePath error:NULL];
        [_fileManager createDirectoryAtPath:_diskCachePath
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:NULL];
        if (completion)
        {
            dispatch_async( dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}
// 清除当前 XYFileCache 所有过期的文件
- (void)cleanDisk
{
    [self cleanDiskWithCompletionBlock:nil];
}

- (void)cleanDiskWithCompletionBlock:(void (^)(void))completion
{
    dispatch_async([XYGCD sharedInstance].writeFileQueue, ^{
        NSURL *diskCacheURL = [NSURL fileURLWithPath:_diskCachePath isDirectory:YES];
        NSArray *resourceKeys = @[NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey];
        
        // This enumerator prefetches useful properties for our cache files.
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtURL:diskCacheURL
                                                   includingPropertiesForKeys:resourceKeys
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 errorHandler:NULL];
        
        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-_maxCacheAge];
        NSMutableDictionary *cacheFiles = [NSMutableDictionary dictionary];
        NSUInteger currentCacheSize = 0;
        
        // Enumerate all of the files in the cache directory.  This loop has two purposes:
        //
        //  1. Removing files that are older than the expiration date.
        //  2. Storing file attributes for the size-based cleanup pass.
        NSMutableArray *urlsToDelete = [[NSMutableArray alloc] init];
        for (NSURL *fileURL in fileEnumerator)
        {
            NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:NULL];
            
            // Skip directories.
            if ([resourceValues[NSURLIsDirectoryKey] boolValue])
            {
                continue;
            }
            
            // Remove files that are older than the expiration date;
            NSDate *modificationDate = resourceValues[NSURLContentModificationDateKey];
            if ([[modificationDate laterDate:expirationDate] isEqualToDate:expirationDate])
            {
                [urlsToDelete addObject:fileURL];
                continue;
            }
            
            // Store a reference to this file and account for its total size.
            NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
            currentCacheSize += [totalAllocatedSize unsignedIntegerValue];
            [cacheFiles setObject:resourceValues forKey:fileURL];
        }
        for (NSURL *fileURL in urlsToDelete)
        {
            [_fileManager removeItemAtURL:fileURL error:nil];
        }
        // If our remaining disk cache exceeds a configured maximum size, perform a second
        // size-based cleanup pass.  We delete the oldest files first.
        if (self.maxCacheSize > 0 && currentCacheSize > self.maxCacheSize)
        {
            // Target half of our maximum cache size for this cleanup pass.
            const NSUInteger desiredCacheSize = self.maxCacheSize / 2;
            
            // Sort the remaining cache files by their last modification time (oldest first).
            NSArray *sortedFiles = [cacheFiles keysSortedByValueWithOptions:NSSortConcurrent
                                                            usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                                                return [obj1[NSURLContentModificationDateKey] compare:obj2[NSURLContentModificationDateKey]];
                                                            }];
            
            // Delete files until we fall below our desired cache size.
            for (NSURL *fileURL in sortedFiles)
            {
                if ([_fileManager removeItemAtURL:fileURL error:nil])
                {
                    NSDictionary *resourceValues = cacheFiles[fileURL];
                    NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
                    currentCacheSize -= [totalAllocatedSize unsignedIntegerValue];
                    
                    if (currentCacheSize < desiredCacheSize)
                    {
                        break;
                    }
                }
            }
        }
        if (completion)
        {
            dispatch_async( dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

- (NSUInteger)getSize
{
    __block NSUInteger size = 0;
    dispatch_sync([XYGCD sharedInstance].writeFileQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:_diskCachePath];
        for (NSString *fileName in fileEnumerator)
        {
            NSString *filePath  = [_diskCachePath stringByAppendingPathComponent:fileName];
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
        }
    });
    return size;
}

- (NSUInteger)getDiskCount
{
    __block NSUInteger count = 0;
    dispatch_sync([XYGCD sharedInstance].writeFileQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:_diskCachePath];
        count = [[fileEnumerator allObjects] count];
    });
    return count;
}
#pragma mark-
-(void)setMaxCacheAge:(NSTimeInterval)maxCacheAge
{
    _maxCacheAge = maxCacheAge;
    [[XYFileCacheBackgroundClean sharedInstance] setFileCacheInfo:[self info] forKey:_diskCachePath];
}

-(void)setMaxCacheSize:(NSUInteger)maxCacheSize
{
    _maxCacheSize = maxCacheSize;
    [[XYFileCacheBackgroundClean sharedInstance] setFileCacheInfo:[self info] forKey:_diskCachePath];
}
#pragma mark - XYCacheProtocol
- (BOOL)hasObjectForKey:(NSString *)key
{
    return [_fileManager fileExistsAtPath:[self fileNameForKey:key]];
}

- (id)objectForKey:(NSString *)key
{
    // 建议用 objectForKey:objectClass: 可以直接返回对象
    return [NSData dataWithContentsOfFile:[self fileNameForKey:key]];
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    if ( nil == object )
    {
        [self removeObjectForKey:key];
    }
    else
    {
        // 用的是AutoCoding里的方法
        [object writeToFile:[self fileNameForKey:key] atomically:YES];
    }
}

- (void)removeObjectForKey:(NSString *)key
{
    [_fileManager removeItemAtPath:[self fileNameForKey:key] error:nil];
}

- (void)removeAllObjects
{
    [self clearDisk];
}

@end
