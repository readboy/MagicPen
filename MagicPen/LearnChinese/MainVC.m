//
//  ViewController.m
//  MagicPen
//
//  Created by readboy2 on 15/6/15.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import "MainVC.h"
#import "ImageMacros.h"


@interface MainVC ()
@property (weak, nonatomic) IBOutlet UIButton *kouJueBtn;
@property (weak, nonatomic) IBOutlet UIButton *huaBanBtn;
@property (weak, nonatomic) IBOutlet UIButton *hanZiBtn;

- (IBAction)onClickHuaBan:(id)sender;
- (IBAction)onClickHanZi:(id)sender;
- (IBAction)onClickKouJue:(id)sender;



@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClickHuaBan:(id)sender {
    NSLog(@"点击到了画板");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FunDraw" bundle:nil];
    UIViewController *drawingController = [storyboard instantiateViewControllerWithIdentifier:@"FunDrawID"];
    
    [self presentViewController:drawingController
                       animated:YES
                     completion:nil];
    
}

- (IBAction)onClickHanZi:(id)sender {
    NSLog(@"onClickHanZi");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LearnChinese" bundle:nil];
    UIViewController *drawingController = [storyboard instantiateViewControllerWithIdentifier:@"LearnChineseMainID"];
    
    [self presentViewController:drawingController
                       animated:YES
                     completion:nil];
    
   
}

- (IBAction)onClickKouJue:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Arithmetic" bundle:nil];
    UIViewController *drawingController = [storyboard instantiateViewControllerWithIdentifier:@"ArithmeticMainID"];
    
    [self presentViewController:drawingController
                       animated:YES
                     completion:nil];
}


@end
