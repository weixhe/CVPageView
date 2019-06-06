//
//  CVPageView.m
//  Test
//
//  Created by caven on 2019/5/5.
//  Copyright © 2019 com.caven. All rights reserved.
//

#import "CVPageView.h"
#import "__CVPageContentScrollView.h"


@interface CVPageView () <UIScrollViewDelegate>
/** 缓存所有的控制器 */
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, UIViewController *> *memCaches;
/** 缓存上一个OffSet */
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSNumber *> *lastContentOffset;
/** 缓存上一个ContentSize */
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSNumber *> *lastContentSize;

/** 父控制器 */
@property (nonatomic, strong) UIViewController *superController;

@property (nonatomic, strong) __CVPageContentScrollView *scrollView;
/** 当前选中的index */
@property (nonatomic, assign, readwrite) NSInteger currentIndex;
/** 上一个选中的index */
@property (nonatomic, assign) NSInteger lastIndex;
/** 预测的下一个index */
@property (nonatomic, assign) NSInteger guessToIndex;
/** 记录PageView开始滑动时的偏移量 */
@property (nonatomic, assign) CGFloat originOffset;

/** 总页数 */
@property (nonatomic, assign) NSInteger pageCount;

@end

@implementation CVPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self __init__];
        [self setup];
    }
    return self;
}

- (void)__init__ {
    self.memCaches = [NSMutableDictionary dictionary];
    self.lastContentSize = [NSMutableDictionary dictionary];
    self.lastContentOffset = [NSMutableDictionary dictionary];

}

