//
//  NCTFrameViewController.m
//  TestDelegate
//
//  Created by mac on 2019/3/5.
//  Copyright © 2019 a. All rights reserved.
//

#import "NCTFrameViewController.h"
#import "UILabel+StringAction.h"

@interface NCTFrameViewController ()

@end

@implementation NCTFrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self ctframe];
    
}

- (void)ctframe
{
    CGRect frame = CGRectMake(30, 100, 300, 60);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:label];
    
    label.text = @"116.com, 哈哈126.com, 呲呲136.com";
    
    NSArray *strings = @[@"116.com", @"126.com", @"136.com"];
    [label n_addAttributeTapActionWithStrings:strings tapClicked:^(UILabel * _Nonnull label, NSString * _Nonnull string, NSRange range, NSInteger index) {
        NSLog(@"string: %@, range:%lu", string, (unsigned long)range.length);
    }];
    
    
}

@end
