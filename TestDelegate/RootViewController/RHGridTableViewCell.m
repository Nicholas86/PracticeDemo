//
//  RHGridTableViewCell.m
//  EasyTrade
//
//  Created by RongHang on 2018/11/14.
//  Copyright © 2018年 Rohon. All rights reserved.
//

#import "RHGridTableViewCell.h"
@interface RHContentView ()
@property (nonatomic, strong) NSArray <UIView *>*labelsArray;
@end

@implementation RHContentView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *labelViews = [NSMutableArray new];
        // 最大10个
        for (int i = 0; i < 10; i++) {
            UILabel *l = [[UILabel alloc] init];
            l.hidden = YES;
            [labelViews addObject:l];
            [self addSubview:l];
        }
        _labelsArray = labelViews;
    }return self;
}

- (void)setLabelDatas:(NSArray<NSString *> *)labelDatas
{
    // 外部数据源, 最大为9; 少于9, 显示
    _labelDatas = labelDatas;
    CGFloat w = 120;
    CGFloat h = 40;
    
    CGFloat margin = 5;
    
    [_labelDatas  enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 附坐标
        UILabel *l = (UILabel *)[_labelsArray objectAtIndex:idx];
        l.hidden = NO;
        l.text = obj;
        CGFloat x = (w + margin) * idx;
        CGFloat y = 0;
        l.frame = CGRectMake(x, y, w, h);
    }];
    
    
    CGFloat width = _labelDatas.count * w + (_labelDatas.count - 1) * margin;
    NSLog(@"width, %.2f", width);
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
    
    CGRect cell_frame = _cell.frame;
    cell_frame.size.width = width;
    _cell.frame = cell_frame;
    
}


@end


@implementation RHGridTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _rh_contentView = [[RHContentView alloc] init];
        _rh_contentView.cell = self;
        [self.contentView addSubview:_rh_contentView];
        
    }return self;
}

// 为cell赋值
- (void)setObject:(NSObject *)object
{
    _rh_contentView.labelDatas = @[@"合约名称",@"多空",@"手数",@"可用",@"开仓均价",@"盈亏",@"今",@"昨",@"持仓均价",@"逐日盈亏"];
}

@end