- (void)setup {
    self.scrollView = [[__CVPageContentScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateScrollViewLayoutIfNeed];
}

#pragma mark - Public
/// 刷新数据
- (void)reloadData {
    
    if ([self.dataSource shouldAutomaticallyForwardAppearanceMethods]) {
        NSLog(@"警告：CVPageView 的 shouldAutomaticallyForwardAppearanceMethods 方法请返回 NO");
        return;
    }
    
    [self cleanMemory];
    self.pageCount = [self.dataSource numberOfControllers];
    
    if (self.pageCount <= 0) {
        return;
    }
    
    
    [self updateScrollViewLayoutIfNeed];
    
    // 取出当前要显示的controller，并显示出来
    [self showIndex:self.currentIndex animation:NO];
}

/// 非交互式显示某个index位置的视图
- (void)showIndex:(NSInteger)index animation:(BOOL)animation {
    NSAssert(index >= 0 || index < self.pageCount, @"index 越界[0...%ld]", self.pageCount);
    if (index < 0 || index >= self.pageCount) {
        return;
    }
    
    if (self.scrollView.frame.size.width > 0 && self.scrollView.contentSize.width > 0) {
        NSInteger oldSelectIndex = self.lastIndex;
        self.lastIndex = self.currentIndex;
        self.currentIndex = index;
        
        if ([self.delegate respondsToSelector:@selector(pageView:willChangeToIndex:)]) {
            [self.delegate pageView:self willChangeToIndex:self.currentIndex];
        }
       
        if (animation) {
            if (self.lastIndex != self.currentIndex) {  // 如果非交互切换的index和currentindex一样，则什么都不做
                __block CGSize pageSize = self.scrollView.frame.size;
                BOOL scrollRight = (self.lastIndex < self.currentIndex) ? YES : NO;
                UIView *lastView = [self controllerAtIndex:self.lastIndex].view;
                UIView *currentView = [self controllerAtIndex:self.currentIndex].view;
                // oldselectindex 就是第一个动画选择的index
                UIView *oldSelectView = [self controllerAtIndex:oldSelectIndex].view;
                
                CGFloat backgroundIndex = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
                UIView *backgroundView = nil;
                // 这里考虑的是第一次动画还没结束，就开始第二次动画，需要把当前的处的位置的view给隐藏掉，避免出现一闪而过的情形。
                if (oldSelectView.layer.animationKeys.count > 0 && lastView.layer.animationKeys.count > 0) {
                    UIView *tmpView = [self controllerAtIndex:backgroundIndex].view;
                    if (tmpView != currentView && tmpView != lastView) {
                        backgroundView = tmpView;
                        backgroundView.hidden = YES;
                    }
                }
                
                // 结束之前的动画
                [self.scrollView.layer removeAllAnimations];
                [oldSelectView.layer removeAllAnimations];
                [lastView.layer removeAllAnimations];
                [currentView.layer removeAllAnimations];
                
                
                // 这里需要还原第一次切换的view的位置
                [self moveView:oldSelectView toIndex:oldSelectIndex];
                
                // 为了防止切换距离较远的两个index时产生闪屏，这里把lastview和currentview 起始放到了相邻位置，在动画结束的时候，再还原位置。
                [self.scrollView bringSubviewToFront:lastView]; lastView.hidden = NO;
                [self.scrollView bringSubviewToFront:currentView]; currentView.hidden = NO;
                
                // 将current移动到last旁边
                CGPoint lastViewStartOrigin = lastView.frame.origin;
                CGPoint currentViewStartOrigin = lastViewStartOrigin;
                CGFloat offset = scrollRight ? self.scrollView.frame.size.width : -self.scrollView.frame.size.width;
                currentViewStartOrigin.x += offset;
                // current 和 last 动画移动到的点
                CGPoint lastViewAnimationOrgin = lastViewStartOrigin;
                lastViewAnimationOrgin.x -= offset;
                CGPoint currentViewAnimationOrgin = lastViewStartOrigin;
                // 动画以后需要还原的点
                CGPoint lastViewEndOrigin = lastViewStartOrigin;
                CGPoint currentViewEndOrgin = currentView.frame.origin;
                
                lastView.frame = CGRectMake(lastViewStartOrigin.x, lastViewStartOrigin.y, pageSize.width, pageSize.height);
                currentView.frame = CGRectMake(currentViewStartOrigin.x, currentViewStartOrigin.y, pageSize.width, pageSize.height);
                
                // 非交互的切换页面，animation==YES时，将两个view放到相邻位置，然后动画，模拟滑动效果，最后还原位置
                CGFloat duration = 0.3;
                __weak CVPageView *wSelf = self;
                [UIView animateWithDuration:duration animations:^{
                    lastView.frame = CGRectMake(lastViewAnimationOrgin.x, lastViewAnimationOrgin.y, pageSize.width, pageSize.height);
                    currentView.frame = CGRectMake(currentViewAnimationOrgin.x, currentViewAnimationOrgin.y, pageSize.width, pageSize.height);
                }  completion:^(BOOL finished) {
                    __strong CVPageView *bSelf = wSelf;
                    
                    if (finished) {
                        pageSize = bSelf.scrollView.frame.size;
                        lastView.frame = CGRectMake(lastViewEndOrigin.x, lastViewEndOrigin.y, pageSize.width, pageSize.height);
                        currentView.frame = CGRectMake(currentViewEndOrgin.x, currentViewEndOrgin.y, pageSize.width, pageSize.height);
                        
                        backgroundView.hidden = NO;
                        [bSelf moveView:currentView toIndex:bSelf.currentIndex];
                        [bSelf moveView:lastView toIndex:bSelf.lastIndex];
                        [bSelf scrollBeginAnimation];
                        [bSelf scrollAnimation];
                        [bSelf scrollEndAnimation];
                    }
                }];

            } else {
                //... index和currentindex一样，则什么都不做
            }
        } else {
            [self scrollBeginAnimation];
            [self scrollAnimation];
            [self scrollEndAnimation];
        }
    }
}

#pragma mark - Private
- (UIViewController *)controllerAtIndex:(NSInteger)index {
    // 首先从缓存取，如果缓存没有，则从数据源取
    UIViewController *controller = [self.memCaches objectForKey:@(index)];
    if (!controller) {
        controller = [self.dataSource pageView:self controllerAtIndex:index];
        if (controller) {
            
            // 将新的controller存在缓存中
            [self.memCaches setObject:controller forKey:@(index)];
            
            // 将控制器添加到父控制器中，并添加他的view
            [self addChildViewController:controller];
            [self.scrollView addSubview:controller.view];
        }
    }
    controller.view.frame = CGRectMake(self.scrollView.frame.size.width * index, 0, self.frame.size.width, self.frame.size.height);
    return controller;
}

- (void)updateScrollViewLayoutIfNeed {
    if (self.scrollView.frame.size.width > 0) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.pageCount, self.scrollView.frame.size.height);
    }
}

#pragma mark - Add & Remove Controller
/// 将控制器添加到父控制器
- (void)addChildViewController:(UIViewController *)childController {
    if (![self.superController.childViewControllers containsObject:childController]) {
        [self.superController addChildViewController:childController];
        [childController didMoveToParentViewController:self.superController];
    }
    [self.superController addChildViewController:childController];
    [childController didMoveToParentViewController:self.superController];
}

/// 将控制器从父控制器移除
- (void)removeFromParentVC:(UIViewController *)controller {
    [controller willMoveToParentViewController:nil];
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
}

#pragma mark - Private Scroll
#pragma mark 非交互切换页面
/// 滚动当前页
- (void)scrollAnimation {
    [self.scrollView setContentOffset:CGPointMake(self.currentIndex * self.scrollView.frame.size.width, 0) animated:NO];
}

