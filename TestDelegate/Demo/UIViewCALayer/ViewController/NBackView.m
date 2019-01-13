//
//  NBackView.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/10/14.
//  Copyright © 2018年 a. All rights reserved.
//

#import "NBackView.h"
#import "NBackLayer.h"

@interface NBackView(){
    NSInteger count;
}

@end


@implementation NBackView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    
    count++;
    NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    count++;
    NSLog(@"绘制任务: 当UIView需要显示到屏幕上时，会调用drawRect:方法进行绘图，并且会将所有内容绘制在自己的图层上，绘图完毕后，系统会将图层拷贝到屏幕上，于是就完成了UIView的显示。换句话说，UIView本身不具备显示的功能，是它内部的图层有显示功能。 ==> %@",NSStringFromSelector(_cmd));
}

+ (Class)layerClass
{
    NSLog(@"返回自定义calyer对象");
    return [NBackLayer class];
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
