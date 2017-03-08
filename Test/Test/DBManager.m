//
//  DBManager.m
//  Test
//
//  Created by 张健 on 2017/2/28.
//  Copyright © 2017年 ZJ. All rights reserved.
//

#import "DBManager.h"

//"121.41.31.76", "root", "yijiayou", "yijiayou_rds2"
static const char *host_name = "127.0.0.1";
static const char *user_name = "root";
static const char *password = "123456";
static const char *db_name = "ejiayou";

@interface DBManager()

@end

@implementation DBManager

//查
+(NSArray *)sqlQuery:(NSString *)sql{
    
    MYSQL myconnect ;
    mysql_init(&myconnect);
 
    if (mysql_real_connect(&myconnect, host_name, user_name, password, db_name, MYSQL_PORT, NULL, 0)) {
        mysql_set_character_set(&myconnect, "utf8");
        
        int status = mysql_query(&myconnect, [sql UTF8String]);
        if (status != 0) {
            NSLog(@"查询数据失败");
            return nil;
        }
        MYSQL_RES *result = mysql_store_result(&myconnect);
        long long rows = result->row_count;
        unsigned int fieldCount = mysql_field_count(&myconnect);//字段个数
        
        NSMutableArray *rowArray = [NSMutableArray arrayWithCapacity:rows];
        
        
        MYSQL_ROW col ;//用于保存一行的结果，其实就是一个字符串数组
        for (int row = 0 ; row < rows ; row++) {
            NSMutableArray *colArray = [NSMutableArray arrayWithCapacity:fieldCount];
            if ((col = mysql_fetch_row(result))) {
                for (int i = 0; i < fieldCount; i++) {
                    [colArray addObject:[NSString stringWithUTF8String:col[i]]];
                }
            }
            [rowArray addObject:colArray];
        }
        
        mysql_free_result(result);
        mysql_close(&myconnect);
        return rowArray;

        
    }else {
        NSLog(@"连接失败");
        mysql_close(&myconnect);
    }
    return nil;
}

//增
+(int)sqlInsert:(NSString *)sql{
    
    MYSQL myconnect ;
    mysql_init(&myconnect);
    
    if (mysql_real_connect(&myconnect, host_name, user_name, password, db_name, MYSQL_PORT, NULL, 0)) {
        mysql_set_character_set(&myconnect, "utf8");
        
        int status = mysql_query(&myconnect, [sql UTF8String]);
        if (status != 0) {
            NSLog(@"查询数据失败");
            return -1;
        }
        MYSQL_RES *result = mysql_store_result(&myconnect);
        
        mysql_free_result(result);
        mysql_close(&myconnect);
        return 0;
        
        
    }else {
        NSLog(@"连接失败");
        mysql_close(&myconnect);
    }
    return -1;

}

////删
//+(int)sqlDelete:(NSString *)sql{
//
//}
//
////改
//+(int)sqlUpdate: (NSString *)sql{
//
//}


@end
