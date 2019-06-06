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

@property (strong, nonatomic) NSMutableDictionary <NSNumber *, UIControl *> *cacheSubViews;

@property (nonatomic, assign) NSInteger tabCount;

@property (nonatomic, assign) BOOL autoAdaptWidth;

@property (nonatomic, assign) CGFloat tabHeight;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) BOOL needMaskSlider;
@property (strong, nonatomic) NSMutableDictionary <NSNumber *, UIColor *> *cacheMaskSliderColors;

@property (nonatomic, strong) UIView *sliderView;

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
    self.cacheSubViews = [NSMutableDictionary dictionary];
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
    [self setupSliderView];
    [self setSelectedTabIndex:0];
}

/// 选中某个tab(非交互)
- (void)setSelectedTabIndex:(NSInteger)index {
    if (index < 0 && index > self.cacheSubViews.count) {
        return;
    }
    
    [self viewAtIndex:self.currentIndex].selected = NO;
    self.currentIndex = index;
    [self viewAtIndex:self.currentIndex].selected = YES;
    
    [self scrollToSelectedView];
}

/// 根据index，获取某一个tab
- (UIControl *)tabAtIndex:(NSInteger)index {
    UIControl *view = [self.cacheSubViews objectForKey:@(index)];
    return view;
}

/// 根据tab，获取其所在的index
- (NSInteger)indexForTab:(UIControl *)tab {
    
    __block NSInteger result = -1;
    [self.cacheSubViews enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIControl * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([tab isEqual:obj]) {
            result = key.integerValue;
            *stop = YES;
        }
    }];
    return result;
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

- (void)setupSliderView {
    if (self.tabDataSource && [self.tabDataSource respondsToSelector:@selector(needMaskSlider)]) {
        self.needMaskSlider = [self.tabDataSource needMaskSlider];
        if (self.needMaskSlider) {
            
            CGFloat sliderH = 2.0f;
            if (self.tabDataSource && [self.tabDataSource respondsToSelector:@selector(preferMaskSliderHeight)]) {
                sliderH = [self.tabDataSource preferMaskSliderHeight];
            }
            CGFloat sliderB = 0.0f;
            if (self.tabDataSource && [self.tabDataSource respondsToSelector:@selector(preferMaskSliderBottom)]) {
                sliderB = [self.tabDataSource preferMaskSliderBottom];
            }
            BOOL sliderCorner = NO;
            if (self.tabDataSource && [self.tabDataSource respondsToSelector:@selector(preferMaskSliderCorner)]) {
                sliderCorner = [self.tabDataSource preferMaskSliderCorner];
            }
            
            self.sliderView.frame = CGRectMake(0, self.bounds.size.height - sliderB - sliderH, 0, sliderH);
            if (sliderCorner) {
                self.sliderView.layer.cornerRadius = sliderH / 2;
                self.sliderView.layer.masksToBounds = YES;
            }
        }
    }
}

- (UIControl *)viewAtIndex:(NSInteger)index {
    UIControl *view = [self.cacheSubViews objectForKey:@(index)];
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
            [self.cacheSubViews setObject:view forKey:@(index)];
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

/// （非交互）点击了tab（或直接设置）后需要滑动一下tab，如果可能的话，尽量将tab滑动到中间位置
- (void)scrollToSelectedView {
    UIControl *tab = [self viewAtIndex:self.currentIndex];
    if (self.contentSize.width > self.frame.size.width) {
        // 计算：如果将tab移动到的屏幕中心位置, tab距离左侧的距离
        CGFloat exceptInScreen = self.bounds.size.width - tab.frame.size.width;
        CGFloat padding = exceptInScreen * 0.5;
        
        // 计算：tab 需要移动的距离
        CGFloat offsetX = tab.frame.origin.x - padding;
        
        // 判断：tab的偏移量超出了scroll的contentSize，需要放置scroll偏移后首尾出现空白情况
        if (offsetX < 0) {
            offsetX = 0;
        }
        
        UIControl *last = [self.cacheSubViews objectForKey:@(self.cacheSubViews.count - 1)];
        if (offsetX > last.frame.origin.x - (self.bounds.size.width - last.frame.size.width)) {
            offsetX = last.frame.origin.x - (self.bounds.size.width - last.frame.size.width);
        }
        
        //    if (offsetX > self.contentSize.width - self.frame.size.width) {
        //        offsetX = self.contentSize.width - self.frame.size.width;
        //    }
        
        CGPoint nextPoint = CGPointMake(offsetX, 0);
        [self setContentOffset:nextPoint animated:YES];
    }
    
    
    if (self.needMaskSlider) {
        
        CGFloat sliderW = 0.0f;
        if ([tab isKindOfClass:CVTabTitleView.self] && self.tabDataSource && [self.tabDataSource respondsToSelector:@selector(preferMaskSliderMargin)]) {
            // 如果实现了本方法，则与文字相同，且可以预设两端距离文字距离
            sliderW = ((CVTabTitleView *)tab).titleFitWidth + [self.tabDataSource preferMaskSliderMargin];
        } else {
            // 如果没有实现本方法，则slider的宽度与tab相同
            sliderW = tab.frame.size.width;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.sliderView.frame;
            frame.size.width = sliderW;
            self.sliderView.frame = frame;
            self.sliderView.center = CGPointMake(tab.center.x, self.sliderView.center.y);
        }];
        
        if (self.tabDataSource && [self.tabDataSource respondsToSelector:@selector(preferMaskSliderColorAtIndex:)]) {
            self.sliderView.backgroundColor = [self.tabDataSource preferMaskSliderColorAtIndex:self.currentIndex];
        } else {
            self.sliderView.backgroundColor = [UIColor redColor];
        }
    }
}

#pragma mark - Actions
#pragma mark 事件响应

/// 响应 titleView 的点击事件（交互）
- (void)onClickTitleViewAction:(UIControl *)sender {
    [self viewAtIndex:self.currentIndex].selected = NO;
    sender.selected = YES;
    self.currentIndex = sender.tag - TAG_TITLE_VIEW;
    
    if (self.tabDelegate && [self.tabDelegate respondsToSelector:@selector(scrollTab:didSelectedIndex:)]) {
        [self.tabDelegate scrollTab:self didSelectedIndex:sender.tag - TAG_TITLE_VIEW];
    }
    
    [self scrollToSelectedView];
}

#pragma mark - Lazy Load
- (UIView *)sliderView {
    if (!_sliderView) {
        _sliderView = [UIView new];
        [self addSubview:_sliderView];
    }
    return _sliderView;
}

#pragma mark - Clean
#pragma mark 清空
- (void)clean {
    [_sliderView removeFromSuperview];  _sliderView = nil;
    [[self.cacheSubViews allValues] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.currentIndex = 0;
    [self.cacheSubViews removeAllObjects];
    [self.cacheMaskSliderColors removeAllObjects];
}

- (void)dealloc
{
    [self clean];
}
@end
