//
//  NTipsViewModel.h
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/5.
//  Copyright © 2018年 a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkingReuest.h"

@interface NTipsViewModel : NSObject
//请求iOS小知识数据
- (void)requestTipsDataWithPage:(NSInteger )page
                       successBlock:(SuccessBlock )successBlock
                       failureBlock:(FailureBlock )failureBlock;
@end
