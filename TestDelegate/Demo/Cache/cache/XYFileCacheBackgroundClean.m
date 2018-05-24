//
//  XYFileCacheBackgroundClean.m
//  TestDelegate
//
//  Created by a on 2018/5/24.
//  Copyright © 2018年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYFileCacheBackgroundClean.h"
#import "XYThread.h"

@implementation XYFileCacheBackgroundClean
#pragma mark- XYFileCacheBackgroundClean

+ (instancetype)sharedInstance
{
    static dispatch_once_t __singletonToken;
    static id __singleton__;
    dispatch_once( &__singletonToken, ^{ __singleton__ = [[self alloc] init]; } );
    return __singleton__;
}

- (instancetype)init
{
    self = [super init];
    if (self){
        _fileCacheInfos = [@{} mutableCopy];
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cleanDisk)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(backgroundCleanDisk)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)setFileCacheInfo:(NSDictionary *)dic forKey:(NSString *)key
{
    if (dic.count == 0 || key == nil)
        return;
    
    [_fileCacheInfos setObject:dic forKey:key];
}

- (void)cleanDisk
{
    [self cleanDiskWithCompletionBlock:nil];
}

- (void)backgroundCleanDisk
{
    UIApplication *application = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];

    // Start the long-running task and return immediately.
    [self cleanDiskWithCompletionBlock:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
}

- (void)cleanDiskWithCompletionBlock:(void (^)(void))completion
{
    dispatch_async( [XYGCD sharedInstance].writeFileQueue, ^{
        [_fileCacheInfos enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self cleanDiskWithFileCacheInfo:obj];
        }];
        if (completion)
        {
            dispatch_async( dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

//清空文件
- (void)cleanDiskWithFileCacheInfo:(NSDictionary *)dic
{
    if (dic.count ==0) return;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = dic[@"path"];
    NSTimeInterval maxCacheAge = [dic[@"maxCacheAge"] doubleValue];
    NSUInteger maxCacheSize = [dic[@"maxCacheSize"] integerValue];
    
    NSURL *diskCacheURL = [NSURL fileURLWithPath:path isDirectory:YES];
    NSArray *resourceKeys = @[NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey];
    
    // This enumerator prefetches useful properties for our cache files.
    NSDirectoryEnumerator *fileEnumerator = [fileManager enumeratorAtURL:diskCacheURL
                                              includingPropertiesForKeys:resourceKeys
                                                                 options:NSDirectoryEnumerationSkipsHiddenFiles
                                                            errorHandler:NULL];
    
    NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-maxCacheAge];
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
        [fileManager removeItemAtURL:fileURL error:nil];
    }
    
    // If our remaining disk cache exceeds a configured maximum size, perform a second
    // size-based cleanup pass.  We delete the oldest files first.
    if (maxCacheSize > 0 && currentCacheSize > maxCacheSize)
    {
        // Target half of our maximum cache size for this cleanup pass.
        const NSUInteger desiredCacheSize = maxCacheSize / 2;
        
        // Sort the remaining cache files by their last modification time (oldest first).
        NSArray *sortedFiles = [cacheFiles keysSortedByValueWithOptions:NSSortConcurrent
                                                        usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                                            return [obj1[NSURLContentModificationDateKey] compare:obj2[NSURLContentModificationDateKey]];
                                                        }];
        
        // Delete files until we fall below our desired cache size.
        for (NSURL *fileURL in sortedFiles)
        {
            if ([fileManager removeItemAtURL:fileURL error:nil])
            {
                NSDictionary *resourceValues = cacheFiles[fileURL];
                NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
                currentCacheSize -= [totalAllocatedSize unsignedIntegerValue];
                
                if (currentCacheSize < desiredCacheSize) {
                    break;
                }
            }
        }
    }
}

@end
