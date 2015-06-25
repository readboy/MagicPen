//
//  LCCardView.m
//  MagicPen
//
//  Created by readboy2 on 15/6/22.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import "LCCardView.h"

@implementation LCCardView
{
    bool displayingPrimary;
    NSInteger index;//翻转的此次
    
}
-(void)setPrimaryView:(LCCoinHzView*)primaryView
{
    if (_primaryView) {
        return;
    }
    _primaryView = (LCCoinHzView *)primaryView;
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    NSLog(@"PrimaryViewframe = %@",NSStringFromCGRect(frame));
    NSLog(@"PrimaryViewframe22 = %@",NSStringFromCGRect(self.frame));
    //[self.primaryView setFrame: frame];
    

    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:primaryView];
    
    // This is important:
    // https://github.com/zhxnlai/ZLSwipeableView/issues/9
    NSDictionary *metrics = @{
                              @"height" : @(self.bounds.size.height),
                              @"width" : @(self.bounds.size.width)
                              };
    //NSDictionary *views = NSDictionaryOfVariableBindings(self);
    NSLayoutConstraint * l = [NSLayoutConstraint constraintWithItem:_primaryView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0f
                                                           constant:0];
    
    NSLayoutConstraint * r = [NSLayoutConstraint constraintWithItem:_primaryView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0f
                                                           constant:0];
    NSLayoutConstraint * t = [NSLayoutConstraint constraintWithItem:_primaryView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:0];
    NSLayoutConstraint * b = [NSLayoutConstraint constraintWithItem:_primaryView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:0];
    [self addConstraint:l];
    [self addConstraint:r];
    [self addConstraint:t];
    [self addConstraint:b];
//    [primaryView addConstraints:
//     [NSLayoutConstraint
//      constraintsWithVisualFormat:@"H:|[self(width)]"
//      options:0
//      metrics:metrics
//      views:views]];
//    [primaryView addConstraints:[NSLayoutConstraint
//                                 constraintsWithVisualFormat:
//                                 @"V:|[self(height)]"
//                                 options:0
//                                 metrics:metrics
//                                 views:views]];
    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(spinCard)];
    gesture.numberOfTapsRequired = 1;
    [self.primaryView addGestureRecognizer:gesture];
    
}
-(void)setSecondaryView:(LCCoinWordView *)secondaryView
{
    if (_secondaryView) {
        return;
    }
    _secondaryView = secondaryView;
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    NSLog(@"SecondaryViewframe = %@",NSStringFromCGRect(frame));
    NSLog(@"SecondaryViewframe22 = %@",NSStringFromCGRect(self.frame));
    //[self.secondaryView setFrame: frame];
    
    [self addSubview: secondaryView];
    [self sendSubviewToBack:secondaryView];
    
    // This is important:
    // https://github.com/zhxnlai/ZLSwipeableView/issues/9
//    NSDictionary *metrics = @{
//                              @"height" : @(self.bounds.size.height),
//                              @"width" : @(self.bounds.size.width)
//                              };
//    NSDictionary *views = NSDictionaryOfVariableBindings(self);
//    [secondaryView addConstraints:
//     [NSLayoutConstraint
//      constraintsWithVisualFormat:@"H:|[self(width)]"
//      options:0
//      metrics:metrics
//      views:views]];
//    [secondaryView addConstraints:[NSLayoutConstraint
//                                 constraintsWithVisualFormat:
//                                 @"V:|[self(height)]"
//                                 options:0
//                                 metrics:metrics
//                                 views:views]];
//    NSLayoutConstraint * w = [NSLayoutConstraint constraintWithItem:_secondaryView
//                                                          attribute:NSLayoutAttributeWidth
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:nil
//                                                          attribute:NSLayoutAttributeWidth
//                                                         multiplier:1.0f
//                                                           constant:self.bounds.size.width];
//    NSLayoutConstraint * h = [NSLayoutConstraint constraintWithItem:_secondaryView
//                                                          attribute:NSLayoutAttributeHeight
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:nil
//                                                          attribute:NSLayoutAttributeHeight
//                                                         multiplier:1.0f
//                                                           constant:self.bounds.size.height];
//    [_secondaryView addConstraint:w];
//    [_secondaryView addConstraint:h];
    NSLayoutConstraint * l = [NSLayoutConstraint constraintWithItem:_secondaryView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0f
                                                           constant:0];
    
    NSLayoutConstraint * r = [NSLayoutConstraint constraintWithItem:_secondaryView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0f
                                                           constant:0];
    NSLayoutConstraint * t = [NSLayoutConstraint constraintWithItem:_secondaryView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:0];
    NSLayoutConstraint * b = [NSLayoutConstraint constraintWithItem:_secondaryView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:0];
    [self addConstraint:l];
    [self addConstraint:r];
    [self addConstraint:t];
    [self addConstraint:b];
    self.secondaryView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(spinCard)];
    gesture.numberOfTapsRequired = 1;
    [self.secondaryView addGestureRecognizer:gesture];
}
/**
 *  翻转卡片
 */
-(void) spinCard{
    
    //开始翻转卡片
    if ([_delegate respondsToSelector:@selector(startSpinCard: cardID:)]) {
        [_delegate startSpinCard:index cardID:_cardID];
    }
    [_primaryView.imgFg setHidden:YES];
    [UIView transitionFromView:(displayingPrimary ? self.primaryView : self.secondaryView)
                        toView:(displayingPrimary ? self.secondaryView : self.primaryView)
                      duration: 1.0f
                       options: UIViewAnimationOptionTransitionFlipFromRight+UIViewAnimationOptionCurveEaseInOut
                    completion:^(BOOL finished) {
                        if (finished) {
                            //翻转结束
                            if ([_delegate respondsToSelector:@selector(endSpinCard: cardID:)]) {
                                [_delegate startSpinCard:index cardID:_cardID];
                            }
                            displayingPrimary = !displayingPrimary;
                            index++;
                        }
                    }
     ];
}

@end
