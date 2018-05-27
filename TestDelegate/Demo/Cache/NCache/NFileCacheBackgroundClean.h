//
//  NFileCacheBackgroundClean.h
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/27.
//  Copyright © 2018年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFileCacheBackgroundClean : NSObject

@property (nonatomic ,strong) NSMutableDictionary *fileCacheInfos;

//单例
+ (instancetype)share;

- (void)setFileCacheInfo:(NSDictionary *)dic forKey:(NSString *)key;

@end
