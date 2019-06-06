//
//  CVPageViewProtocol.h
//  Test
//
//  Created by caven on 2019/5/6.
//  Copyright © 2019 com.caven. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CVPageView;

@protocol CVPageViewDelegate <NSObject>

@optional
/// 即将展示index位置的view，每次直接调用'showIndex:animation:'方法，或者滚动切换页时都会调用
- (void)pageView:(CVPageView *)pageView willChangeToIndex:(NSInteger)index;

/// pageView 正在滑动
- (void)pageView:(CVPageView *)pageView didScroll:(UIScrollView *)scrollView;
/// pageView 即将开始拖拽
- (void)pageView:(CVPageView *)pageView willBeginDragging:(UIScrollView *)scrollView;
/// pageView 已经减速结束
- (void)pageView:(CVPageView *)pageView didEndDecelerating:(UIScrollView *)scrollView;
/// pageView 已经滑动结束，只有非交互切换页面才会回调
- (void)pageView:(CVPageView *)pageView didEndScrollingAnimation:(UIScrollView *)scrollView;

@end


@protocol CVPageViewDataSource <NSObject>

@required
/// 返回 pageView中需要显示的控制器个数
- (NSInteger)numberOfControllers;

/// 返回 控制器视图，根据index取不同的控制器
- (UIViewController *)pageView:(CVPageView *)pageView controllerAtIndex:(NSInteger)index;

/// 请返回NO，显示控制 viewWillAppear 和 viewWillDisappear
- (BOOL)shouldAutomaticallyForwardAppearanceMethods;

///// 返回 视图的Frame，
//- (CGRect)preferPageFrameAtIndex:(NSInteger)index;

@optional


@end
