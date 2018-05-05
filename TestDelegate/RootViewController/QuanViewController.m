//
//  QuanViewController.m
//  TestDelegate
//
//  Created by a on 2018/3/7.
//  Copyright © 2018年 a. All rights reserved.
//

#import "QuanViewController.h"
#import "EOCRectangle.h" //矩形
#import "EOCSquare.h" //正方形

@interface QuanViewController ()

@end

@implementation QuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"提供全能初始化方法");
    
//    //矩形
//    EOCRectangle *rectangle1 = [[EOCRectangle  alloc] init];
//    NSLog(@"rectangle1。width:%.2f, height:%.2f", rectangle1.width, rectangle1.height);
//
//
//    EOCRectangle *rectangle2 = [[EOCRectangle alloc] initWithWidth:3 height:3];
//    NSLog(@"rectangle2。width:%.2f, height:%.2f", rectangle2.width, rectangle2.height);

    
    //正方形
    EOCSquare *eocSquare1 = [[EOCSquare alloc] init];
    NSLog(@"eocSquare1。width:%.2f, height:%.2f", eocSquare1.width, eocSquare1.height);
    
//    EOCSquare *eocSquare2 = [[EOCSquare alloc] initWithDimension:6];//EOCSquare全能初始化
//    NSLog(@"eocSquare2。width:%.2f, height:%.2f", eocSquare2.width, eocSquare2.height);
//
//    //重写父类EOCRectangle全能初始化方法
//    EOCSquare *eocSquare3 = [[EOCSquare alloc] initWithWidth:10 height:10];
//    NSLog(@"eocSquare3。width:%.2f, height:%.2f", eocSquare3.width, eocSquare3.height);

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
