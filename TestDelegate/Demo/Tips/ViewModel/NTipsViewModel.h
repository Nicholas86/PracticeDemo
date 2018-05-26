//
//  NTipsViewModel.h
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/5.
//  Copyright © 2018年 a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkingRequest.h"
@class NTipsModel;

@interface NTipsViewModel : NSObject

#warning 两个数组原因
/*
 定义两个数组原因:
 解决UItableview上拉加载更多, 数据重复问题
*/


//本地缓存的数据源
@property (nonatomic, strong) NSMutableArray <NTipsModel *>*cacheDataSource;

//网络请求的数据源
@property (nonatomic, strong) NSMutableArray <NTipsModel *>*httpDataSource;

//请求iOS小知识数据
- (void)requestTipsDataWithPage:(NSInteger )page
                          cache:(CacheBlock )cache
                       successBlock:(SuccessBlock )successBlock
                       failureBlock:(FailureBlock )failureBlock;
@end