/// 滚动动画开始
- (void)scrollBeginAnimation {
    [[self controllerAtIndex:self.currentIndex] beginAppearanceTransition:YES animated:NO];
    if (self.currentIndex != self.lastIndex) {
        [[self controllerAtIndex:self.lastIndex] beginAppearanceTransition:NO animated:NO];
    }
}

/// 滚动动画结束
- (void)scrollEndAnimation {
    [[self controllerAtIndex:self.currentIndex] endAppearanceTransition];
    if (self.currentIndex != self.lastIndex) {
        [[self controllerAtIndex:self.lastIndex] endAppearanceTransition];
    }
}

/// 将view的offsetX迁移到 index 位置的offsetX
- (void)moveView:(UIView *)view toIndex:(NSInteger)index {
    if (index < 0 || index >= self.pageCount || !view) {
        return;
    }
    UIView *destView = view;
    CGFloat offsetX = index * self.scrollView.frame.size.width;
    if (offsetX < 0) { offsetX = 0; }
    if (offsetX > self.scrollView.contentSize.width - self.scrollView.frame.size.width) {
        offsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    }
    
    if (destView.frame.origin.x != offsetX) {
        CGRect newFrame = destView.frame;
        newFrame.origin.x = offsetX;
        destView.frame = newFrame;
    }
}

#pragma mark - Delegate - <ScrollViewDelegate>
#pragma mark 交互切换页面
/// PageView 即将拖拽，记录当前的偏移量，暂时先将当前index，赋值给gussToIndex
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (!scrollView.isDecelerating) {
        self.originOffset = scrollView.contentOffset.x;
        self.guessToIndex = self.currentIndex;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageView:willBeginDragging:)]) {
        [self.delegate pageView:self willBeginDragging:self.scrollView];
    }
}

/// PageView在拖动过程中，预测，初始化 过渡 下一页的内容
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isDragging && scrollView == self.scrollView) {
        
        CGFloat offset = scrollView.contentOffset.x;
        CGFloat width = scrollView.frame.size.width;
        NSInteger lastGuestIndex = self.guessToIndex < 0 ? self.currentIndex : self.guessToIndex;
        
        if (self.originOffset < offset) { // 向上一页滑动，采用向上取整的方式
            self.guessToIndex = ceil(offset / width);
        } else if (self.originOffset >= offset) { // 向下一页滑动，采用向下取整的方式
            self.guessToIndex = floor(offset / width);
        }
        
        if (((self.guessToIndex != self.currentIndex && !self.scrollView.isDecelerating) || self.scrollView.isDecelerating) && lastGuestIndex != self.guessToIndex && self.guessToIndex >= 0 && self.guessToIndex < self.pageCount) {
            if ([self.delegate respondsToSelector:@selector(pageView:willChangeToIndex:)]) {
                [self.delegate pageView:self willChangeToIndex:self.guessToIndex];
            }
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageView:didScroll:)]) {
        [self.delegate pageView:self didScroll:self.scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x; // 防止offset小于0
    NSInteger newIndex = offset / scrollView.frame.size.width;
    NSInteger oldIndex = self.currentIndex;
    self.currentIndex = newIndex;
    
    if (newIndex == oldIndex) { // 滑动最终结果还是当前页
        // ...
    } else {
        [[self controllerAtIndex:newIndex] beginAppearanceTransition:YES animated:YES];
        [[self controllerAtIndex:oldIndex] beginAppearanceTransition:NO animated:YES];
        
        [[self controllerAtIndex:oldIndex] endAppearanceTransition];
        [[self controllerAtIndex:newIndex] endAppearanceTransition];
    }
    
    self.originOffset = scrollView.contentOffset.x;
    self.guessToIndex = self.currentIndex;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageView:didEndDecelerating:)]) {
        [self.delegate pageView:self didEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageView:didEndScrollingAnimation:)]) {
        [self.delegate pageView: self didEndScrollingAnimation:scrollView];
    }
}

#pragma mark - Clean
- (void)cleanMemory {
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    [self.lastContentOffset removeAllObjects];
    [self.lastContentSize removeAllObjects];
    
    if (self.memCaches.count > 0) {
//        [self clearObserver];
        NSArray *vcArray = self.memCaches.allValues;
        [self.memCaches removeAllObjects];
        for (UIViewController *vc in vcArray) {
            [self removeFromParentVC:vc];
            
        }
        vcArray = nil;
    }
}

- (void)dealloc
{
    [self cleanMemory];
}

#pragma mark - Setter

#pragma mark - Lazy Load
- (UIViewController *)superController {
    if (!_superController) {
        UIResponder *nextResponder = [self nextResponder];
        do {
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                _superController = (UIViewController *)nextResponder;
            }
            nextResponder = [nextResponder nextResponder];
        } while (nextResponder != nil);
    }
    return _superController;
}

@end
