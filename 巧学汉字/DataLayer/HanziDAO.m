//
//  HanziDAO.m
//  MagicPen
//  汉字数据访问操作类
//  Created by readboy2 on 15/6/19.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#import "HanziDAO.h"
#import "HzStroke.h"


//每个汉字的信息长度
#define  HZINFO_LEN  72
//每组汉字的个数
#define  HZGROUP_NUM 6

#define  FileName   @"hanzi"
#define  FileType   @"pin"



@implementation HanziDAO
{
    NSFileHandle* fileHandle;
    //汉字个数
    int hzNum;
    //汉字索引地址
    int indexAddr;
    //汉字信息地址
    int hzInfoAddr;
    //组的个数
    int groupNum;
    
}
+(instancetype)sharedManger
{
    static dispatch_once_t once;
    static HanziDAO *hzDAO;
    dispatch_once(&once, ^ {
        /**
         *  特别注意，要把文件加进来才可以 
         *  Targets - > build pharses -> copy bundle resource ->添加文件
         */
        NSString *hanziFilePath = [[NSBundle mainBundle] pathForResource: FileName
                                                                  ofType: FileType];
        
        hzDAO = [[self alloc] initHanziData:hanziFilePath];
    });
    return hzDAO;
}
/**
 *  初始化数据
 *
 *  @param path 文件路径
 *
 *  @return id
 */
-(id)initHanziData:(NSString*)path
{
    NSLog(@"path = %@",path);
    NSAssert(path != nil, @"汉字数据路径不存在！！");
    if ([self init]) {
        
        fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
        
        [fileHandle seekToFileOffset:16];
        hzNum = [self readNbytes2Num:fileHandle off:0 length:2];
        groupNum = hzNum / HZGROUP_NUM;
        [fileHandle seekToFileOffset:20];
        indexAddr = [self readNbytes2Num:fileHandle off:0 length:4];
        hzInfoAddr = [self readNbytes2Num:fileHandle off:0 length:4];
        
        NSLog(@"hzNum = %d",hzNum);
        NSLog(@"groupNum = %d",groupNum);
        NSLog(@"indexAddr = %d",indexAddr);
        NSLog(@"hzInfoAddr = %d",hzInfoAddr);
    }
    return self;
}
/**
 *  退出
 */
-(void)hzDataExit
{
    if (fileHandle) {
        [fileHandle closeFile];
        fileHandle = nil;
    }
}
/**
 *  获取汉字的个数
 *
 *  @return 汉字个数
 */
-(int)hzDataGetHzNum
{
    return hzNum;
}
/**
 *  buffer 2 汉字信息类
 *
 *  @param buffer
 *  @param hzInfo
 *  @param offset
 */
- (void)bufferToHzDataInfo:(Byte* )buffer
                    hzInfo:(HzDataInfo*)hzInfo
                    offset:(int) offset
{
    hzInfo.hanzi = [self getHanZi:buffer];
    hzInfo.pinyin = [self getPinYin:buffer + 4];
 
    hzInfo.hzSndAddr     = [self readBuffer2Num:buffer  off: offset + 16 length:4];
    hzInfo.hzSndSize     = [self readBuffer2Num:buffer  off: offset + 20 length:4];

    hzInfo.hzBhAddr      = [self readBuffer2Num:buffer  off: offset + 24 length:4];
    hzInfo.hzBhSize      = [self readBuffer2Num:buffer  off: offset + 28 length:4];

    hzInfo.wordAddr      = [self readBuffer2Num:buffer  off: offset + 32 length:4];
    hzInfo.wordSize      = [self readBuffer2Num:buffer  off: offset + 36 length:2];

    hzInfo.wordSndAddr   = [self readBuffer2Num:buffer  off: offset + 38 length:4];
    hzInfo.wordSndSize   = [self readBuffer2Num:buffer  off: offset + 42 length:4];

    hzInfo.wordPicAddr   = [self readBuffer2Num:buffer  off: offset + 46 length:4];
    hzInfo.wordPicSize   = [self readBuffer2Num:buffer  off: offset + 50 length:4];

    hzInfo.sentAddr      = [self readBuffer2Num:buffer  off: offset + 54 length:4];
    hzInfo.sentSize      = [self readBuffer2Num:buffer  off: offset + 58 length:2];

    hzInfo.sentSndAddr   = [self readBuffer2Num:buffer  off: offset + 60 length:4];
    hzInfo.sentSndSize   = [self readBuffer2Num:buffer  off: offset + 64 length:4];
    

}
/**
 *  获取当个汉字信息
 *
 *  @param index 汉字序号
 *
 *  @return 汉字信息
 */
-(HzDataInfo*)hzDataReadOneInfo:(int)index
{
    if (index < 0 || index > hzNum) {
        NSLog(@"获取汉字消息失败，Reason :序号错误！！index = %d",index);
        return nil;
    }
    Byte *buffer;
    HzDataInfo* dataInfo = [[HzDataInfo alloc] init];
    
    dataInfo.index = index;
    [fileHandle seekToFileOffset:(hzInfoAddr + index * HZINFO_LEN)];
   
    buffer = (Byte*)[[fileHandle readDataOfLength:HZINFO_LEN] bytes];
    
    [self bufferToHzDataInfo:buffer hzInfo:dataInfo offset:0];
    
    return dataInfo;
    
}
/**
 * 读取一组汉字信息
 *
 * @param groupIndex 组的序号
 * @return
 */
