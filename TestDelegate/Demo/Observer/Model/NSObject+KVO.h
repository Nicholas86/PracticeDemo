//
//  NSObject+KVO.h
//  TestDelegate
//
//  Created by 泽娄 on 2018/12/18.
//  Copyright © 2018 a. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^NObservingBlock)(id observedObject, NSString *observedKey, id oldValue, id newValue);

@interface NSObject (KVO)

- (void)N_addObserver:(NSObject *)observer
                forKey:(NSString *)key
             withBlock:(NObservingBlock)block;

- (void)N_removeObserver:(NSObject *)observer forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
