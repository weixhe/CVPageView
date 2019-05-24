//
//  CVTabPageView.m
//  CVPageView
//
//  Created by caven on 2019/5/23.
//  Copyright © 2019 com.caven. All rights reserved.
//

#import "CVScrollTabView.h"
#import "CVTabTitleView.h"

@interface CVScrollTabView ()

@property (strong, nonatomic) NSMutableDictionary <NSNumber *, UIView *> *subViewsCache;

@property (nonatomic, assign) NSInteger tabCount;

@property (nonatomic, assign) BOOL autoAdaptWidth;

@property (nonatomic, assign) CGFloat tabHeight;

@end

@implementation CVScrollTabView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self __init__];
    }
    return self;
}

- (void)__init__ {
    self.tabHeight = 44;
    self.subViewsCache = [NSMutableDictionary dictionary];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
}

- (void)reloadData {
//    [super reloadData];
    self.tabCount = [self.tabDataSource numberOfPageTabs];
    self.autoAdaptWidth = [self.tabDataSource AutoAdaptWidth];

    // 更新 Frame
    if ([self.tabDataSource respondsToSelector:@selector(preferTabScrollHeight)]) {
        self.tabHeight = [self.tabDataSource preferTabScrollHeight];
    }
    CGRect frame = self.frame;
    frame.size.height = self.tabHeight;
    self.frame = frame;
    
    [self setupBarView];
}

- (void)setupBarView {
    
    CGFloat offsetX = 0.0f;
    
    for (NSUInteger index = 0; index < self.tabCount; index++) {
        UIView *view = [self viewAtIndex:index];
        view.frame = CGRectMake(offsetX, 0, view.frame.size.width, view.frame.size.height);
        [self addSubview:view];
        offsetX = CGRectGetMaxX(view.frame);
    }
}



- (UIView *)viewAtIndex:(NSInteger)index {
    UIView *view = [self.subViewsCache objectForKey:@(index)];
    if (!view) {
        if ([self.tabDataSource respondsToSelector:@selector(titlesForTabAtIndex:)]) {
            CVTabTitleView *titleView = [[CVTabTitleView alloc] initWithFrame:CGRectZero];
            [self setTitleView:titleView index:index];
            CGFloat width = 0.0f;
            if (!self.autoAdaptWidth) {
                width = self.frame.size.width / self.tabCount;
            }
            if (self.autoAdaptWidth) {
                CGFloat margin = 0.0f;
                if ([self.tabDataSource respondsToSelector:@selector(preferTabMarginAtIndex:)]) {
                    margin = [self.tabDataSource preferTabMarginAtIndex:index];
                }
                width = margin * 2 + titleView.titleFitWidth;
            }
            titleView.frame = CGRectMake(0, 0, width, self.tabHeight);
            view = titleView;
        } else if ([self.tabDataSource respondsToSelector:@selector(viewForTabAtIndex:)]) {
            view = [self.tabDataSource viewForTabAtIndex:index];
        }
        
        if (view) {
            [self.subViewsCache setObject:view forKey:@(index)];
        }
        
    }
    return view;
}

