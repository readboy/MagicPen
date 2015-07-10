//
//  MagicHeader.h
//  MagicPen
//
//  Created by readboy2 on 15/6/26.
//  Copyright (c) 2015年 readboy. All rights reserved.
//

#ifndef MagicPen_MagicHeader_h
#define MagicPen_MagicHeader_h

#import <CocoaLumberjack/CocoaLumberjack.h>


/**
 typedef NS_ENUM(NSUInteger, DDLogLevel) {
 DDLogLevelOff       = 0,
 DDLogLevelError     = (DDLogFlagError),                       // 0...00001
 DDLogLevelWarning   = (DDLogLevelError   | DDLogFlagWarning), // 0...00011
 DDLogLevelInfo      = (DDLogLevelWarning | DDLogFlagInfo),    // 0...00111
 DDLogLevelDebug     = (DDLogLevelInfo    | DDLogFlagDebug),   // 0...01111
 DDLogLevelVerbose   = (DDLogLevelDebug   | DDLogFlagVerbose), // 0...11111
 DDLogLevelAll       = NSUIntegerMax                           // 1111....11111 (DDLogLevelVerbose plus any other flags)
 };
 */
#if DEBUG
static const int ddLogLevel = DDLogLevelVerbose;;
#else
static const int ddLogLevel = DDLogLevelError;
#endif

#endif
