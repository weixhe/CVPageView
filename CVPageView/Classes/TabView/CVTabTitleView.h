//
//  CVTabTitleView.h
//  CVPageView
//
//  Created by caven on 2019/5/24.
//  Copyright © 2019 com.caven. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CVTabTitleView : UIControl

/** 返回 title 的长度 */
@property (nonatomic, assign, readonly) CGFloat titleFitWidth;

/// 设置 title
- (void)setTitle:(NSString *)title state:(UIControlState)state;
/// 设置 title color
- (void)setTitleColor:(UIColor *)titleColor state:(UIControlState)state;
/// 设置 title font
- (void)setTitleFont:(UIFont *)titleFont state:(UIControlState)state;
/// 设置 background color
- (void)setBackgroundColor:(UIColor *)backgroundColor state:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END
