//
//  CCHTTPClient.h
//  CleanCar
//
//  Created by MichaelDu on 14-3-14.
//
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HTTPClient :AFHTTPClient

+ (HTTPClient *)sharedInstance;

@end
