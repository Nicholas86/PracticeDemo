//
//  EOCSquare.h
//  TestDelegate
//
//  Created by a on 2018/3/7.
//  Copyright © 2018年 a. All rights reserved.
//

#import "EOCRectangle.h"

@interface EOCSquare : EOCRectangle
/*
 全能初始化方法
 */
- (instancetype)initWithDimension:(float )dimension;

//便利构造器
+ (instancetype)eocSquareWithDimension:(float )dimension;

@end
