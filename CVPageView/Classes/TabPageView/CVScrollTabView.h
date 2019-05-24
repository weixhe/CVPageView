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

@end

NS_ASSUME_NONNULL_END