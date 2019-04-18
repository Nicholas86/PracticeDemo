//
//  UILabel+StringAction.h
//  TestDelegate
//
//  Created by mac on 2019/3/5.
//  Copyright © 2019 a. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol StringActionDelegate <NSObject>
@optional
/**
 *  StringAction
 *
 *  @param string  点击的字符串
 *  @param range   点击的字符串range
 *  @param index 点击的字符在数组中的index
 */
- (void)n_tapAttributeInLabel:(UILabel *)label
                        string:(NSString *)string
                         range:(NSRange)range
                         index:(NSInteger)index;
@end


NS_ASSUME_NONNULL_BEGIN

@interface UILabel (StringAction)

/// 是否打开点击效果, 默认打开
@property (nonatomic, assign) BOOL enableTapAnimated;

/// 点击高亮色, 默认是[UIColor lightGrayColor] 需打开enableTapAnimated才有效
@property (nonatomic, strong) UIColor * tapHighlightedColor;

/// 是否扩大点击范围, 默认是打开
@property (nonatomic, assign) BOOL enlargeTapArea;


/**
 *  给文本添加点击事件Block回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param tapClick 点击事件回调
 */
- (void)n_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
                                 tapClicked:(void (^) (UILabel * label, NSString *string, NSRange range, NSInteger index))tapClick;

/**
 *  给文本添加点击事件delegate回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param delegate delegate
 */
- (void)n_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
                                   delegate:(id <StringActionDelegate> )delegate;


/**
 *  删除label上的点击事件
 */
- (void)n_removeAttributeTapActions;


@end

NS_ASSUME_NONNULL_END
