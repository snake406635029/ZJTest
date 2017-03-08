//
//  DBManager.h
//  Test
//
//  Created by 张健 on 2017/2/28.
//  Copyright © 2017年 ZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mysql.h"

typedef enum{
    Success = 0,//成功
    Fail = -1
} SqlStatus;

@interface DBManager : NSObject

//查
+(NSArray *)sqlQuery:(NSString *)sql;

//增
+(int)sqlInsert:(NSString *)sql;

//删
+(int)sqlDelete:(NSString *)sql;

//改
+(int)sqlUpdate: (NSString *)sql;

@end
