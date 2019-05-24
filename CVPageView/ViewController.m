//
//  ViewController.m
//  CVPageView
//
//  Created by caven on 2019/5/22.
//  Copyright © 2019 com.caven. All rights reserved.
//

#import "ViewController.h"
#import "PageViewDemoController.h"
#import "CVScrollTabView.h"

@interface ViewController () <CVScrollTabDelegate, CVScrollTabDataSource>

@property (nonatomic, strong) NSArray *tabTexts;

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
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 180, 200, 40);
    btn1.backgroundColor = [UIColor redColor];
    [btn1 setTitle:@"TabPageViewDemo" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(TabPageViewDemo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    self.tabTexts = @[@"A", @"BBBB", @"CC", @"AAA", @"DDDDD", @"EFAD", @"HHHHHH", @"DDGGGGASDF"];
    CVScrollTabView * tabView = [[CVScrollTabView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 30)];
    tabView.backgroundColor = [UIColor lightGrayColor];
    tabView.tabDataSource = self;
    tabView.tabDelegate = self;
    [self.view addSubview:tabView];
    [tabView reloadData];
    
}

- (void)onClickBtnAction {
    PageViewDemoController *VC = [[PageViewDemoController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)TabPageViewDemo {
    
}


#pragma mark -
/// 返回 tab 的个数
- (NSInteger)numberOfPageTabs {
    return 3;
}

/// 自动适应宽度，如果设置YES，将自动计算每一个tab的宽度；如果设置NO，则整个tabScroll的宽度为基准，平均计算tab的宽度
- (BOOL)AutoAdaptWidth {
    return NO;
}

/// 返回 对应 index 的 tab [Normal,Highlighted,Selected]title
- (NSArray <NSString *> *)titlesForTabAtIndex:(NSInteger)index {
    return @[self.tabTexts[index]];
}

///// 返回 对应 index 的 tab view， 如果实现了此方法，则[titleForTabAtIndex]将失效
//- (UIView *)viewForTabAtIndex:(NSInteger)index {
//
//}

/// 返回 tab 的高度
- (CGFloat)preferTabScrollHeight {
    return 50;
}

/// 返回 每一个tab的的间距（tab的左右两边距离文字的的距离）
- (CGFloat)preferTabMarginAtIndex:(NSInteger)index {
    return 10;
}

/// 预设：[Normal,Highlighted,Selected]标题的字体和颜色
- (NSArray <UIFont *> *)preferTitleFontsAtIndex:(NSInteger)index {
    return @[[UIFont systemFontOfSize:15], [UIFont systemFontOfSize:17]];
}
- (NSArray <UIColor *> *)preferTitleColorsAtIndex:(NSInteger)index {
    return @[[UIColor blackColor], [UIColor redColor]];
}

///// 预设：[Normal,Highlighted,Selected]背景颜色
//- (NSArray <UIColor *> *)preferBGColorsAtIndex:(NSInteger)index {
//    return @[[UIColor whiteColor]];
//}
@end
