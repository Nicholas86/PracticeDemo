//
//  STMURLCache.h
//  TestDelegate
//
//  Created by a on 2018/3/21.
//  Copyright © 2018年 a. All rights reserved.
//

/*
 缓存网络请求
 */

#import <Foundation/Foundation.h>
@class ViewController;
@protocol STMURLCacheDelegate;

@interface STMURLCache : NSURLCache

@property (nonatomic, strong) ViewController *viewController;
@property (nonatomic, assign) id<STMURLCacheDelegate> delegate;

//初始化并开启缓存
- (STMURLCache *)initSTMURLCache;

//使用WebView进行预加载缓存
- (STMURLCache *)preLoadSTMURLCacheByWebViewUrls:(NSArray *)urls;

//使用以html内容在WebView里读取进行内容预加载缓存
- (STMURLCache *)preLoadSTMURLCacheByWebViewHtmls:(NSArray *)htmls;

//使用url
- (STMURLCache *)preLoadSTMURLCacheByRequestWithUrls:(NSArray *)urls;

//关闭缓存
- (void)stop;

@end





