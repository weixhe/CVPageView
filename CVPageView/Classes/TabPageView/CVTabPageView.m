//
//  CVTabPageView.m
//  CVPageView
//
//  Created by caven on 2019/5/30.
//  Copyright © 2019 com.caven. All rights reserved.
//

#import "CVTabPageView.h"
#import "CVScrollTabView.h"
#import "CVPageView.h"

@interface CVTabPageView () <CVScrollTabDelegate, CVPageViewDelegate>

@property (nonatomic, strong) CVScrollTabView *tabView;

@property (nonatomic, strong) CVPageView *pageView;

@end

@implementation CVTabPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.tabView = [[CVScrollTabView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
    self.tabView.tabDelegate = self;
    [self addSubview:self.tabView];
    
    self.pageView = [[CVPageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tabView.frame), self.frame.size.width, CGRectGetHeight(self.frame) - CGRectGetMaxY(self.tabView.frame))];
    self.pageView.delegate = self;
    [self addSubview:self.pageView];
}

#pragma mark - Public Method
#pragma mark 外部方法

/// 刷新加载数据
- (void)reloadData {
    [self.tabView reloadData];
    [self.pageView reloadData];
    self.pageView.frame = CGRectMake(0, CGRectGetMaxY(self.tabView.frame), self.frame.size.width, CGRectGetHeight(self.frame) - CGRectGetMaxY(self.tabView.frame));
}

#pragma mark - CVScrollTabDelegate
#pragma mark tab view 代理
- (void)scrollTab:(CVScrollTabView *)scrollTab didSelectedIndex:(NSInteger)index {
    [self.pageView showIndex:index animation:YES];
}

#pragma mark - CVPageViewDelegate
#pragma mark page view 代理
///// 即将展示index位置的view，每次直接调用'showIndex:animation:'方法，或者滚动切换页时都会调用
//- (void)pageView:(CVPageView *)pageView willChangeToIndex:(NSInteger)index {
//
//}

/// pageView 正在滑动
- (void)pageView:(CVPageView *)pageView didScroll:(UIScrollView *)scrollView {
    
}

/// pageView 即将开始拖拽
- (void)pageView:(CVPageView *)pageView willBeginDragging:(UIScrollView *)scrollView {
    
}

/// pageView 已经减速结束
- (void)pageView:(CVPageView *)pageView didEndDecelerating:(UIScrollView *)scrollView {
    [self.tabView setSelectedTabIndex:pageView.currentIndex];
}

/// pageView 已经滑动结束，只有非交互切换页面才会回调
- (void)pageView:(CVPageView *)pageView didEndScrollingAnimation:(UIScrollView *)scrollView {
    [self.tabView setSelectedTabIndex:pageView.currentIndex];
}

#pragma mark - Setter
- (void)setTabDataSource:(id<CVScrollTabDataSource>)tabDataSource {
    self.tabView.tabDataSource = tabDataSource;
}

//- (void)setTabDelegate:(id<CVScrollTabDelegate>)tabDelegate {
//    self.tabView.tabDelegate = tabDelegate;
//}

- (void)setPageDataSource:(id<CVPageViewDataSource>)pageDataSource {
    self.pageView.dataSource = pageDataSource;
}

- (void)setPageDelegate:(id<CVPageViewDelegate>)pageDelegate {
    self.pageView.delegate = pageDelegate;
}

@end
