//
//  XYFileCacheBackgroundClean.h
//  TestDelegate
//
//  Created by a on 2018/5/24.
//  Copyright © 2018年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark- XYFileCacheBackgroundClean
@interface XYFileCacheBackgroundClean : NSObject

@property (nonatomic ,strong) NSMutableDictionary *fileCacheInfos;

+ (instancetype)sharedInstance;

- (void)setFileCacheInfo:(NSDictionary *)dic forKey:(NSString *)key;

@end
