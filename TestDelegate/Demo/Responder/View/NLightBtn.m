//
//  NLightBtn.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/10/20.
//  Copyright © 2018 a. All rights reserved.
//

#import "NLightBtn.h"

@implementation NLightBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/*
 显示控件有了两个方法来做上面这件事，就是常说的hitTest
 先判断点是否在View内部，然后遍历subViews
 整个过程的系统实现大致如下
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSLog(@"%s", __FUNCTION__);
    // 调用[super hitTest:point withEvent:event]
    return [super hitTest:point withEvent:event];
}

//
//- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event
//{
//    NSLog(@"%s", __FUNCTION__);
//    /*
//     判断是否合格
//     1.判断下窗口能否接收事件
//     */
//    
//    if(self.userInteractionEnabled == NO || self.hidden == YES||self.alpha <= 0.01){
//        
//        return nil;
//    }
//    
//    /*
//     判断点击位置是否在自己区域内部
//     2. 判断下点在不在窗口上
//    不在窗口上
//
//     如果要解决 按钮超出父视图的范围无法响应点击事件的问题, 就需要将
//     pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event 始终返回YES
//     */
//    
//    if([self pointInside:point withEvent:event] == NO){
//        
//        return nil;
//    }
//    
//    
//    // 3.从后往前遍历子控件数组
//    int count = (int)self.subviews.count;
//    NSLog(@"子控件个数, %d", count);
//    for (int i = count - 1; i >= 0; i--) {
//        // 获取子控件
//        UIView *childView = self.subviews[i];
//        // 把自己控件上的点转换成子控件上的点
//        CGPoint childPoint = [self convertPoint:point toView:childView];
//        if(childView && CGRectContainsPoint(childView.bounds, childPoint)) {
//            // ******子控件必须调用hitTest: withEvent: 方法, 不然事件不传递到子控件 ******//
//            NSLog(@"返回子控件view, tag:%ld", (long)childView.tag);
//            // 返回最合适的view
//            return [childView hitTest:childPoint withEvent:event];
//        }
//    }
//    
//    // 4.没有找到更合适的view，也就是没有比自己更合适的view
//    NSLog(@"没有找到更合适的view, 自己就是更合适的view");
//    return self;
//}
//
///*
// 判断点是否在这个View内部
// 作用:判断下传入过来的点在不在方法调用者的坐标系上
// point:是方法调用者坐标系上的点
// */
//- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event
//{
//    //NSLog(@"判断点是否在这个View内部");
//    return YES;
//}


/*
技巧

以上可知默认情况下，用户点击哪个View,系统就会在寻找过程中返回哪个view，但是我们可以重载上面两个方法做如下事情：
* 将控件外部点规整到控件内部。 例如控件较小，点击位置在控件边缘外部，可以重载
 - (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event; 将外部的点也判断为内部点，这样hitTest就会遍历自己。
 
* 重载HitTest更改默认行为。 有时候点击subView的某些特殊位置需要superView处理，我们可以在superView的hitTest，返回superView。这样superView变成首部响应者
hitTest的逻辑代码中会把隐藏，透明（alpha<0.01,不是backgroundColor为clearColor），不交互的view滤过，但不代表hitTest不会被调用，我们可以重载hitTest去让 已经隐藏、透明、不交互的view响应事件。不过最正规的方法是打开控件交互属性。

 以上过程返回的View被称作hitTestView，顺着hitTestView的nextResponser,可以形成一个链，即响应链。 最后指向appDelegate. 并且返回hitTestView之后，系统会持有hitTestView。事件不结束，这个hitTestView不会发生变化，即使用户点击之后将手指移动到其他控件上面，该点击都会绑定开始的hitTestView。当所有手指离开屏幕，事件结束。再次点击，事件重新开始。以上过程再来一次。
*/

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"触摸事件");
//    [super touchesBegan:touches withEvent:event];
//}

@end
