//
//  LCPacticeHzVC.m
//  MagicPen
//
//  Created by readboy2 on 15/6/25.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import "LCPacticeHzVC.h"

@interface LCPacticeHzVC ()

@end

@implementation LCPacticeHzVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLayoutSubviews
{
    DDLogDebug(@"%@,%@",THIS_FILE,THIS_METHOD);
    // Required Data Source
    self.bubbleContainerView.dataSource = self;
}
//气泡View
- (UIView *)bubbleView:(LCBubbleContainerView *)bubbleContainerView
{
//    BubbleView * bubble = [[BubbleView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    BubbleView * bubble  = [[[NSBundle mainBundle] loadNibNamed:@"BubbleView"
                                                 owner:self
                                               options:nil] objectAtIndex:0];
    
    bubble.xSpeed = arc4random()%8+1;
    bubble.ySpeed = arc4random()%8+1;
    
   // [bubble setImage:[UIImage imageNamed:@"wordtest"]];
    
    return bubble;
}
//气泡的个数
- (int)bubbleNumber:(LCBubbleContainerView *)bubbleContainerView
{
    return 6;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
