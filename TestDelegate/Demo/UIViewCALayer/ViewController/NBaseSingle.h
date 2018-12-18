//
//  NBaseSingle.h
//  TestDelegate
//
//  Created by 泽娄 on 2018/12/13.
//  Copyright © 2018 a. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NBaseSingle : NSObject
+ (instancetype)share;

- (void)creatTimerWithBlock:(dispatch_block_t )block;

- (void)sendHeart;
@end

NS_ASSUME_NONNULL_END
