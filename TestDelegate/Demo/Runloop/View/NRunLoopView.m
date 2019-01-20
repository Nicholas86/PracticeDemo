//
//  NRunLoopView.m
//  TestDelegate
//
//  Created by 泽娄 on 2019/1/20.
//  Copyright © 2019 a. All rights reserved.
//

#import "NRunLoopView.h"
#import "YYAsyncLayer.h"

@implementation NRunLoopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (Class)layerClass
{
    return [YYAsyncLayer class];
}

//- (void)setFrame:(CGRect)frame
//{
//    NSLog(@"frame: %f", frame.size.height);
//    [[YYTransaction transactionWithTarget:self selector:@selector(handleContentsNeedUpdated)] commit];
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [[YYTransaction transactionWithTarget:self selector:@selector(handleContentsNeedUpdated)] commit];
}

- (void)handleContentsNeedUpdated
{
    NSLog(@"更新");
    // do update
    [self.layer setNeedsDisplay];
}

- (YYAsyncLayerDisplayTask *)newAsyncDisplayTask
{
    NSLog(@"任务");
    
    YYAsyncLayerDisplayTask *task = [YYAsyncLayerDisplayTask new];
    task.willDisplay = ^(CALayer *layer) {
        //...
    };
    
    task.display = ^(CGContextRef context, CGSize size, BOOL(^isCancelled)(void)) {
        if (isCancelled()) return;
//        NSArray *lines = CreateCTLines(text, font, size.width);
//        if (isCancelled()) return;
//
//        for (int i = 0; i < lines.count; i++) {
//            CTLineRef line = line[i];
//            CGContextSetTextPosition(context, 0, i * font.pointSize * 1.5);
//            CTLineDraw(line, context);
//            if (isCancelled()) return;
//        }
    };
    
    task.didDisplay = ^(CALayer *layer, BOOL finished) {
        if (finished) {
            // finished
        } else {
            // cancelled
        }
    };
    
    return task;
}


@end
