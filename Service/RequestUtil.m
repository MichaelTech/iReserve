//
//  RequestUtil.m
//  CleanCar
//
//  Created by MichaelDu on 14-3-14.
//
//

#import "RequestUtil.h"

//#define successCode 1

@implementation RequestUtil

+ (void)reserveSuccess:(RequestSuccess)success failure:(RequestFailure)failure
{
    [[HTTPClient sharedInstance] getPath:@"/HK/zh_HK/reserve/iPhone/availability.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dic = (NSDictionary *)responseObject;
         success(dic);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"userRember error:%@",error);
         failure(error);
     }];
}

@end
