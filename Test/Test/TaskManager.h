//
//  TaskManager.h
//  Test
//
//  Created by 张健 on 2017/2/28.
//  Copyright © 2017年 ZJ. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TaskManager : NSObject

/**
 *  task1 获取auth_token
 */
+(void)taskForAuthToken;

/**
 *  task2 将app某天的基本信息取下来存在数据库
 */

+(void)taskForAppBaseInfos;

@end
