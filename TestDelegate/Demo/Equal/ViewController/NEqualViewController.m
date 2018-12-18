//
//  NEqualViewController.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/12/14.
//  Copyright © 2018 a. All rights reserved.
//

#import "NEqualViewController.h"
#import "NCHPerson.h"

@interface NEqualViewController ()

@end

@implementation NEqualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"对象等同性";
    
    // [self testString];
    [self testNCHPerson];
    // [self testSet];
}


- (void)testString
{
    NSString *foo = @"Bader 123";
    NSString *bar = [NSString stringWithFormat:@"Bader %d", 123];
    BOOL qualA = (foo == bar); // 判断内存地址
    NSLog(@"qualA, %d, foo: %p, bar:%p", qualA, &foo, &bar);
    
    BOOL qualB = [foo isEqual:bar];
    NSLog(@"qualB, %d", qualB);

    BOOL qualC = [foo isEqualToString:bar];
    NSLog(@"qualC, %d", qualC);
    /*
     可以看到, 调用isEqualToString 比调用isEqual方法快, 后者还要执行额外的步骤,因为它不知道受测对象的类型
     NSObject协议中有两个用于判断等同性的关键方法:
     - (BOOL)isEqual:(id)object;
     - (NSUInteger)hash;
     NSObject类对这两个方法的默认实现是:当且仅当其"指针值"(可以理解成内存地址)完全相等时, 这两个对象才相等。
     若想在自定义的对象中正确覆写这些方法, 就必须先理解其约定
     如果isEqual方法判断两个对象相等, 那么其hash方法也必须返回同一个值。
     但是, 如果两个对象的hash方法返回同一个值, 那么isEqual方法未必会认为两者相等
     
     注意:有时我们可能认为一个类的实例可以与其子类实例相等.
     */
}

- (void)testNCHPerson
{
    NCHPerson *person_0 = [[NCHPerson alloc] initWithIdentifier:@"1" FirstName:@"哈" lastName:@"呀" age:8];
    NCHPerson *person_1 = [[NCHPerson alloc] initWithIdentifier:@"2" FirstName:@"哈" lastName:@"呀" age:8];
    NSLog(@"对象相等, %d", [person_0 isEqual:person_1]);
}


- (void)testSet
{
    NSMutableSet *set = [NSMutableSet new];
    
    NSMutableArray *arrayA = [@[@1, @2] mutableCopy];
    [set addObject:arrayA];
    NSLog(@"set: %@", set);
    
    NSMutableArray *arrayB = [@[@1, @2] mutableCopy];
    [set addObject:arrayB];
    NSLog(@"set: %@", set);

    NSMutableArray *arrayC = [@[@1] mutableCopy];
    [set addObject:arrayC];
    NSLog(@"set: %@", set);
    
    [arrayC addObject:@2];
    NSLog(@"set: %@", set);
    
    NSLog(@"copy, set: %@", [set copy]);
/*
 
 把某个对象放入collection之后,就不应再改变其哈希码了.因为,collection会把各个对象按照其哈希码封装到不同的"箱子数组"中.如果某对象在放入"箱子"之后哈希码又变了,那么其所处的这个箱子对它来说就是"错误"的.要想解决这个问题,需要确保哈希码不是根据对象的"可变部分"计算出来的,或是保证放入collection之后就不再改变对象内容了.
 
 如图所示,我们修改了arrayC从而导致set中出现了两个相同的对象.这个例子并不是说这样做就是错的,这种结果在某些情况下可能正是我们需要的结果,这里只是说明这么做会造成什么样的后果
 */
}
/*
 再谈数组、集合、字典与 hash、isEqual 方法的关联 」
 
 我们或多或少了解，Objective-C 中的 NSArray、NSSet、NSDictionary 与 NSObject 及其子类对象的 hash、isEqual 方法有许多联系，这篇小集讲一下其中的一些细节。
 
 NSArray 允许添加重复元素，添加元素时不查重，所以不调用上述两个方法。在移除元素时，会对当前数组内的元素进行遍历，每个元素的 isEqual 方法都会被调用（使用 remove 方法传入的元素作为参数），所有返回真值的元素都被移除。在字典中，不涉及 hash 方法。
 
 NSSet 不允许添加重复元素，所以添加新元素时，该元素的 hash 方法会被调用。若集合中不存在与此元素 hash 值相同的元素，则它直接被加入集合，不调用 isEqual 方法；若存在，则调用集合内的对应元素的 isEqual 方法，返回真值则判等，不加入，处理结束。若返回 false，则判定集合内不存在该元素，将其加入。
 
 从集合中移除元素时，首先调用它的 hash 方法。若集合中存在与其 hash 值相等的元素，则调用该元素的 isEqual 方法，若真值则判等，进行移除；若不存在，则会依次调用集合中每个元素的 isEqual 方法，只要找到一个返回真值的元素，就进行移除，并结束整个过程。（所以这样会有其他满足 isEqual 方法但却被漏掉未被移除的元素）。调用 contains 方法时，过程类似。
 
 因此，若某自定义对象会被加入到集合或作为字典的 key 时，需要同时重写 isEqual 方法和 hash 方法。这样，若集合中某元素存在，则调用它的 contains 和 remove 方法时，可以在 O(1) 完成查询。否则，查询它的时间复杂度提升为 O(n)。
 
 值得注意的是，NSDictionary 的键和值都是对象类型即可。但是被设为键的对象需要遵守 NSCopying 协议。
*/

@end
