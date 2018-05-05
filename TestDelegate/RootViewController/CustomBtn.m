//
//  CustomBtn.m
//  TestDelegate
//
//  Created by a on 2018/2/5.
//  Copyright © 2018年 a. All rights reserved.
//

#import "CustomBtn.h"

@implementation CustomBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/*
 
 即将显示的时候,改变坐标
 先于layoutSubviews执行
 */
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    //接收所有单元格个数 数据源代理是必须实现的,不用判断respondsToSelector
    NSInteger rows = [self.dataSource numberOfRowsInSection:2];
    NSLog(@"rows:%ld", (long)rows);

    if ([self.delegate respondsToSelector:@selector(passTitleString:)]) {
        CGFloat height = [self.delegate  passTitleString:@"山楂条"];
        [self  setTitle:[NSString stringWithFormat:@"标题:%.2f", height] forState:UIControlStateNormal];
        NSLog(@"接收返回值height:%.2f", height);
        //根据单元格个数,每个单元格高度,返回总高度
        CGRect btnFrame = self.frame;
        btnFrame.size.height = height * rows;
        self.frame = btnFrame;
    }

}

/*
 
 layoutSubviews后执行
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"layoutSubviews后执行");
}

@end
