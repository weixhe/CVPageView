//
//  TestViewController.m
//  Test
//
//  Created by caven on 2019/5/5.
//  Copyright © 2019 com.caven. All rights reserved.
//

#import "PageViewDemoController.h"
#import "CVPageView.h"
#import "TestViewController.h"

@interface PageViewDemoController () <CVPageViewDelegate, CVPageViewDataSource>

@property (nonatomic, strong) CVPageView *pageView;
@property (nonatomic, strong) NSArray *titlesArray;

@end

@implementation PageViewDemoController

/**
 *   @brief 这个Demo中只要测试pageView，顶部的bar是直接填写的btn，没有什么直接功能
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titlesArray = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
    
//    CGFloat width = self.view.frame.size.width / self.titlesArray.count;
//    for (NSUInteger index = 0; index < self.titlesArray.count; index++) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(width * index, 100, width, 40);
//        btn.tag = 100 + index;
//        btn.backgroundColor = [UIColor orangeColor];
//        [btn setTitle:self.titlesArray[index] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:btn];
//
//        if (index == 0) {
//            [self onClickBtnAction:btn];
//        }
//
//    }
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 88, self.view.frame.size.width, 40)];
    textLabel.backgroundColor = [UIColor orangeColor];
    textLabel.text = @"这里仅仅测试了 PageView 功能，可以左右滑动翻页";
    [self.view addSubview:textLabel];
    
    self.pageView = [[CVPageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textLabel.frame), self.view.frame.size.width, self.view.frame.size.height - 128)];
    self.pageView.delegate = self;
    self.pageView.dataSource = self;
    [self.view addSubview:self.pageView];
    [self.pageView reloadData];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}


- (void)onClickBtnAction:(UIButton *)sender {
    [self changeBtnStatus:sender];
    
    [self.pageView showIndex:sender.tag - 100 animation:YES];
}

- (void)changeBtnStatus:(UIButton *)sender {
    for (NSUInteger index = 0; index < self.titlesArray.count; index++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:100 + index];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

#pragma mark - Delegate - CVPageView

/// 即将展示index位置的view，每次直接调用'showIndex:animation:'方法，或者滚动切换页时都会调用
- (void)pageView:(CVPageView *)pageView willChangeToIndex:(NSInteger)index {
    NSLog(@"即将显示： %@", [self.titlesArray objectAtIndex:(NSUInteger)index]);
    UIButton *sender = (UIButton *)[self.view viewWithTag:(int)index + 100];
    [self changeBtnStatus:sender];
}

#pragma mark - DataSource - CVPageView
/// 返回pageView中需要显示的控制器个数
- (NSInteger)numberOfControllers {
    return (NSInteger)self.titlesArray.count;
}

/// 根据index取每一个控制器
- (UIViewController *)pageView:(CVPageView *)pageView controllerAtIndex:(NSInteger)index {
    TestViewController *testVC = [[TestViewController alloc] init];
    testVC.text = [self.titlesArray objectAtIndex:(NSUInteger)index];
    return testVC;
}


/// 是否需要预加载
- (BOOL)isPreLoad {
    return NO;
}

/// 根据index 返回 某页视图能否滑动
- (BOOL)pageViewCanScollAtIndex:(NSInteger)index {
    return YES;
}


@end
