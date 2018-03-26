//
//  STMURLCache.m
//  TestDelegate
//
//  Created by a on 2018/3/21.
//  Copyright © 2018年 a. All rights reserved.
//

#import "STMURLCache.h"
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>

@interface  STMURLCache()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *wbView; //用于预加载的webview
@property (nonatomic, strong) NSMutableArray *preLoadWebUrls; //预加载的webview的url列表
@property (nonatomic) BOOL isUseHtmlPreload;

@end

@implementation STMURLCache

//初始化并开启缓存
- (STMURLCache *)initSTMURLCache
{
    self = [super init];
    if (self) {
    }return self;
}

//使用WebView进行预加载缓存
- (STMURLCache *)preLoadSTMURLCacheByWebViewUrls:(NSArray *)urls
{
    //数组为空,直接返回
    if (urls.count == 0) {
        return self;
    }
    
    self.wbView = [[UIWebView  alloc] init];
    _wbView.delegate = self;
    self.preLoadWebUrls = [NSMutableArray  arrayWithArray:urls];
    //发起请求,只加载第一个
    [self  requestWebviewWithFirstPreUrl];
    return self;
}

//使用以html内容在WebView里读取进行内容预加载缓存
- (STMURLCache *)preLoadSTMURLCacheByWebViewHtmls:(NSArray *)htmls
{
    return self;
}

//使用url
- (STMURLCache *)preLoadSTMURLCacheByRequestWithUrls:(NSArray *)urls
{
    return self;
}

//关闭缓存
- (void)stop
{
    
}



#pragma mark 工具
- (void)requestWebviewWithFirstPreUrl
{
    NSURLRequest *request = [NSURLRequest  requestWithURL:[NSURL  URLWithString:self.preLoadWebUrls.firstObject] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [self.wbView   loadRequest:request];
}



@end





