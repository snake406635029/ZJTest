//
//  NSDate+ZJDate.m
//  Test
//
//  Created by 张健 on 2017/3/1.
//  Copyright © 2017年 ZJ. All rights reserved.
//

#import "NSDate+ZJDate.h"

@implementation NSDate (ZJDate)

+(NSString *)todayDateString{

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [format stringFromDate:[NSDate date]];
    return dateString;
}

+(NSString *)yesterdayDateString{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [format stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-(24*60*60)]];
    return dateString;
}


+(NSString *)todayWeekString{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"EEEE";
    NSString *week = [format stringFromDate:[NSDate date]];
    return week;
}

+(NSString *)yesterdayWeekString{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"EEEE";
    NSString *week = [format stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-(24*60*60)]];
    return week;
}

@end
