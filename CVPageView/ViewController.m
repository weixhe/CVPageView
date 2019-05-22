//
//  ViewController.m
//  CVPageView
//
//  Created by caven on 2019/5/22.
//  Copyright © 2019 com.caven. All rights reserved.
//

#import "ViewController.h"
#import "PageViewDemoController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 100, 200, 40);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"PageViewDemo" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onClickBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)onClickBtnAction {
    PageViewDemoController *VC = [[PageViewDemoController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

@end
