//
//  RequestUtil.h
//  CleanCar
//
//  Created by MichaelDu on 14-3-14.
//
//

#import <Foundation/Foundation.h>
#import "HTTPClient.h"

#define TextHave @"  有"
#define TextNotHave @"  无"

typedef void (^RequestSuccess)(id);
typedef void (^RequestFailure)(id errorInfo);

@interface RequestUtil : NSObject
+ (void)reserveSuccess:(RequestSuccess)success failure:(RequestFailure)failure;
@end
