//
//  ViewController.m
//  CVPageView
//
//  Created by caven on 2019/5/22.
//  Copyright © 2019 com.caven. All rights reserved.
//

#import "ViewController.h"
#import "PageViewDemoController.h"
#import "TabPageViewController.h"
#import "CVScrollTabView.h"

@interface ViewController () <CVScrollTabDelegate, CVScrollTabDataSource>

@property (nonatomic, strong) NSArray *tabTexts;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *centerLine = [UIView new];
    centerLine.backgroundColor = [UIColor redColor];
    [self.view addSubview:centerLine];
    centerLine.frame = CGRectMake(0, 0, 1, self.view.frame.size.height);
    centerLine.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    
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
    
    self.tabTexts = @[@"AHGFH", @"BBJKLKYBB", @"CKJDSDGC", @"OKHGNAAA", @"DDDDD,J", @"EFADRFBD", @"HHHHHH", @"DDGGGGASDF"];
    CVScrollTabView * tabView = [[CVScrollTabView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 30)];
    tabView.backgroundColor = [UIColor lightGrayColor];
    tabView.tabDataSource = self;
    tabView.tabDelegate = self;
    [self.view addSubview:tabView];
    [tabView reloadData];
    
    UIControl *ccc = [tabView tabAtIndex:2];
    NSLog(@"%@", ccc);
    NSLog(@"%d", [tabView indexForTab:ccc]);
}

- (void)onClickBtnAction {
    PageViewDemoController *VC = [[PageViewDemoController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)TabPageViewDemo {
    TabPageViewController *vc = [[TabPageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -
/// 返回 tab 的个数
- (NSInteger)numberOfPageTabs {
    return (NSInteger)self.tabTexts.count;
}

/// 自动适应宽度，如果设置YES，将自动计算每一个tab的宽度；如果设置NO，则整个tabScroll的宽度为基准，平均计算tab的宽度
- (BOOL)autoAdaptWidth {
    return YES;
}

/// 返回 对应 index 的 tab [Normal,Highlighted,Selected]title
- (NSArray <NSString *> *)titlesForTabAtIndex:(NSInteger)index {
    return @[self.tabTexts[index]];
}

///// 返回 对应 index 的 tab view， 如果实现了此方法，则[titleForTabAtIndex]将失效
//- (UIControl *)viewForTabAtIndex:(NSInteger)index {
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

/// 预设：[Normal,Highlighted,Selected]背景颜色
- (NSArray <UIColor *> *)preferBGColorsAtIndex:(NSInteger)index {
    NSArray *colors = @[[UIColor colorWithRed:252/255.0 green:235/255.0 blue:235/255.0 alpha:1],
                    [UIColor colorWithRed:247/255.0 green:233/255.0 blue:241/255.0 alpha:1],
                    [UIColor colorWithRed:236/255.0 green:232/255.0 blue:242/255.0 alpha:1],
                    [UIColor colorWithRed:249/255.0 green:237/255.0 blue:232/255.0 alpha:1],
                    [UIColor colorWithRed:249/255.0 green:238/255.0 blue:220/255.0 alpha:1],
                    [UIColor colorWithRed:239/255.0 green:243/255.0 blue:222/255.0 alpha:1],
                    [UIColor colorWithRed:228/255.0 green:244/255.0 blue:246/255.0 alpha:1],
                    [UIColor colorWithRed:232/255.0 green:237/255.0 blue:237/255.0 alpha:1]];

    UIColor *oneColor = colors[arc4random() % colors.count];
    return @[oneColor];
}


/// 使用 mask slider
- (BOOL)needMaskSlider {
    return YES;
}


//- (CGFloat)preferMaskSliderMargin {
//    return 20;
//}
//
///// 预设：mask slider 圆角
//- (BOOL)preferMaskSliderCorner {
//    return YES;
//}
//
///// 预设：mask slider 高度
//- (CGFloat)preferMaskSliderHeight {
//    return 4;
//}
//
///// 预设：mask slider 底部距离
//- (CGFloat)preferMaskSliderBottom {
//    return 2;
//}
//
///// 预设：mask slider 颜色
//- (UIColor *)preferMaskSliderColorAtIndex:(NSInteger)index {
//    return [UIColor redColor];
//}


- (void)scrollTab:(CVScrollTabView *)scrollTab didSelectedIndex:(NSInteger)index {
    NSLog(@"%d", index);
}
@end
