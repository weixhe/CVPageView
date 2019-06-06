//
//  CVScrollTabView.h
//  CVPageView
//
//  Created by caven on 2019/5/23.
//  Copyright © 2019 com.caven. All rights reserved.
//

#import "CVPageView.h"
#import "CVScrollTabProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CVScrollTabView : UIScrollView

@property (nonatomic, weak) id <CVScrollTabDataSource> tabDataSource;
@property (nonatomic, weak) id <CVScrollTabDelegate> tabDelegate;

/// 刷新 tab scroll 界面
- (void)reloadData;

/// (非交互)选中某个tab，可以在初始化或者其他时候直接设置
- (void)setSelectedTabIndex:(NSInteger)index;

/// 根据index，获取某一个tab
- (UIControl *)tabAtIndex:(NSInteger)index;

/// 根据tab，获取其所在的index
- (NSInteger)indexForTab:(UIControl *)tab;

@end

NS_ASSUME_NONNULL_END
