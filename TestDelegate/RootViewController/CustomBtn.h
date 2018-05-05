//
//  CustomBtn.h
//  TestDelegate
//
//  Created by a on 2018/2/5.
//  Copyright © 2018年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

//数据源
@protocol CustomBtnDataSource<NSObject>

@required

// 返回有多少行cell
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

@end

//代理方法
@protocol CustomBtnDelegate<NSObject>
// 返回高
- (CGFloat)passTitleString:(NSString *)titleString;
@end

@interface CustomBtn : UIButton

//数据源代理
@property (nonatomic, weak) id<CustomBtnDataSource> dataSource;

//代理 -- 高度
@property (nonatomic, weak) id<CustomBtnDelegate> delegate;

@end
