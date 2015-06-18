/*
 *  ComAirAPI.h
 *  ComAir API V1.1.1
 *
 *  Created by Generalplus SA1 on 2012/11/20.
 *  Copyright 2011 GeneralPlus. All rights reserved.
 *
 */

#ifndef _COMAIRAPI_H
#define _COMAIRAPI_H
#include <MacTypes.h>

#if defined(__cplusplus)
extern "C" {
#endif
//--------------------------------------------------	
//Error code	
//--------------------------------------------------	
#define		COMAIR_NOERR					0 
#define		COMAIR_AUIDOUINTFAILED			1
#define		COMAIR_ENABLEIORECFAILED		2
#define		COMAIR_SETFORMATFAILED			3
#define		COMAIR_SETRECCALLBACKFAILED		4
#define		COMAIR_ALLOCBUFFAILED			5
#define		COMAIR_AUDIONOTINIT				6
#define		COMAIR_UNSUPPORTMODE			7
#define		COMAIR_UNSUPPORTTHRESHOLD		8
#define		COMAIR_SETREGCODEFAILED			9	
#define		COMAIR_PLAYCOMAIRSOUNDFAILED	10	
#define		COMAIR_PROPERTYNOTFOUND         11	
#define		COMAIR_PROPERTYOPERATIONFAILED  12	
//--------------------------------------------------	
//Defines	
//--------------------------------------------------		
typedef enum 
{
	eDecodeMode_1Sec	=1,		//1		second
	eDecodeMode_05Sec	=2		//0.5	second
		
}eAudioDecodeMode;
	
typedef enum 
{
    eEncodeMode_1Sec	=24,	//1		second
    eEncodeMode_05Sec	=48  	//0.5	second
		
}eAudioEncodeMode;    

typedef enum 
{
	eComAirPropertyTarget_Both    = 0 ,  //Encode/Decode
	eComAirPropertyTarget_Encode  = 1 ,   
	eComAirPropertyTarget_Decode  = 2 ,	 
	
}eComAirPropertyTarget; 		

typedef enum 
{
	eComAirProperty_RegCode      = 0 ,   //Encode/Decode,Write only
	eComAirProperty_CentralFreq  = 1 ,	 //Encode/Decode,Write/Read
	eComAirProperty_iDfValue     = 2 ,	 //Encode/Decode,Write/Read
	eComAirProperty_Threshold    = 3 ,	 //Decode,Write/Read
	eComAirProperty_VolumeCtrl   = 4 	 //Decode,Write/Read

		
}eComAirProperty;
    
/**
 * a data structure contains COMAIR command
 */
typedef struct tagComAirCommandList
{
    //The COMAR sound index , 0-63
	int		i32command;
    //The mute interval afer playing COMAIR sound
	Float32 f32Delay;
	
}S_ComAirCommnadList;
		
typedef int (*PFN_UserCallBack) (int i32Commnad);	
typedef int (*PFN_UserRawDataCallBack) (unsigned char* pbyRawData,int i32Size);	
	
#define		COMAIR_MAXTHRESHOLD		    128
#define		COMAIR_MINTHRESHOLD		    2	
#define		COMAIR_MAXVOLUMEEPERCENT	1000
//-------------------------------------------------	
//Functions	
//-------------------------------------------------
    /**
     * 初始化 COMAIR
     *  This API should be Called before any other ones
     *  @return Success 0 | Fail  Other Value
     */
int		InitComAirAudio();
    /**
     *  释放COMAR
     *  This API should be called before exit program
     *   @return Success 0 | Fail  Other Value
     */
int		UnitComAirAudio();
    /**
     *  开始COMAIR 解码
     *  Before calling this API ,it must call SetComAirUserCallBack() to
     *  set user call back first
     *  @return  Success 0 | Fail  Other Value
     */
int		StartComAirDecode();
    /**
     *  停止COMAIR 解码
     *
     *  @return Success 0 | Fail  Other Value
     */
int		StopComAirDecode();
	
#pragma Audio mode
    /**
     *  设置COMAIR 解码模式
     *  This API can dynamically change mode after StartComAirDecode()
     *  @param eMode eDecodeMode_1Sec | eDecodeMode_05Sec
     *
     *  @return  Success 0 | Fail  Other Value
     */
int		SetComAirDecodeMode(eAudioDecodeMode eMode);
    /**
     *  获取当前COMAIR 解码模式
     *
     *  @return  Success 0 | Fail  Other Value
     */
eAudioDecodeMode	GetComAirDecodeMode();	
    /**
     *  设置COMAIR 编码模式
     *
     *  @param eMode eMode eEncodeMode_1Sec | eDecodeMode_05Sec
     *
     *  @return Success 0 | Fail  Other Value
     */
int		SetComAirEncodeMode(eAudioEncodeMode eMode);
    /**
     *  获取当前COMAIR 码模式
     *
     *  @return  Success 0 | Fail  Other Value
     */
eAudioEncodeMode	GetComAirEncodeMode();
    /**
     *  设置 COMAIR 属性
     *
     *  @param eTarget   编码|解码|两者
     *  @param eProperty 属性 eComAirProperty
     *  @param vpValue   属性 值
     *
     *  @return Success 0 | Fail  Other Value
     */
int     SetComAirProperty(eComAirPropertyTarget eTarget,eComAirProperty eProperty,void *vpValue);	
int     GetComAirProperty(eComAirPropertyTarget eTarget,eComAirProperty eProperty,void *vpValue);	
	
#pragma Encode/Decode Property
    /**
     * Set Register code for encoding / decoding Command
     *
     *  @param pbyRegCode
     *
     *  @return
     */
int		SetRegCode(UInt8 *pbyRegCode); 
    /**
     *  设置 COMAIR 解码/编码 中心频率
     *  The suitable(合适) central frequency is 17500HZ 
     *  becase the ipad/iphone frequency respones from 20HZ to 20000HZ
     *  @param i32Freq 频率值
     *
     *  @return  Success 0 | Fail  Other Value
     */
int     SetCentralFreq(int i32Freq);
    /**
     *  获取 COMAIR 解码/编码 中心频率
     *
     *  @return 中心频率
     */
int     GetCentralFreq();
    /**
     *  设置 COMAIR 频率 shift 值 ，供高级用户用
     *  The suitable(合适) value is 562
     *  @param i32Value
     *
     *  @return Success 0 | Fail  Other Value
     */
int     SetiDfValue(int i32Value);
    /**
     *  获取 shift
     *
     *  @return shift值
     */
int     GetiDfValue();	

#pragma Decode Property
    /**
     *  设置 解码的 threshold（临界值，灵敏） 值。
     *  This value is for modifying the sensitive level of COMAIR sound 
     *  Reducing it will be able to catch weaker signal of COMAIR sound
     *  Raising it will  be able ti catch stronger one.
     *  The default value is 64 ,usually no need to modify this.
     
     *  This API can dynamically change Threshold after StartComAirDecode()
     *  @param i32Threshold    2 - 128
     *
     *  @return Success 0 | Fail  Other Value
     */
int		SetComAirThreshold(int i32Threshold);
int		GetComAirThreshold();
    /**
     *  Set the Volume percentage of PCM raw data for decode COMAIR command
     *  The suitable(合适) value is  100
     *  @param i16Volume
     *
     *  @return  Success 0 | Fail  Other Value
     */
int     SetVolumeCtrl(short i16Volume);	
short   GetVolumeCtrl();	
	
#pragma Callback
    /**
     *  设置用户回调
     *  User call back will be called when catch the command during decoding 
     *  COMAIR sound
     *  @param pfnUserCallBack  回调函数指针
     *
     *  @return Success 0 | Fail  Other Value
     */
int		SetComAirUserCallBack(PFN_UserCallBack pfnUserCallBack);
    /**
     *  Set the user call back function for saving raw PCM data
     *
     *  @param pfnUserCallBack 回调函数指针
     *
     *  @return Success 0 | Fail  Other Value
     */
int		SetComAirUserRawDataCallBack(PFN_UserRawDataCallBack pfnUserCallBack);

#pragma Playback
    /**
     *  Mix COMAIR sound with user sound and play it
     *
     *  @param fileURL     The URL file path on Ios
     *  @param SoundVolume 0-2.0
     *  @param i32command  0-63
     *
     *  @return  Success 0 | Fail  Other Value
     */
int		PlaySoundWithComAirCmd(NSURL *fileURL,Float32 SoundVolume,int i32command);
    /**
     *  Play COMAIR sound
     *
     *  @param i32command  The COMAIR sound index    0- 63
     *  @param SoundVolume The level of sound volume 0- 1.0
     *
     *  @return Success 0 | Fail  Other Value
     */
int		PlayComAirCmd(int i32command,Float32 SoundVolume);
    /**
     *  Play COMAIR sound list by  specified th delay between sounds
     *
     *  @param i32Cnt       the command list count
     *  @param pCommandList S_ComAirCommnadList 指针
     *  @param SoundVolume  he level of sound volume 1- 1.0
     *
     *  @return Success 0 | Fail  Other Value
     */
int		PlayComAirCmdList(int i32Cnt,S_ComAirCommnadList *pCommandList,Float32 SoundVolume);
    /**
     *  是否正在播放 COMAIR sound
     *
     *  @return  ture if COMAIR sound is Playing ,false Otherwise
     */
BOOL    IsComAirCmdPlaying();	
	
#if defined(__cplusplus)
}
#endif

#endif