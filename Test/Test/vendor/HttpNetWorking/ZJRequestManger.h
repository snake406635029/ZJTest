//
//  ZJRequestManger.h
//  Erefuel
//
//  Created by iusky on 16/5/4.
//  Copyright © 2016年 PersonalSystem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"

@interface ZJRequestManger : NSObject

+ (void)POST:(NSString *)URL params:(NSDictionary * )params success:(void (^)(id response))success
     failure:(void (^)(AFHTTPRequestOperation *operation,NSError *error))Error;


+ (void)GET:(NSString *)URL
    success:(void (^)(id response))success
    failure:(void (^)(AFHTTPRequestOperation *operation,NSError *error))Error;


//同步请求数据,返回字典类型
+ (NSDictionary *)SynPost:(NSString *)URL params:(NSDictionary * )params;
+ (id)SynGet:(NSString *)URL params:(NSDictionary * )params;

//同步获取图片后进行返回数据
+ (NSData *)downloadWithImageUrl:(NSString *)imageUrl;

//方便将json转成字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString withSourceCode:(NSString *)code;

// 将字典转化成 json字符串
+ (NSString *) jsonStringFromDictionary : (NSDictionary *)dict;

// 将oc对象转成字典
+ (NSDictionary *) entityToDictionary : (id) entity;

@end
