//
//  HzDataInfo.m
//  MagicPen
//
//  Created by readboy2 on 15/6/19.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import "HzDataInfo.h"

@implementation HzDataInfo


-(void)dataDescription
{
    NSLog(@"hanzi = %@",self.hanzi);
    NSLog(@"pinyin = %@",self.pinyin);
    
    NSLog(@"hzSndAddr = %d",self.hzSndAddr);
    NSLog(@"hzSndSize = %d",self.hzSndSize);
    NSLog(@"wordAddr = %d",self.wordAddr);
    NSLog(@"wordSize = %d",self.wordSize);
    NSLog(@"hzBhAddr = %d",self.hzBhAddr);
    NSLog(@"hzBhSize = %d",self.hzBhSize);
    NSLog(@"wordSndAddr = %d",self.wordSndAddr);
    NSLog(@"wordSndSize = %d",self.wordSndSize);
    NSLog(@"wordPicAddr = %d",self.wordPicAddr);
    NSLog(@"wordPicSize = %d",self.wordPicSize);
    NSLog(@"sentAddr = %d",self.sentAddr);
    NSLog(@"sentSize = %d",self.sentSize);
    NSLog(@"sentSndAddr = %d",self.sentSndAddr);
    NSLog(@"sentSndSize = %d",self.sentSndSize);
    
}


/**
 * 转码
 *
 * @param src
 * @return
 */
-(NSString*) changeCode:(NSString*) src
{
    unichar chars[src.length];
    memcpy(chars, [src cStringUsingEncoding:NSASCIIStringEncoding], [src length]);
 
    for (int i = 0; i < src.length; i++) {
        if (chars[i] == 0x0061){
            chars[i] = 0xE28D; //a
        }else if (chars[i] == 0x0101)
            chars[i] = 0xE289;// a一声
        else if (chars[i] == 0x00E1)
            chars[i] = 0xE28A;// a二声
        else if (chars[i] == 0x01CE)
            chars[i] = 0xE28B;// a三声
        else if (chars[i] == 0x00E0)
            chars[i] = 0xE28C;// a四声
    }
   return [NSString stringWithCharacters:chars length:src.length];
}
@end
