//
//  NOrangeView.m
//  TestDelegate
//
//  Created by 泽娄 on 2019/9/5.
//  Copyright © 2019 a. All rights reserved.
//

#import "NOrangeView.h"

@implementation NOrangeView

/*
 显示控件有了两个方法来做上面这件事，就是常说的hitTest
 先判断点是否在View内部，然后遍历subViews
 整个过程的系统实现大致如下
 */

- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event
{
    NSLog(@"%s", __FUNCTION__);
    //[super hitTest:point withEvent:event];
    /*
     判断是否合格
     1.判断下窗口能否接收事件
     */
    
    if(self.userInteractionEnabled == NO || self.hidden == YES||self.alpha <= 0.01){
        
        return nil;
    }
    
    /*
     判断点击位置是否在自己区域内部
     2. 判断下点在不在窗口上
     不在窗口上
     
     如果要解决 按钮超出父视图的范围无法响应点击事件的问题, 就需要将
     pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event 始终返回YES
     */
    
    if([self pointInside:point withEvent:event] == NO){
        
        return nil;
    }
    
    // 3.从后往前遍历子控件数组
    int count = (int)self.subviews.count;
    //NSLog(@"子控件个数, %d", count);
    for (int i = count - 1; i >= 0; i--) {
        // 获取子控件
        UIView *childView = self.subviews[i];
        //NSLog(@"子控件childView, tag:%ld", childView.tag);
        // 把触摸点坐标转换成子控件(_lightBtn按钮)上所在坐标系
        CGPoint childPoint = [self convertPoint:point toView:childView];
        if(childView && CGRectContainsPoint(childView.bounds, childPoint)) {
            //NSLog(@"返回子控件view, tag:%ld", childView.tag);
            
            // ******子控件必须调用hitTest: withEvent: 方法, 不然事件不传递到子控件 ******//
            
            // 返回最合适的view
            return [childView hitTest:childPoint withEvent:event];
        }
    }
    
    // 4.没有找到更合适的view，也就是没有比自己更合适的view
    //NSLog(@"没有找到更合适的view, 自己就是更合适的view");
    return self;
}

/*
 判断点是否在这个View内部
 作用:判断下传入过来的点在不在方法调用者的坐标系上
 point:是方法调用者坐标系上的点
 
 如果要解决 按钮超出父视图的范围无法响应点击事件的问题, 就需要将
 pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event 始终返回YES
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event
{
    //NSLog(@"判断点是否在这个View内部");
    return YES;
}

@end