-(NSArray*)hzDataReadGroupInfo:(int)groupIndex
{
    if (groupIndex > groupNum || groupIndex < 0) {
        NSLog(@"获取一组汉字消息失败，Reason :序号错误！！groupIndex = %d",groupIndex);
        return nil;
    }
    Byte * byte;
    NSMutableArray * hzArr = [NSMutableArray array];
    HzDataInfo* info = [[HzDataInfo alloc]init];
   
    [fileHandle seekToFileOffset:(hzInfoAddr + groupIndex * HZGROUP_NUM * HZINFO_LEN)];
    byte = (Byte*)[fileHandle readDataOfLength:HZGROUP_NUM * HZINFO_LEN].bytes;
    
    for (int i = 0; i < HZGROUP_NUM; i++) {
        info.index = groupIndex * HZGROUP_NUM + i;
        [self bufferToHzDataInfo:byte hzInfo:info offset: HZINFO_LEN * i];
        [hzArr addObject:info];
    }

    
    return hzArr;
}
/**
 *  获取 image
 *
 *  @param addr image 地址
 *  @param size image 大小
 *
 *  @return image
 */
-(UIImage*)hzDataGetImage:(int)addr size:(int)size
{
    [fileHandle seekToFileOffset:addr];
    NSData * data = [fileHandle readDataOfLength:size];

    return [UIImage imageWithData:data];;
}
/**
 *  获取语音的 Data
 *
 *  @param addr 语音数据地址
 *  @param size 大小
 *
 *  @return DATA
 */
-(NSData*)hzDataGetSnd:(int)addr size:(int)size
{
     [fileHandle seekToFileOffset:addr];
    
    return  [fileHandle readDataOfLength:size];
}

/**
 * 笔画信息
 *
 * @param addr
 * @param size
 * @return
 */
-(HzStroke*)hzDataGetBihua:(int)addr size:(int)size
{
    HzStroke * stroke = nil;
    Byte* byte;
    [fileHandle seekToFileOffset:addr];
    byte = (Byte*)[fileHandle readDataOfLength:size].bytes;
    if (byte != NULL) {
        stroke = [[HzStroke alloc]initHzStroke:byte];
    }
    return stroke;
}
/**
 * 句子需要拆分
 * 
 * 天上|飘着|几朵白云。
 * @param addr
 * @param size
 * @return  词语
 */
-(NSArray*)hzDataGetSentence:(int )addr size:(int) size
{
    NSString* origin = [self hzDataGetString:addr size:size];
    return  [origin componentsSeparatedByString:@"|"];
    
}
/**
 * 根据地址和大小获取字符串
 *
 * @param addr
 * @param size
 * @return
 */
-(NSString*)hzDataGetString:(int)addr  size:(int) size
{
    NSString *str = nil;
  
    @try {
        [fileHandle seekToFileOffset:addr];
         Byte * byte = (Byte*)[fileHandle readDataOfLength:size].bytes;
         str = [self byte2String:byte length:size];
    }
    @catch (NSException *exception) {
       
    }
    @finally {}

    return str;
}
#pragma Mark private

/**
 *  byte 2  int
 *
 *  @param fHandle 文件指针
 *  @param off     偏移量
 *  @param n       要读的字节个数
 *
 *  @return Num
 */
-(int)readNbytes2Num:(NSFileHandle*)fHandle
                 off:(int)off
              length:(int)n
{
    Byte *buff;
    NSData * data = [fHandle readDataOfLength:n];
    buff = (Byte *)[data bytes];
    
    return [self readBuffer2Num:buff off:0 length:n];

}
/**
 *  byte 2  int
 *
 *  @param buff 字节数组
 *  @param off  偏移的字节数
 *  @param n    字节个数
 *
 *  @return int
 */
-(int)readBuffer2Num:(Byte*) buff
                 off:(int)off
            length:(int)n
{
    int num = 0;
    int index = off + (n - 1);
    
    while ((n--) > 0) {
        num <<= 8;
        NSLog(@"buff[%d] = %x",index,buff[index]);
        num += buff[index] & 0xff;
        index--;
    }
    NSLog(@"readBuffer2Num, num = %d",num);
    return num;
}
/**
 *  Byte To NSString
 *
 *  @param buffer 数据
 *  @param len    数据长度
 *
 *  @return 字符串
 */
-(NSString*)byte2String:(Byte*)buffer length:(NSInteger)len
{
    if (buffer == nil) {
        return nil;
    }
    //去掉数据后面的 00
    int i = 0;
    while (i < len) {
        if ((buffer[i] & 0xff) == 0x0) {
            break;
        }
        i++;
    }
    
    //获取 gbk 编码
    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *adata = [[NSData alloc] initWithBytes:buffer
                                           length:i];
    NSString *aString = [[NSString alloc] initWithData:adata
                                              encoding:gbkEncoding];
    return aString;
}
/**
 *  获取汉字
 *
 *  @param hanzi 数据
 *
 *  @return 汉字
 */
-(NSString*) getHanZi:(Byte*)hanzi
{
    if (hanzi == nil) {
        return nil;
    }
    
    return [self byte2String:hanzi length:4];
}
/**
 *  获取拼音
 *
 *  @param pinyin 数据
 *
 *  @return 拼音
 */
-(NSString*) getPinYin:(Byte*)pinyin
{
    if (pinyin == nil) {
        return nil;
    }
    return [self byte2String:pinyin length:12];
}
@end
