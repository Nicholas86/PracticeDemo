//
//  NetWorkingReuest.h
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/5.
//  Copyright © 2018年 a. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger, NetworkErrorCode) {
    NSuccessCode = 0,      //!< 接口请求成功
    NErrorCode = 1,        //!< 接口请求失败
    NUnknownCode = -1,     //!< 未知错误
};

//成功回调
typedef void(^SuccessBlock)(NSDictionary *responseObject);
//失败回调
typedef void(^FailureBlock)(NSError *error);

//基础url
#define IOS_TIPS_API_HOST @"https://app.kangzubin.com/iostips/api/"


//1.小知识
#define FEED_List @"feed/listAll"


@interface NetWorkingReuest : AFHTTPSessionManager
//单例
+ (NetWorkingReuest *)shareInstance;

@end
