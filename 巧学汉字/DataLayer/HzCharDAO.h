//
//  HzCharDAO.h
//  MagicPen
//
//  Created by readboy2 on 15/6/22.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HzCharDAO : NSObject
+(instancetype)sharedManger;

-(NSInteger)getGroupHz;
-(NSArray*)getHzChar:(NSInteger) groupIndex;
@end
