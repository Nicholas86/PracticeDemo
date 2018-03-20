//
//  EOCRectangle.h
//  TestDelegate
//
//  Created by a on 2018/3/7.
//  Copyright © 2018年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 矩形
 */

@interface EOCRectangle : NSObject
/*
 宽、高设定成 只读
 */
@property (nonatomic, assign, readonly) float width;

@property (nonatomic, assign, readonly) float height;

//初始化方法
- (instancetype)initWithWidth:(float )width
                       height:(float )height;

//便利构造器方法
+ (instancetype)eocRectangleWithWidth:(float )width
                               height:(float )height;

@end




