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
    _primaryView = (LCCoinHzView *)primaryView;
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.primaryView setFrame: frame];
    [self addSubview: self.primaryView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipTouched)];
    gesture.numberOfTapsRequired = 1;
    [self.primaryView addGestureRecognizer:gesture];
    
}
-(void)setSecondaryView:(LCCoinWordView *)secondaryView
{
    _secondaryView = secondaryView;
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.secondaryView setFrame: frame];
    
    [self addSubview: self.secondaryView];
    [self sendSubviewToBack:self.secondaryView];
    self.secondaryView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipTouched)];
    gesture.numberOfTapsRequired = 1;
    [self.secondaryView addGestureRecognizer:gesture];
}
-(void) flipTouched{
    
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
