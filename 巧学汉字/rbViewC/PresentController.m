//
//  PresentController.m
//  MagicPen
//
//  Created by readboy2 on 15/6/18.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import "PresentController.h"

@implementation PresentController
//{
//    UIView *dimmingView;
//}
//
//-(id) initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
//{
//    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
//    if(self){
//        
//        dimmingView = [[UIView alloc] init];
//        dimmingView.backgroundColor = [UIColor grayColor];
//        dimmingView.alpha = 0.0;
//    }
//    return self;
//}
//
//- (void)presentationTransitionWillBegin
//{
//    dimmingView.frame = self.containerView.bounds;
//    [self.containerView addSubview:dimmingView];
//    [self.containerView addSubview:self.presentedView];
//    
//    id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
//    
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
//        dimmingView.alpha = 0.5;
//    } completion:nil];
//}
//
//- (void)presentationTransitionDidEnd:(BOOL)completed
//{
//    if(!completed){
//        [dimmingView removeFromSuperview];
//    }
//}
//
//- (void)dismissalTransitionWillBegin
//{
//    id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
//    
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
//        dimmingView.alpha = 0.0;
//    } completion:nil];
//}
//
//- (void)dismissalTransitionDidEnd:(BOOL)completed
//{
//    if(completed){
//        [dimmingView removeFromSuperview];
//    }
//}
//
//- (CGRect)frameOfPresentedViewInContainerView
//{
//    return CGRectMake(62.f, 114.f, 300.f, 200.f);
//}

@end
