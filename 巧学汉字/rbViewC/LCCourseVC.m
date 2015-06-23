//
//  LCCourseVC.m
//  MagicPen
//
//  Created by readboy2 on 15/6/18.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import "LCCourseVC.h"
#import "PresentController.h"
#import "HanziDAO.h"
#import "LCCourseModel.h"
#import "LCCourseCell.h"

@interface LCCourseVC ()
{
    LCCourseModel * model;
}
@end

@implementation LCCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // self.transitioningDelegate = self;
    // Do any additional setup after loading the view.
    
    HzDataInfo* info = [[HanziDAO sharedManger] hzDataReadOneInfo:0];
    [info dataDescription];
    
    UINib *cellNib = [UINib nibWithNibName:@"LCCourseCell" bundle:nil];
    [self.courseTableView registerNib:cellNib forCellReuseIdentifier:@"LCCourseCellID"];
    
    model = [[LCCourseModel alloc]init];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [model numberOfItemsInSection:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier =  @"LCCourseCellID";
    NSArray* charObj = [model objectAtIndexPath:indexPath];
    
    
    LCCourseCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell shouldUpdateCellWithObject:charObj atIndexPath:indexPath];
    
    return cell;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [_courseTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)onClickCourseClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
