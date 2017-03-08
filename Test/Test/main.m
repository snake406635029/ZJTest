//
//  main.m
//  Test
//
//  Created by 张健 on 16/5/24.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskManager.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
//        NSString *sql = [NSString stringWithFormat:@"select * from ejiayou_user"];
//        NSArray *result = [DBManager sqlQuery:sql];
//        NSLog(@"%@",result);
        
        DLog(@"任务开启:");
        [TaskManager taskForAuthToken];
        [TaskManager taskForAppBaseInfos];
        
        return 0;
        
    }
    return 0;
}
