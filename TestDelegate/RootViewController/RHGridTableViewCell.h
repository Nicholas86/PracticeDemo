//
//  RHGridTableViewCell.h
//  EasyTrade
//
//  Created by RongHang on 2018/11/14.
//  Copyright © 2018年 Rohon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RHGridTableViewCell;


@protocol RHContentViewDelegate <NSObject>

- (void)didClickLikeButtonInCell:(UITableViewCell *)cell;
- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell;

@end


@interface RHContentView : UIView
@property (nonatomic, weak) RHGridTableViewCell *cell;
@property (nonatomic, assign) id<RHContentViewDelegate> delegate;
@property (nonatomic, strong) NSArray<NSString *> *labelDatas; // label
@end

@interface RHGridTableViewCell : UITableViewCell
@property (nonatomic, strong) RHContentView *rh_contentView;
- (void)setObject:(NSObject *)object;
@end
