//
//  NBlueView.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/10/20.
//  Copyright © 2018 a. All rights reserved.
//

#import "NBlueView.h"

@implementation NBlueView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSLog(@"%s", __FUNCTION__);
    // 调用[super hitTest:point withEvent:event]
    return [super hitTest:point withEvent:event];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"触摸事件");
//    [super touchesBegan:touches withEvent:event];
//}

@end
