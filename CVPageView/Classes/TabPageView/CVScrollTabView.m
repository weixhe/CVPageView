//
//  CVTabPageView.m
//  CVPageView
//
//  Created by caven on 2019/5/23.
//  Copyright © 2019 com.caven. All rights reserved.
//

#import "CVScrollTabView.h"
#import "CVTabTitleView.h"

const int TAG_TITLE_VIEW = 100;

@interface CVScrollTabView ()

@property (strong, nonatomic) NSMutableDictionary <NSNumber *, UIControl *> *subViewsCache;

@property (nonatomic, assign) NSInteger tabCount;

@property (nonatomic, assign) BOOL autoAdaptWidth;

@property (nonatomic, assign) CGFloat tabHeight;

@property (nonatomic, strong) UIControl *currentSelectedControl;

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

#pragma mark - Public
#pragma mark 公开方法
- (void)reloadData {

    [self clean];
    self.tabCount = [self.tabDataSource numberOfPageTabs];
    self.autoAdaptWidth = [self.tabDataSource autoAdaptWidth];

    // 更新 Frame
    if ([self.tabDataSource respondsToSelector:@selector(preferTabScrollHeight)]) {
        self.tabHeight = [self.tabDataSource preferTabScrollHeight];
    }
    CGRect frame = self.frame;
    frame.size.height = self.tabHeight;
    self.frame = frame;
    
    [self setupBarView];
    [self setSelectedTabIndex:0];
}

/// 选中某个tab(非交互)
- (void)setSelectedTabIndex:(NSInteger)index {
    if (index < 0 && index > self.subViewsCache.count) {
        return;
    }
    
    
    UIControl *tabView = [self.subViewsCache objectForKey:@(index)];
    self.currentSelectedControl.selected = NO;
    tabView.selected = YES;
    self.currentSelectedControl = tabView;
}

#pragma mark - Private
#pragma mark 私有方法
- (void)setupBarView {
    
    CGFloat offsetX = 0.0f;
    for (NSUInteger index = 0; index < self.tabCount; index++) {
        UIView *view = [self viewAtIndex:index];
        view.tag = TAG_TITLE_VIEW + index;
        view.frame = CGRectMake(offsetX, 0, view.frame.size.width, view.frame.size.height);
        [self addSubview:view];
        offsetX = CGRectGetMaxX(view.frame);
    }
    
    self.contentSize = CGSizeMake(offsetX, self.frame.size.height);
}

- (UIControl *)viewAtIndex:(NSInteger)index {
    UIControl *view = [self.subViewsCache objectForKey:@(index)];
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
            [titleView addTarget:self action:@selector(onClickTitleViewAction:) forControlEvents:UIControlEventTouchUpInside];
            view = titleView;
        } else if ([self.tabDataSource respondsToSelector:@selector(viewForTabAtIndex:)]) {
            view = [self.tabDataSource viewForTabAtIndex:index];
            NSAssert([view isKindOfClass:UIControl.self], @"错误： [viewForTabAtIndex] 方法必须返回一个 UIControl 类或其子类");
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

/// 将tab滑动到中间位置
- (void)scrollToCenter {
    UIControl *tab = self.currentSelectedControl;
    // 计算：如果将tab移动到的屏幕中心位置, tab距离左侧的距离
    CGFloat exceptInScreen = self.bounds.size.width - tab.frame.size.width;
    CGFloat padding = exceptInScreen * 0.5;
    
    // 计算：tab 需要移动的距离
    CGFloat offsetX = tab.frame.origin.x - padding;
    
    // 判断：tab的偏移量超出了scroll的contentSize，需要放置scroll偏移后首尾出现空白情况
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    UIControl *last = [self.subViewsCache objectForKey:@(self.subViewsCache.count - 1)];
    if (offsetX > last.frame.origin.x - exceptInScreen) {
        offsetX = last.frame.origin.x - exceptInScreen;
    }
    
    CGPoint nextPoint = CGPointMake(offsetX, 0);
    [self setContentOffset:nextPoint animated:YES];
}

#pragma mark - Actions
#pragma mark 事件响应

/// 响应 titleView 的点击事件（交互）
- (void)onClickTitleViewAction:(UIControl *)sender {
    self.currentSelectedControl.selected = NO;
    sender.selected = YES;
    self.currentSelectedControl = sender;
    
    if (self.tabDelegate && [self.tabDelegate respondsToSelector:@selector(scrollTab:didSelectedIndex:)]) {
        [self.tabDelegate scrollTab:self didSelectedIndex:sender.tag - TAG_TITLE_VIEW];
    }
    
    [self scrollToCenter];
}

#pragma mark - Clean
#pragma mark 清空
- (void)clean {
    self.currentSelectedControl.selected = NO;
    self.currentSelectedControl = nil;
    [self.subViewsCache removeAllObjects];
}

- (void)dealloc
{
    [self clean];
}
@end
