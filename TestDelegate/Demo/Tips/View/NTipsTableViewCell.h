//
//  NTipsTableViewCell.h
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/5.
//  Copyright © 2018年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NTipsModel;

@interface NTipsTableViewCell : UITableViewCell
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
//日期、作者、平台
@property (weak, nonatomic) IBOutlet UILabel *dateOutherLabel;

//赋值
- (void)cellForRowWithTipsModel:(NTipsModel *)model;

@end
