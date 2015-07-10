//
//  BubbleView.h
//
//  Created by readboy2 on 15/6/25.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BubbleView : UIImageView {
	int xSpeed;
	int ySpeed;
}
@property (weak, nonatomic) IBOutlet UIImageView *bubbleBgView;
@property (weak, nonatomic) IBOutlet UILabel *txtLabel;

@property (nonatomic,assign) int xSpeed;
@property (nonatomic,assign) int ySpeed;
@end
