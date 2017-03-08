//
//  ZJRequestManger.m
//  Erefuel
//
//  Created by iusky on 16/5/4.
//  Copyright © 2016年 PersonalSystem. All rights reserved.
//

#import "ZJRequestManger.h"
#import <objc/runtime.h>

@implementation ZJRequestManger

+ (void)POST:(NSString *)URL params:(NSDictionary * )params success:(void (^)(id response))success
     failure:(void (^)(AFHTTPRequestOperation *operation,NSError *error))Error
{
    // 创建请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //将返回中非json数据直接过滤掉
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 请求超时时间
    
    manager.requestSerializer.timeoutInterval = 15;
    
    NSString *postStr = URL;
    
    
    NSMutableDictionary *dict;
    if (params != nil) {
        dict = [params mutableCopy];
    }else{
        dict = [NSMutableDictionary dictionary];
    }
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"Auth_Token"] forKey:@"auth_token"];
    
    [manager POST:postStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 请求成功
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseDict = (NSDictionary *)responseObject;
            if ([[responseDict objectForKey:@"code"] integerValue] == 200 ) {
                
                success(responseDict);
                
            }else{
                NSError *error = [NSError errorWithDomain:@"连接服务成功，业务处理异常." code:[[responseDict objectForKey:@"code"] integerValue] userInfo:nil];
                Error( operation,error);
            }
        }else {
            NSLog(@"服务端所传参数格式不正确");
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {// 请求失败
        Error( operation,error);
        
    }];
}


+ (void)GET:(NSString *)URL
    success:(void (^)(id response))success
    failure:(void (^)(AFHTTPRequestOperation *operation,NSError *error))Error
{
    // 获得请求管理者
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setHTTPShouldHandleCookies:NO];
    manager.requestSerializer.timeoutInterval = 15;

    NSString *getStr = URL;
    
    // 发送GET请求
    [manager GET:getStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"getStr------------%@",getStr);
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        
        success(responseDict);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (!operation.responseObject) {
            NSLog(@"网络错误");
        }
        Error( operation,error);
    }];
    
}


+ (NSData *)downloadWithImageUrl:(NSString *)imageUrl
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:3.0];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    [operation start];
    [operation waitUntilFinished];
    
    return operation.responseData;
}

+ (id)SynGet:(NSString *)URL params:(NSDictionary * )params
{
    NSString *urlStr = URL;
    
    NSMutableDictionary *dict;
    if (params != nil) {
        dict = [params mutableCopy];
    }else{
        dict = [NSMutableDictionary dictionary];
    }
    
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"Auth_Token"] forKey:@"auth_token"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 5.0;
    id result = [manager syncGET:urlStr parameters:dict operation:NULL error:nil];
    
    //NSLog(@"%@",result);
    return result;
}

+ (NSDictionary *)SynPost:(NSString *)URL params:(NSDictionary * )params
{
    NSString *urlStr = URL;
    
    NSMutableDictionary *dict;
    if (params != nil) {
        dict = [params mutableCopy];
    }else{
        dict = [NSMutableDictionary dictionary];
    }
    
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"Auth_Token"] forKey:@"auth_token"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 5.0;
    NSDictionary *result = [manager syncPOST:urlStr parameters:dict operation:NULL error:nil];
    
    //NSLog(@"%@",result);
    return result;
}


/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString withSourceCode:(NSString *)code{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableLeaves
                                                          error:&err];
    
    
    return dic;
}


// 将字典转化成 json字符串
+ (NSString *) jsonStringFromDictionary : (NSDictionary *)dict
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jsonString;
}

// 将oc对象转成字典
+ (NSDictionary *) entityToDictionary : (id) entity
{
    Class clazz = [entity class];
    u_int count;
    
    objc_property_t *properties = class_copyPropertyList(clazz, &count);
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        objc_property_t prop = properties[i];
        const char* propertyName = property_getName(prop);
        
        [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        
        id value = [entity performSelector: NSSelectorFromString([NSString stringWithUTF8String:propertyName] ) ];
        if (value == nil) {
            [valueArray addObject:[NSNull null]];
        }else {
            [valueArray addObject:value];
        }
    }
    
    free(properties);
    
    NSDictionary *returnDict = [NSDictionary dictionaryWithObjects:valueArray forKeys:propertyArray];
    return returnDict;
}


@end
