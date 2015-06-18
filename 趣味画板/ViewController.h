//
//  ViewController.h
//  趣味画板
//
//  Created by readboy1 on 15/6/2.
//  Copyright (c) 2015年 Readboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *rbAngel;

@property (weak, nonatomic) IBOutlet UIImageView *rbTitle;

@property (weak, nonatomic) IBOutlet UIImageView *rbPigment;

@property (weak, nonatomic) IBOutlet UIImageView *rbButterfly;

@property (weak, nonatomic) IBOutlet UIImageView *rbMushroom;

- (IBAction)rbClose:(UIButton *)sender;

@end

