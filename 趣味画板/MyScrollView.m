//
//  MyScrollView.m
//  趣味画板
//
//  Created by readboy1 on 15/6/9.
//  Copyright (c) 2015年 Readboy. All rights reserved.
//

#import "MyScrollView.h"

@implementation MyScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    return self;
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
    return YES;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return NO;
}

@end
