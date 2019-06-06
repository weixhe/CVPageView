//
//  TabPageViewController.m
//  CVPageView
//
//  Created by caven on 2019/5/30.
//  Copyright © 2019 com.caven. All rights reserved.
//

#import "TabPageViewController.h"
#import "CVTabPageView.h"
#import "TabPageListViewController.h"

@interface TabPageViewController () <CVScrollTabDataSource, CVPageViewDataSource>

@property (nonatomic, strong) NSArray *tabsArray;

@end

@implementation TabPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tabsArray = @[@"推荐", @"关注", @"分享", @"热门电视剧", @"世界杯", @"音乐", @"小说"];

    CVTabPageView *tabPage = [[CVTabPageView alloc] initWithFrame:CGRectMake(0, 88, self.view.frame.size.width, self.view.frame.size.height - 88)];
    tabPage.tabDataSource = self;
    tabPage.pageDataSource = self;
    [self.view addSubview:tabPage];
    
    [tabPage reloadData];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

#pragma mark - CVScrollTabDataSource
#pragma mark tabView 数据源
/// 返回 tab 的个数
- (NSInteger)numberOfPageTabs {
    return (NSInteger)self.tabsArray.count;
}

/// 自动适应宽度，如果设置YES，将自动计算每一个tab的宽度；如果设置NO，则整个tabScroll的宽度为基准，平均计算tab的宽度
- (BOOL)autoAdaptWidth {
    return YES;
}

- (NSArray <NSString *> *)titlesForTabAtIndex:(NSInteger)index {
    return @[self.tabsArray[(NSUInteger)index]];
}

/// 返回 tab 的高度
- (CGFloat)preferTabScrollHeight {
    return 40;
}

/// 返回 每一个tab的的间距（tab的左右两边距离文字的的距离）, [dataSource autoAdaptWidth] 返回 YES 时有效
- (CGFloat)preferTabMarginAtIndex:(NSInteger)index {
    return 15;
}

/// 预设：[Normal,Highlighted,Selected]标题的字体和颜色
- (NSArray <UIFont *> *)preferTitleFontsAtIndex:(NSInteger)index {
    return @[[UIFont systemFontOfSize:16], [UIFont boldSystemFontOfSize:16]];
}

- (NSArray <UIColor *> *)preferTitleColorsAtIndex:(NSInteger)index {
    return @[[UIColor colorWithRed:201/255.0 green:34/255.0 blue:43/255.0 alpha:1]];
}

/// 使用 mask slider
- (BOOL)needMaskSlider {
    return YES;
}

/// 预设：mask slider 的两端相对于文字的距离，如果没有实现本方法，则slider的宽度与tab相同，如果实现了本方法，则与文字相同，且可以预设两端距离文字距离
- (CGFloat)preferMaskSliderMargin {
    return 2;
}

/// 预设：mask slider 底部距离
- (CGFloat)preferMaskSliderBottom {
    return 0;
}

/// 预设：mask slider 颜色
- (UIColor *)preferMaskSliderColorAtIndex:(NSInteger)index {
    return [UIColor redColor];
}


#pragma mark - CVPageViewDataSource
#pragma mark pageview 数据源
/// 返回 pageView中需要显示的控制器个数
- (NSInteger)numberOfControllers {
    return (NSInteger)self.tabsArray.count;
}

/// 返回 控制器视图，根据index取不同的控制器
- (UIViewController *)pageView:(CVPageView *)pageView controllerAtIndex:(NSInteger)index {
    TabPageListViewController *vc = [[TabPageListViewController alloc] init];
    vc.identify = [self.tabsArray objectAtIndex:(NSUInteger)index];
    return vc;
}


@end
