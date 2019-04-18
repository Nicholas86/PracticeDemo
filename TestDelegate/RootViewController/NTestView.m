//
//  NTestView.m
//  TestDelegate
//
//  Created by RongHang on 2018/11/14.
//  Copyright © 2018年 a. All rights reserved.
//

#import "NTestView.h"

@interface NTestView(){
    NSInteger count;
}

@end

@implementation NTestView

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    [super drawLayer:layer inContext:ctx];
    count++;
    NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    count++;
    NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        count = 0;
        NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);
    } return self;
}

- (void)willMoveToSuperview:(nullable UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    count++;
    NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    count++;
    NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);
}

- (void)willMoveToWindow:(nullable UIWindow *)newWindow{
    [super willMoveToWindow:newWindow]; count++;
    NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);
}

- (void)didMoveToWindow{
    [super didMoveToWindow];
    count++;
    NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    count++;
    NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);
}

- (void)didAddSubview:(UIView *)subview{
    [super didAddSubview:subview];
    count++;
    NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);
    
}

- (void)willRemoveSubview:(UIView *)subview{
    [super willRemoveSubview:subview];
    count++;
    NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);
    
}


- (void)removeFromSuperview{
    [super removeFromSuperview];
    count++;
    NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);
    
}


- (void)dealloc{
    count++;
    NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);
    
}

@end






