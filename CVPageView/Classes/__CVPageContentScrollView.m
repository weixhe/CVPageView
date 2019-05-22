//
//  __CVPageContentScrollView.m
//  Test
//
//  Created by caven on 2019/5/16.
//  Copyright © 2019 com.caven. All rights reserved.
//

#import "__CVPageContentScrollView.h"

@implementation __CVPageContentScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}



@end
