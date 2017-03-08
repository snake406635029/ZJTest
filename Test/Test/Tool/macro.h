//
//  macro.h
//  Test
//
//  Created by 张健 on 2017/2/28.
//  Copyright © 2017年 ZJ. All rights reserved.
//

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

/**
 *  常量定义
 */
#define iOSKey @""
#define androidKey @""

#define iOSType 1
#define androidType 2

/**
 *  接口定义
 */

#define UMAuthToken @"http://api.umeng.com/authorize"  //email,password

#define UMBaseInfoByApp @"http://api.umeng.com/channels"  //appkey,auth_token
