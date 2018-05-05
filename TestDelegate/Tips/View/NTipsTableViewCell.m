//
//  NTipsTableViewCell.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/5.
//  Copyright © 2018年 a. All rights reserved.
//

#import "NTipsTableViewCell.h"
#import "NTipsModel.h"

@implementation NTipsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//赋值
- (void)cellForRowWithTipsModel:(NTipsModel *)model
{
    self.titleLable.text = model.title;
    self.dateOutherLabel.text = [NSString  stringWithFormat:@"%@ %@.%@", model.postdate, model.auther, model.platformString];
}

@end


