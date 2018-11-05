//
//  YYAsyncLayer.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/4/11.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#if __has_include(<YYAsyncLayer/YYAsyncLayer.h>)
FOUNDATION_EXPORT double YYAsyncLayerVersionNumber;
FOUNDATION_EXPORT const unsigned char YYAsyncLayerVersionString[];
#import <YYAsyncLayer/YYSentinel.h>
#import <YYAsyncLayer/YYTransaction.h>
#else
#import "YYSentinel.h"
#import "YYTransaction.h"
#endif

@class YYAsyncLayerDisplayTask;

NS_ASSUME_NONNULL_BEGIN


/**
 YYAsyncLayer是异步渲染的CALayer子类
 */
@interface YYAsyncLayer : CALayer
/// Whether the render code is executed in background. Default is YES.
//是否异步渲染
@property BOOL displaysAsynchronously;
@end


/**
 YYAsyncLayer's的delegate协议，一般是uiview。必须实现这个方法
 */
@protocol YYAsyncLayerDelegate <NSObject>
@required
//当layer的contents需要更新的时候，返回一个新的展示任务
- (YYAsyncLayerDisplayTask *)newAsyncDisplayTask;
@end


/**
 YYAsyncLayer在后台渲染contents的显示任务类
 */
@interface YYAsyncLayerDisplayTask : NSObject

/**
 这个block会在异步渲染开始的前调用，只在主线程调用。
 */
@property (nullable, nonatomic, copy) void (^willDisplay)(CALayer *layer);

/**
 这个block会调用去显示layer的内容
 */
@property (nullable, nonatomic, copy) void (^display)(CGContextRef context, CGSize size, BOOL(^isCancelled)(void));


/**
 这个block会在异步渲染结束后调用，只在主线程调用。
 */
@property (nullable, nonatomic, copy) void (^didDisplay)(CALayer *layer, BOOL finished);

@end

NS_ASSUME_NONNULL_END
