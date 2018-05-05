//
//  EOCSquare.m
//  TestDelegate
//
//  Created by a on 2018/3/7.
//  Copyright © 2018年 a. All rights reserved.
//

#import "EOCSquare.h"

@implementation EOCSquare
/*
 全能初始化方法
 */
- (instancetype)initWithDimension:(float)dimension
{
    //调用父类的全能初始化方法。此时并不会调下面的 '重写父类的全能初始化方法'
    return [super initWithWidth:dimension height:dimension];
}


//重写父类的全能初始化方法
- (instancetype)initWithWidth:(float)width height:(float)height
{
    NSLog(@"重写父类的全能初始化方法");
    float dimension = MAX(width, height);
    return [self initWithDimension:dimension];
}


//便利构造器
+ (instancetype)eocSquareWithDimension:(float )dimension
{
    return [[self alloc] initWithDimension:dimension];
}

@end





