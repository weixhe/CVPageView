//
//  CVTabTitleView.m
//  CVPageView
//
//  Created by caven on 2019/5/24.
//  Copyright © 2019 com.caven. All rights reserved.
//

#import "CVTabTitleView.h"

static NSString *const KEY_NORMAL = @"Normal";
static NSString *const KEY_HIGHLIGHTED = @"Highlighted";
static NSString *const KEY_SELECTED = @"NoSelectedrmal";



@interface CVTabTitleView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableDictionary <NSString *, NSString *> *cacheTitles;
@property (nonatomic, strong) NSMutableDictionary <NSString *, UIFont *> *cacheTitleFonts;
@property (nonatomic, strong) NSMutableDictionary <NSString *, UIColor *> *cacheTitleColors;
@property (nonatomic, strong) NSMutableDictionary <NSString *, UIColor *> *cacheBGColors;

@end

@implementation CVTabTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.cacheTitles = [NSMutableDictionary dictionary];
        self.cacheTitleFonts = [NSMutableDictionary dictionary];
        self.cacheTitleColors = [NSMutableDictionary dictionary];
        self.cacheBGColors = [NSMutableDictionary dictionary];
        
        [self setup];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.titleLabel.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
}

- (void)setup {
    self.titleLabel = [UILabel new];
    [self addSubview:self.titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - Private
#pragma mark 私有方法
- (void)updateContent {
    if (self.highlighted) {
        self.titleLabel.text = [self getTitleForKey:KEY_HIGHLIGHTED];
        self.titleLabel.textColor = [self getTitleColorForKey:KEY_HIGHLIGHTED];
        self.titleLabel.font = [self getTitleFontForKey:KEY_HIGHLIGHTED];
        self.backgroundColor = [self getBGColorForKey:KEY_HIGHLIGHTED];
    } else if (self.isSelected) {
        self.titleLabel.text = [self getTitleForKey:KEY_SELECTED];
        self.titleLabel.textColor = [self getTitleColorForKey:KEY_SELECTED];
        self.titleLabel.font = [self getTitleFontForKey:KEY_SELECTED];
        self.backgroundColor = [self getBGColorForKey:KEY_SELECTED];
    } else {
        self.titleLabel.text = [self getTitleForKey:KEY_NORMAL];
        self.titleLabel.textColor = [self getTitleColorForKey:KEY_NORMAL];
        self.titleLabel.font = [self getTitleFontForKey:KEY_NORMAL];
        self.backgroundColor = [self getBGColorForKey:KEY_NORMAL];
    }
    
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
}

- (NSString *)getTitleForKey:(NSString *)key {
    if ([self.cacheTitles objectForKey:key]) {
        return [self.cacheTitles objectForKey:key];
    }
    return @"";
}

- (UIFont *)getTitleFontForKey:(NSString *)key {
    if ([self.cacheTitleFonts objectForKey:key]) {
        return [self.cacheTitleFonts objectForKey:key];
    }
    return [UIFont systemFontOfSize:17];
}

- (UIColor *)getTitleColorForKey:(NSString *)key {
    if ([self.cacheTitleColors objectForKey:key]) {
        return [self.cacheTitleColors objectForKey:key];
    }
    return [UIColor blackColor];
}

- (UIColor *)getBGColorForKey:(NSString *)key {
    if ([self.cacheBGColors objectForKey:key]) {
        return [self.cacheBGColors objectForKey:key];
    }
    return [UIColor clearColor];
}

#pragma mark - Public
#pragma mark 公有方法
/// 设置 title
- (void)setTitle:(NSString *)title state:(UIControlState)state {
    if ([title isKindOfClass:NSString.self] && title.length > 0) {
        switch (state) {
            case UIControlStateNormal:
                [self.cacheTitles setObject:title forKey:KEY_NORMAL];
                break;
            case UIControlStateHighlighted:
                [self.cacheTitles setObject:title forKey:KEY_HIGHLIGHTED];
                break;
            case UIControlStateSelected:
                [self.cacheTitles setObject:title forKey:KEY_SELECTED];
                break;
            default:
                break;
        }
        if ([self.cacheTitles objectForKey:KEY_NORMAL]) {
            [self.cacheTitles setObject:title forKey:KEY_NORMAL];
        }
        [self updateContent];
    }
}

/// 设置 title color
- (void)setTitleColor:(UIColor *)titleColor state:(UIControlState)state {
    if ([titleColor isKindOfClass:UIColor.self]) {
        switch (state) {
            case UIControlStateNormal:
                [self.cacheTitleColors setObject:titleColor forKey:KEY_NORMAL];
                break;
            case UIControlStateHighlighted:
                [self.cacheTitleColors setObject:titleColor forKey:KEY_HIGHLIGHTED];
                break;
            case UIControlStateSelected:
                [self.cacheTitleColors setObject:titleColor forKey:KEY_SELECTED];
                break;
            default:
                break;
        }
        if ([self.cacheTitleColors objectForKey:KEY_NORMAL]) {
            [self.cacheTitleColors setObject:titleColor forKey:KEY_NORMAL];
        }
        [self updateContent];
    }
}

/// 设置 title font
- (void)setTitleFont:(UIFont *)titleFont state:(UIControlState)state {
    if ([titleFont isKindOfClass:UIColor.self]) {
        switch (state) {
            case UIControlStateNormal:
                [self.cacheTitleFonts setObject:titleFont forKey:KEY_NORMAL];
                break;
            case UIControlStateHighlighted:
                [self.cacheTitleFonts setObject:titleFont forKey:KEY_HIGHLIGHTED];
                break;
            case UIControlStateSelected:
                [self.cacheTitleFonts setObject:titleFont forKey:KEY_SELECTED];
                break;
            default:
                break;
        }
        if ([self.cacheTitleFonts objectForKey:KEY_NORMAL]) {
            [self.cacheTitleFonts setObject:titleFont forKey:KEY_NORMAL];
        }
        [self updateContent];
    }
}

/// 设置 background color
- (void)setBackgroundColor:(UIColor *)backgroundColor state:(UIControlState)state {
    if ([backgroundColor isKindOfClass:UIColor.self]) {
        switch (state) {
            case UIControlStateNormal:
                [self.cacheBGColors setObject:backgroundColor forKey:KEY_NORMAL];
                break;
            case UIControlStateHighlighted:
                [self.cacheBGColors setObject:backgroundColor forKey:KEY_HIGHLIGHTED];
                break;
            case UIControlStateSelected:
                [self.cacheBGColors setObject:backgroundColor forKey:KEY_SELECTED];
                break;
            default:
                break;
        }
        if ([self.cacheBGColors objectForKey:KEY_NORMAL]) {
            [self.cacheBGColors setObject:backgroundColor forKey:KEY_NORMAL];
        }
        [self updateContent];
    }
}

#pragma mark - Getter
#pragma mark 读取值
- (CGFloat)titleFitWidth {
    return self.titleLabel.bounds.size.width;
}

#pragma mark - Clean
#pragma mark 清空
- (void)clean {
    [self.cacheTitles removeAllObjects];
    [self.cacheTitleFonts removeAllObjects];
    [self.cacheTitleColors removeAllObjects];
    [self.cacheBGColors removeAllObjects];
    
    self.titleLabel.text = @"";
}

- (void)dealloc
{
    [self clean];
}

@end
