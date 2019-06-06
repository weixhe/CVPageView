//
//  CVTabPageView.h
//  CVPageView
//
//  Created by caven on 2019/5/30.
//  Copyright © 2019 com.caven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVScrollTabProtocol.h"
#import "CVPageViewProtocol.h"


/**
 本类为带tab标签的PageView，使用的时候需要设置诸多的代理，并根据需求分别实现他们的一些方法
 
 注：使用 PageView 的时候最好在其控制器重写方法[shouldAutomaticallyForwardAppearanceMethods], 并返回NO，
 因为 PageView 的内部显式调用了 viewWillAppear， viewDidAppear 等四个方法，
 如果没有重写 shouldAutomaticallyForwardAppearanceMethods 方法，会在第一次显示子view的时候重复调用 viewWillAppear 方法
 */

NS_ASSUME_NONNULL_BEGIN

@interface CVTabPageView : UIView

@property (nonatomic, weak) id <CVScrollTabDataSource> tabDataSource;

//@property (nonatomic, weak) id <CVScrollTabDelegate> tabDelegate;

@property (nonatomic, weak) id <CVPageViewDataSource> pageDataSource;

@property (nonatomic, weak) id <CVPageViewDelegate> pageDelegate;


/// 刷新加载数据
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
