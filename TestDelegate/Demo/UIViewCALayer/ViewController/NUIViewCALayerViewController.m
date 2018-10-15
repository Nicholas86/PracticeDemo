//
//  NUIViewCALayerViewController.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/10/14.
//  Copyright © 2018年 a. All rights reserved.
//

#import "NUIViewCALayerViewController.h"

@interface NUIViewCALayerViewController ()

@end

@implementation NUIViewCALayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"UIView和CALayer的联系和区别";
    
    self.view.backgroundColor = [UIColor  whiteColor];
    
    [self  uiview_calayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)uiview_calayer
{
    CGRect frame = CGRectMake(100, 150, 200, 200);
    UIView  *backView = [[UIView  alloc] initWithFrame:frame];
    backView.backgroundColor = [UIColor lightGrayColor];
    backView.layer.masksToBounds = YES;
    [self.view  addSubview:backView];
}

@end




