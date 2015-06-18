//
//  DrawingController.h
//  趣味画板
//
//  Created by readboy1 on 15/6/3.
//  Copyright (c) 2015年 Readboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawingController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *paletteLocation;
@property (weak, nonatomic) IBOutlet UIButton *showKit;
@property (weak, nonatomic) IBOutlet UIView *widthViews;
@property (weak, nonatomic) IBOutlet UIView *contentSelBoard;

- (void)setRecoverSelIndex:(NSInteger)tag;
- (void)updateWorksName:(NSMutableArray *)worksName andWorksData:(NSMutableDictionary *)worksData;

- (IBAction)closeDrawing:(UIButton *)sender;
- (IBAction)pageUp:(UIButton *)sender;
- (IBAction)pageDown:(UIButton *)sender;
- (IBAction)showBox:(UIButton *)sender;
- (IBAction)showKit:(UIButton *)sender;
- (IBAction)newWork:(UIButton *)sender;
- (IBAction)deleteSomething:(UIButton *)sender;
- (IBAction)works:(UIButton *)sender;
- (IBAction)itemSel:(UIButton *)sender;
- (IBAction)backgroundSel:(UIButton *)sender;
- (IBAction)eraser:(UIButton *)sender;
- (IBAction)pencil:(UIButton *)sender;
- (IBAction)changeWidth:(UIButton *)sender;

@end
