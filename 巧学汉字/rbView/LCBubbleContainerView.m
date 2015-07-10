//
//  LCBubbleContainerView.m
//  MagicPen
//  
//  Created by readboy2 on 15/6/25.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import "LCBubbleContainerView.h"

@implementation LCBubbleContainerView
{
    NSMutableArray *bubbleArray;
}

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    DDLogDebug(@"%@,%@",THIS_FILE,THIS_METHOD);
    //能重叠
    _isCanOverlap = YES;

    
    bubbleArray = [NSMutableArray array];
    [NSTimer scheduledTimerWithTimeInterval:0.05
                                     target:self
                                   selector:@selector(fresh)
                                   userInfo:nil
                                    repeats:YES];
}
-(void)fresh
{
    for(int i = 0;i<bubbleArray.count;i++)
    {
        BubbleView *bubble = [bubbleArray objectAtIndex:i];

        if((bubble.frame.origin.x + bubble.frame.size.width >= self.bounds.size.width && bubble.xSpeed >0)
           ||(bubble.frame.origin.x <=0 && bubble.xSpeed < 0))
        {
            bubble.xSpeed = -bubble.xSpeed;
        }
        
        if((bubble.frame.origin.y + bubble.frame.size.height >= self.bounds.size.height && bubble.ySpeed >0)
           ||(bubble.frame.origin.y   <=0 && bubble.ySpeed < 0 ))
        {
            bubble.ySpeed = -bubble.ySpeed;
        }	
        
        CGPoint center = CGPointMake(bubble.center.x+bubble.xSpeed,bubble.center.y+bubble.ySpeed);
        bubble.center = center;
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    DDLogDebug(@"%@,%@",THIS_FILE,THIS_METHOD);
    
}
-(void)setDataSource:(id<BubbleViewDataSource>)dataSource
{
    DDLogDebug(@"%@,%@",THIS_FILE,THIS_METHOD);
    _dataSource = dataSource;
    [self loadViewsIfNeeded];
}
- (void)loadViewsIfNeeded {
    DDLogDebug(@"%@,%@",THIS_FILE,THIS_METHOD);
    //子View 的个数
    int subViewNum = [_dataSource bubbleNumber:self];
    DDLogDebug(@"%@,%@,subViewNum = %d",THIS_FILE,THIS_METHOD,subViewNum);
    NSInteger numViews = self.subviews.count;
    for (NSInteger i = numViews; i < subViewNum; i++) {
        BubbleView *nextView = (BubbleView *)[self nextSubView];
        
        NSString * name = [NSString stringWithFormat:@"word_pao_%i",i+1];
        [nextView.bubbleBgView setImage:[UIImage imageNamed:name]];
        
        if (nextView) {
            [self addSubview:nextView];
            [self sendSubviewToBack:nextView];
            [bubbleArray addObject:nextView];
            //初始化时的位置
            nextView.center =  CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        }
    }

}
- (UIView *)nextSubView {
    DDLogDebug(@"%@,%@",THIS_FILE,THIS_METHOD);
    UIView *nextView = nil;
    if ([self.dataSource
         respondsToSelector:@selector(bubbleView:)]) {
        nextView = [self.dataSource bubbleView:self];
    }
    if (nextView) {
        [nextView
         addGestureRecognizer:[[UIGestureRecognizer alloc]
                               initWithTarget:self
                               action:@selector(handleSingle:)]];
    }
    return nextView;
}
-(void)handleSingle:(UIGestureRecognizer*)recognizer
{
    
}

@end
