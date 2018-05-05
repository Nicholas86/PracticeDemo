//
//  NTipsViewModel.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/5.
//  Copyright © 2018年 a. All rights reserved.
//

#import "NTipsViewModel.h"
#import "NTipsModel.h" //封装模型model

@implementation NTipsViewModel
//请求iOS小知识数据
- (void)requestTipsDataWithPage:(NSInteger )page
                       successBlock:(SuccessBlock )successBlock
                       failureBlock:(FailureBlock )failureBlock
{
    NSDictionary *paramDic = @{
                               @"page":@(page),
                               @"version":@"1.0"
                               };
    
    NSString *url = [NSString  stringWithFormat:@"%@%@", IOS_TIPS_API_HOST, FEED_List];
    
    NetWorkingReuest *netWorkingRequest = [NetWorkingReuest  shareInstance];
    
    [netWorkingRequest  GET:url parameters:paramDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //NSLog(@"responseObject: %@", (NSDictionary *)responseObject);

        id responseDic = [NSJSONSerialization   JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"responseDic: %@", responseDic);
        
        if ([responseDic  isKindOfClass:[NSDictionary class]] && [[responseDic  allKeys] count] > 0) {
            
            NSInteger code = [responseDic[@"code"] integerValue];
            if (code != NSuccessCode) {
                // 网络请求成功，但接口返回的 Code 表示失败，这里给 *error 赋值，后续走 failureBlock 回调
                NSLog(@"网络请求失败");
                successBlock(nil);
            } else {
                // 返回的 Code 表示成功，对数据进行加工过滤，返回给上层业务
                NSDictionary *resultData = responseDic[@"data"];
                //成功回调
                successBlock(resultData);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //失败回调
        failureBlock(error);
    }];
}
@end
