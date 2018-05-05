//
//  EOCRectangle.m
//  TestDelegate
//
//  Created by a on 2018/3/7.
//  Copyright © 2018年 a. All rights reserved.
//

#import "EOCRectangle.h"

@implementation EOCRectangle

//全能初始化方法
- (instancetype)initWithWidth:(float)width height:(float)height
{
    self = [super init];//调用系统父类init。这里只会调用系统父类init,并不会调用下面重写的 系统父类init方法。
    if (self) {
        _width = width;
        _height = height;
        NSLog(@"父类全能初始化方法");
    }return self;
}

//重写 系统 父类 init方法,调用 全能初始化方法 设置默认值。
- (instancetype)init
{
    NSLog(@"重写系统 init 方法");
    return [self initWithWidth:5 height:7];
}



//便利构造器方法
+ (instancetype)eocRectangleWithWidth:(float)width height:(float)height
{
    return [[self alloc] initWithWidth:width height:height];
}


@end











