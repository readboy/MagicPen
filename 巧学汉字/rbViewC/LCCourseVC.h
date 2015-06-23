//
//  LCCourseVC.h
//  MagicPen
//
//  Created by readboy2 on 15/6/18.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCCourseVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

- (IBAction)onClickCourseClose:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *courseTableView;

@end
