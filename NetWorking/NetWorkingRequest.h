//
//  NetWorkingRequest.h
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/25.
//  Copyright © 2018年 a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkingSessionManager.h"

@interface NetWorkingRequest : NSObject

//请求小知识
+ (void)netWorkTipsWithUrl:(NSString *)url
           parameters:(NSDictionary *)parameters
                cache:(CacheBlock )cache
              success:(SuccessBlock )success
              failure:(FailureBlock )failure;

@end
