//
//  PopViewController.h
//  TestDelegate
//
//  Created by a on 2018/2/5.
//  Copyright © 2018年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopViewControllerDelegate<NSObject>
// 返回高
- (CGFloat)passTitleString:(NSString *)titleString;
@end

@interface PopViewController : UIViewController

@property (nonatomic, weak) id<PopViewControllerDelegate>delegate;

@end

