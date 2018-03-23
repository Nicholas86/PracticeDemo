//
//  STMURLCacheDelegate.h
//  TestDelegate
//
//  Created by a on 2018/3/21.
//  Copyright © 2018年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STMURLCacheDelegate <NSObject>
//开始加载
- (void)preloadDidStartLoad;
//单个加载完成
- (void)preloadDidFinishLoad:(UIWebView *)webView remain:(NSUInteger)remain;
//加载失败
- (void)preloadDidFailLoad;
//全部加载完成
- (void)preloadDidAllDone;
@end
