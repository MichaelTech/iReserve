//
//  CCHTTPClient.m
//  CleanCar
//
//  Created by MichaelDu on 14-3-14.
//
//

#import "HTTPClient.h"

@implementation HTTPClient

+ (HTTPClient *)sharedInstance {
    static HTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://reserve.cdn-apple.com/"]];
    });
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self setParameterEncoding:AFJSONParameterEncoding];
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    return self;
}

@end
