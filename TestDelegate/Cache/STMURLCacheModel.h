//
//  STMURLCacheModel.h
//  TestDelegate
//
//  Created by a on 2018/3/21.
//  Copyright © 2018年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STMURLCacheModel : NSObject

@property (nonatomic, assign) NSUInteger memoryCapacity;//内存容量
@property (nonatomic, assign) NSUInteger diskCapacity;//磁盘容量
@property (nonatomic, assign) NSUInteger cacheTime;//缓存时长
@property (nonatomic, copy)   NSString *subDirectory;//子目录

@property (nonatomic, assign) BOOL isDownloadMode;//是否为下载模式
@property (nonatomic, assign) BOOL isSaveOnDisk;//是否存磁盘

@property (nonatomic, copy) NSString *diskPath;//磁盘路径
@property (nonatomic, strong) NSMutableDictionary *responseDic;//防止下载请求的循环调用字典

@property (nonatomic,copy) NSString *cacheFolder;//缓存文件夹

@property (nonatomic, strong) NSMutableDictionary *whiteListsHostDic;//域名白名单字典
@property (nonatomic, strong) NSMutableDictionary *whiteListsRequestUrlDic;//请求地址白名单字典
@property (nonatomic, copy)   NSString *whiteUserAgent;//webview的user-agent白名单

@property (nonatomic, copy) NSString *replaceUrl;
@property (nonatomic, copy) NSString *replaceData;

//NSURLProtocol
@property (nonatomic, assign) BOOL isUsingURLProtocol;//是否使用URLProtocol

//1.查找请求对应的文件路径
- (NSString *)filePathFromRequest:(NSURLRequest *)request isInfo:(BOOL)isInfo;

//2.清除请求对应的缓存
- (void)removeCacheFileWithRequest:(NSURLRequest *)request;

//3.根据请求进行判断localResourcePathDic是否已经缓存,有:返回NSCachedURLResponse,没有:返回nil
- (NSCachedURLResponse *)localResourcePathDicWithRequest:(NSURLRequest *)request;

//4.全部清除自建的缓存目录
- (void)checkCapacity;

#pragma mark 单例初始化
//for NSURLProtocol
+ (STMURLCacheModel *)shareInstance;

//5.md5加密
+ (NSString *)md5HashWithString:(NSString *)str;

@end






