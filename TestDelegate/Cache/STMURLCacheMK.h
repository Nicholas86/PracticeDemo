//
//  STMURLCacheMK.h
//  TestDelegate
//
//  Created by a on 2018/3/22.
//  Copyright © 2018年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STMURLCacheModel;

@interface STMURLCacheMK : NSObject

@property (nonatomic, strong) STMURLCacheModel *cacheModel;

- (STMURLCacheMK *)memoryCapacity;//内存容量
- (STMURLCacheMK *)diskCapacity;//本地存储容量
- (STMURLCacheMK *)cacheTime;//缓存时长
- (STMURLCacheMK *)subDirectory;//子目录
- (STMURLCacheMK *)isDownloadMode;//是否启动下载模式BOOL
- (STMURLCacheMK *)whiteListsHost;//域名白名单数组
- (STMURLCacheMK *)whiteUserAgent;//webview的user-agent白名单
- (STMURLCacheMK *)addHostWhiteList;//添加一个域名白名单
- (STMURLCacheMK *)addRequestUrlWhiteList;//添加请求白名单

//NSURLProtocol相关设置
- (STMURLCacheMK *)isUsingURLProtocol;//是否使用URLProtocolBOOL

//替换请求
- (STMURLCacheMK *)replaceUrl;//是否使用URLProtocolBOOL
- (STMURLCacheMK *)replaceData;//是否使用URLProtocolBOOL



@end
