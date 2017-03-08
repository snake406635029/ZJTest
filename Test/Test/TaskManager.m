//
//  TaskManager.m
//  Test
//
//  Created by 张健 on 2017/2/28.
//  Copyright © 2017年 ZJ. All rights reserved.
//

#import "TaskManager.h"
#import "ZJRequestManger.h"



@implementation TaskManager

/**
 *  task1 获取auth_token
 */
+(void)taskForAuthToken{
    NSString *temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"Auth_Token"];
    if (temp.length > 0 ) {
        DLog(@"任务完成：Auth_Token【%@】已存在",temp);
        return;
    }
    NSDictionary *dict = @{@"email":@"",@"password":@""};
    NSDictionary *result = [ZJRequestManger SynPost:UMAuthToken params:dict];
    
    NSString *Auth_Token;
    if (result.count > 0 ) {
        if ([result[@"code"] integerValue] == 200) {
            Auth_Token = [[NSString alloc] initWithString:result[@"auth_token"]];
            [[NSUserDefaults standardUserDefaults] setObject:Auth_Token forKey:@"Auth_Token"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    DLog(@"任务完成：获取Auth_Token【%@】",Auth_Token);
}

+(void)taskForAppBaseInfos{
    
    NSString *periodDate = [NSDate yesterdayDateString];
    NSString *periodWeek = [NSDate yesterdayWeekString];
    
    //if exist
    NSString *sqlQ = [NSString stringWithFormat:@"select count(*) from ejiayou_app_totalInfos where period_date = '%@'",periodDate];
    NSArray *result = [DBManager sqlQuery:sqlQ];
    if (result.count > 0 && result[0] > 0 ) {
        if ([result[0][0] integerValue] > 0) {
            //说明该所属期已经存在
            DLog(@"任务完成【%@】: 该所属期已存在",periodDate);
            return;
        }
    }
    
    NSDictionary *dictIOS = @{@"appkey":iOSKey,@"date":periodDate};
    NSArray *resultIOS = [ZJRequestManger SynGet:UMBaseInfoByApp params:dictIOS];
    NSDictionary *resultDictIOS;
    if (resultIOS.count > 0) {
        resultDictIOS = [resultIOS objectAtIndex:0];
    }
    
    NSDictionary *dictAndroid = @{@"appkey":androidKey,@"date":periodDate};
    NSArray *resultAndroid = [ZJRequestManger SynGet:UMBaseInfoByApp params:dictAndroid];
    
    NSDictionary *resultDictAndroid;
    if (resultAndroid.count > 0) {
        resultDictAndroid = [resultAndroid objectAtIndex:0];
    }
    
    NSString *sqlKey = @"(today_active_users,today_new_users,installations,today_launches,period_date,update_time,weekDay,osType)";
    
    NSMutableString *sqlValue = [NSMutableString string];
    if (resultDictIOS.count > 0) {
        [sqlValue appendString:[NSString stringWithFormat:@"(%d,%d,%d,%d,%@,%@,%@,%d)",
                                [resultDictIOS[@"active_user"] intValue],
                                [resultDictIOS[@"install"] intValue],
                                [resultDictIOS[@"total_install"] intValue],
                                [resultDictIOS[@"launch"] intValue],
                                [NSString stringWithFormat:@"'%@'",resultDictIOS[@"date"]],
                                @"CURRENT_TIMESTAMP",
                                [NSString stringWithFormat:@"'%@'",periodWeek],
                                iOSType
                                ]];
    }
    if (resultDictAndroid.count > 0) {
        [sqlValue appendString:@","];
        [sqlValue appendString:[NSString stringWithFormat:@"(%d,%d,%d,%d,%@,%@,%@,%d)",
                                [resultDictAndroid[@"active_user"] intValue],
                                [resultDictAndroid[@"install"] intValue],
                                [resultDictAndroid[@"total_install"] intValue],
                                [resultDictAndroid[@"launch"] intValue],
                                [NSString stringWithFormat:@"'%@'",resultDictIOS[@"date"]],
                                @"CURRENT_TIMESTAMP",
                                [NSString stringWithFormat:@"'%@'",periodWeek],
                                androidType
                                ]];
    }
    
    NSString *sql = [NSString stringWithFormat:@"insert into ejiayou_app_totalInfos %@ values %@ ",sqlKey,sqlValue];
    int sqlResult =  [DBManager sqlInsert:sql];
    if (sqlResult == 0) {
        DLog(@"任务完成【%@】: 更新基本信息成功",periodDate);
    }else {
        DLog(@"*****任务失败");
    }
}

@end
