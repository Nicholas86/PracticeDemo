//
//  NManualExecuteOperation.h
//  TestDelegate
//
//  Created by 泽娄 on 2018/12/18.
//  Copyright © 2018 a. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NManualExecuteOperation : NSObject
- (BOOL)manualPerformOperation:(NSOperation *)operation;
@end

NS_ASSUME_NONNULL_END
