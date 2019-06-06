//
//  TabPageErrorView.m
//  CVPageView
//
//  Created by caven on 2019/6/5.
//  Copyright © 2019 com.caven. All rights reserved.
//

#import "TabPageErrorView.h"

@interface TabPageErrorView ()

@property (nonatomic, strong) UILabel *textLabel;

@end

static TabPageErrorView *instance = nil;
@implementation TabPageErrorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor lightGrayColor];
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.text = @"暂时没有相关信息";
        [self addSubview:textLabel];
        self.textLabel = textLabel;
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.textLabel.frame = self.bounds;
}

+ (instancetype)share {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TabPageErrorView alloc] init];
    });
    return instance;
}

+ (void)showInView:(UIView *)view  {
    TabPageErrorView *errorView = [TabPageErrorView share];
    errorView.frame = view.bounds;
    [view addSubview:errorView];
}

+ (void)hidden {
    [[TabPageErrorView share] setHidden:YES];
}

@end
