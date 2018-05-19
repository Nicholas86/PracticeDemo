//
//  NMatlabViewController.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/6.
//  Copyright © 2018年 a. All rights reserved.
//

#import "NMatlabViewController.h"

@interface NMatlabViewController ()

@end

@implementation NMatlabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"算法";
    
    //找出数组重复数字
    [self  checkDuplicateNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//找出数组重复数字
- (void)checkDuplicateNumber
{
    NSMutableArray *numbers = [NSMutableArray  arrayWithObjects:@2, @3, @1, @5, @0, @2, @7, @9, @1, nil];
    [self  duplicateWithNumberArray:numbers];
}


#pragma mark private methods
/*
 以数组为例, 找出重复数字。[2, 3, 1, 5, 0, 2, 7, 9, 1]
 */
- (BOOL)duplicateWithNumberArray:(NSMutableArray *)numbers
{
    if (numbers.count <= 0 ) {
        NSLog(@"数组为空");
        return NO;
    }
    
    //数字范围: 0 ~ 9, 没有负数
    int length = [[NSString  stringWithFormat:@"%ld", numbers.count] intValue];
    for (int i = 0; i < length; ++i) {
        if (numbers[i] < 0) {
            return NO;
        }
    }
    
    
    for (int i = 0; i < length; ++i) {
        
        while ([numbers[i] intValue] != i) {
            if (numbers[i] == numbers[[numbers[i]  intValue]]) {
                NSLog(@"重复数字: %@", numbers[i]);
                return YES;
            }
            //取临时变量
            int temNumber = [numbers[i]  intValue];
            //以临时变量为下标, 去除对应下边的值, 并与临时变量交换
            numbers[i] = numbers[temNumber];
            numbers[temNumber] = @(temNumber);
        }
                
    }
    
    return NO;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
