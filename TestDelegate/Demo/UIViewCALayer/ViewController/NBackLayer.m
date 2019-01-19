//
//  NBackLayer.m
//  TestDelegate
//
//  Created by 泽娄 on 2019/1/13.
//  Copyright © 2019 a. All rights reserved.
//

#import "NBackLayer.h"
#import <UIKit/UIKit.h>

@interface NBackLayer(){
    NSInteger count;
}

@end

@implementation NBackLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        count = 0;
        NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);
        // 会在目标View上敷上一层黑色的透明薄膜。
        self.backgroundColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
        // 边框
        self.borderColor = [[UIColor blueColor] CGColor];
        self.borderWidth = 2.0;
        // 圆角
        self.cornerRadius = 10.0;
        
        // 阴影
        self.shadowColor = [[UIColor greenColor] CGColor];
        self.shadowOpacity = 0.5;
        self.shadowOffset = CGSizeMake(2, 1);
    }return self;
}

- (void)display
{
    [super display];
    count++;
    NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);
}

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    count++;
    NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);
}

- (void)setNeedsDisplayInRect:(CGRect)r
{
    [super setNeedsDisplayInRect:r];
    count++;
    NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);

}

/* Returns true when the layer is marked as needing redrawing. */

- (BOOL)needsDisplay
{
    [super needsDisplay];
    count++;
    NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);
    return YES;
}

/* Call -display if receiver is marked as needing redrawing. */

- (void)displayIfNeeded
{
    [super displayIfNeeded];
    count++;
    NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);
}


- (void)setNeedsLayout
{
    [super setNeedsLayout];
    count++;
    NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);
}

/* Returns true when the receiver is marked as needing layout. */

- (BOOL)needsLayout
{
    [super needsLayout];
    count++;
    NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);
    return YES;
}

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
    count++;
    NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);
}

- (void)layoutSublayers
{
    [super layoutSublayers];
    count++;
    NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),(long)count);
}

@end