/// 设置内部tab的标题以及样式
- (void)setTitleView:(CVTabTitleView *)titleView index:(NSInteger)index  {
    if ([self.tabDataSource respondsToSelector:@selector(titlesForTabAtIndex:)]) {
        NSArray *titleArr = [self.tabDataSource titlesForTabAtIndex:index];
        if (titleArr.count == 1) {
            [titleView setTitle:[titleArr objectAtIndex:0] state:UIControlStateNormal];
        } else if (titleArr.count == 2) {
            [titleView setTitle:[titleArr objectAtIndex:0] state:UIControlStateNormal];
            [titleView setTitle:[titleArr objectAtIndex:1] state:UIControlStateSelected];
        } else if (titleArr.count >= 3) {
            [titleView setTitle:[titleArr objectAtIndex:0] state:UIControlStateNormal];
            [titleView setTitle:[titleArr objectAtIndex:1] state:UIControlStateHighlighted];
            [titleView setTitle:[titleArr objectAtIndex:2] state:UIControlStateSelected];
        }
    }
    
    if ([self.tabDataSource respondsToSelector:@selector(preferTitleFontsAtIndex:)]) {
        NSArray *dataArr = [self.tabDataSource preferTitleFontsAtIndex:index];
        if (dataArr.count == 1) {
            [titleView setTitleFont:[dataArr objectAtIndex:0] state:UIControlStateNormal];
        } else if (dataArr.count == 2) {
            [titleView setTitleFont:[dataArr objectAtIndex:0] state:UIControlStateNormal];
            [titleView setTitleFont:[dataArr objectAtIndex:1] state:UIControlStateSelected];
        } else if (dataArr.count >= 3) {
            [titleView setTitleFont:[dataArr objectAtIndex:0] state:UIControlStateNormal];
            [titleView setTitleFont:[dataArr objectAtIndex:1] state:UIControlStateHighlighted];
            [titleView setTitleFont:[dataArr objectAtIndex:2] state:UIControlStateSelected];
        }
    }
    
    if ([self.tabDataSource respondsToSelector:@selector(preferTitleColorsAtIndex:)]) {
        NSArray *dataArr = [self.tabDataSource preferTitleColorsAtIndex:index];
        if (dataArr.count == 1) {
            [titleView setTitleColor:[dataArr objectAtIndex:0] state:UIControlStateNormal];
        } else if (dataArr.count == 2) {
            [titleView setTitleColor:[dataArr objectAtIndex:0] state:UIControlStateNormal];
            [titleView setTitleColor:[dataArr objectAtIndex:1] state:UIControlStateSelected];
        } else if (dataArr.count >= 3) {
            [titleView setTitleColor:[dataArr objectAtIndex:0] state:UIControlStateNormal];
            [titleView setTitleColor:[dataArr objectAtIndex:1] state:UIControlStateHighlighted];
            [titleView setTitleColor:[dataArr objectAtIndex:2] state:UIControlStateSelected];
        }
    }
    
    if ([self.tabDataSource respondsToSelector:@selector(preferBGColorsAtIndex:)]) {
        NSArray *dataArr = [self.tabDataSource preferBGColorsAtIndex:index];
        if (dataArr.count == 1) {
            [titleView setBackgroundColor:[dataArr objectAtIndex:0] state:UIControlStateNormal];
        } else if (dataArr.count == 2) {
            [titleView setBackgroundColor:[dataArr objectAtIndex:0] state:UIControlStateNormal];
            [titleView setBackgroundColor:[dataArr objectAtIndex:1] state:UIControlStateSelected];
        } else if (dataArr.count >= 3) {
            [titleView setBackgroundColor:[dataArr objectAtIndex:0] state:UIControlStateNormal];
            [titleView setBackgroundColor:[dataArr objectAtIndex:1] state:UIControlStateHighlighted];
            [titleView setBackgroundColor:[dataArr objectAtIndex:2] state:UIControlStateSelected];
        }
    }

}

//#pragma mark - CVPageViewDataSource
//#pragma mark PageView 数据源
//
///// 返回 pageView中需要显示的控制器个数
//- (NSInteger)numberOfControllers {
//    return 0;
//}
//
///// 返回 控制器视图，根据index取不同的控制器
//- (UIViewController *)pageView:(CVPageView *)pageView controllerAtIndex:(NSInteger)index {
//    return nil;
//}
//
/////// 返回 视图的Frame，
////- (CGRect)preferPageFrameAtIndex:(NSInteger)index;
//
//#pragma mark - CVPageViewDataSource
//#pragma mark PageView 代理
///// 是否需要预加载
//- (BOOL)isPreLoad {
//    return NO;
//}
//
///// 根据index 返回 某页视图能否滑动
//- (BOOL)pageViewCanScollAtIndex:(NSInteger)index {
//    return YES;
//}
@end
