//
//  CVScrollTabProtocol.h
//  CVPageView
//
//  Created by caven on 2019/5/23.
//  Copyright © 2019 com.caven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CVScrollTabDataSource <NSObject>

@required
/// 返回 tab 的个数
- (NSInteger)numberOfPageTabs;

/// 自动适应宽度，如果设置YES，将自动计算每一个tab的宽度；如果设置NO，则整个tabScroll的宽度为基准，平均计算tab的宽度
- (BOOL)AutoAdaptWidth;

@optional
/// 返回 对应 index 的 tab [Normal,Highlighted,Selected]title
- (NSArray <NSString *> *)titlesForTabAtIndex:(NSInteger)index;

/// 返回 对应 index 的 tab view， 如果实现了此方法，则[titleForTabAtIndex]将失效
- (UIView *)viewForTabAtIndex:(NSInteger)index;

/// 返回 tab 的高度
- (CGFloat)preferTabScrollHeight;

/// 返回 每一个tab的的间距（tab的左右两边距离文字的的距离）
- (CGFloat)preferTabMarginAtIndex:(NSInteger)index;

/// 预设：[Normal,Highlighted,Selected]标题的字体和颜色
- (NSArray <UIFont *> *)preferTitleFontsAtIndex:(NSInteger)index;
- (NSArray <UIColor *> *)preferTitleColorsAtIndex:(NSInteger)index;

/// 预设：[Normal,Highlighted,Selected]背景颜色
- (NSArray <UIColor *> *)preferBGColorsAtIndex:(NSInteger)index;



//- (void)didPressTabForIndex:(NSInteger)index;

@end

@protocol CVScrollTabDelegate <NSObject>



@end

NS_ASSUME_NONNULL_END
