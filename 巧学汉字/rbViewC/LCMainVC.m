//
//  LCMainVC.m
//  MagicPen
//
//  Created by readboy2 on 15/6/18.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import "LCMainVC.h"
#import "LCCourseVC.h"

@interface LCMainVC ()

@end

@implementation LCMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   // LCCourseVC *controller = [[LCCourseVC alloc] init];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  返回
 *
 *  @param sender 
 */
- (IBAction)onClickBack:(id)sender {

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
/**
 *  课程表
 *
 *  @param sender
 */
- (IBAction)onClickCourse:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LearnChinese" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"LCCourseVCID"];
    
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        controller.modalPresentationStyle = UIModalPresentationCustom;
    }else{
        controller.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:controller animated:YES completion:nil];
}
/**
 *  识字
 *
 *  @param sender
 */
- (IBAction)onClickMemory:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LearnChinese" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"LCMemoryVCID"];

    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [self presentViewController:controller animated:YES completion:nil];
}
/**
 *  跟读
 *
 *  @param sender
 */
- (IBAction)onClickReadWrite:(id)sender {
}
/**
 *  练习
 *
 *  @param sender
 */
- (IBAction)onClickPractice:(id)sender {
    
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
