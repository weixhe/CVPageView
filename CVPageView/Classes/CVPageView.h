//
//  CVPageView.h
//  Test
//
//  Created by caven on 2019/5/5.
//  Copyright © 2019 com.caven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVPageViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CVPageView : UIView

/** 设置headerView， 在pageView上会是所有page的公有header，默认为nil */
@property (nonatomic, strong) UIView *headerView;

/** 设置纵向滑动的停止位置，如果不设置，会默认取headerView的高度 */
@property (nonatomic, assign) CGFloat hoverY;

@property (nonatomic, weak) id <CVPageViewDelegate> delegate;

@property (nonatomic, weak) id <CVPageViewDataSource> dataSource;

/** 当前显示page的index */
@property (nonatomic, assign, readonly) NSInteger currentIndex;

/// 刷新数据
- (void)reloadData;

/// 非交互式显示某个index位置的视图
- (void)showIndex:(NSInteger)index animation:(BOOL)animation;

/// 根据index获取当前位置的控制器
- (UIViewController *)controllerAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
