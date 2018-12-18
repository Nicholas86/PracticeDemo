//
//  NCreateInvocationOperation.h
//  TestDelegate
//
//  Created by 泽娄 on 2018/12/18.
//  Copyright © 2018 a. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NCreateInvocationOperation : NSObject
- (NSInvocationOperation *)invocationOperationWithData:(id)data;
- (NSInvocationOperation *)invocationOperationWithData:(id)data userInput:(NSString *)userInput;
@end

NS_ASSUME_NONNULL_END
