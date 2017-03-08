//
//  NSDate+ZJDate.h
//  Test
//
//  Created by 张健 on 2017/3/1.
//  Copyright © 2017年 ZJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZJDate)

//2017-03-01
+(NSString *)todayDateString;

//2017-03-01
+(NSString *)yesterdayDateString;

//星期三
+(NSString *)todayWeekString;

//星期三
+(NSString *)yesterdayWeekString;


@end
