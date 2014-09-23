//
//  TAServerAPIController.m
//  TestAssignment
//
//  Created by Vadim Smirnov on 23/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "TAServerAPIController.h"
#import <AFNetworking/AFNetworking.h>

static NSString *const kBaseAPIURL = @"http://azcltd.com/testTask/iOS/";

@interface TAServerAPIController ()
@property (strong, nonatomic) AFHTTPRequestOperationManager *requestManager;
@end

@implementation TAServerAPIController

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *apiURL = [NSURL URLWithString:kBaseAPIURL];
        self.requestManager = [[[AFHTTPRequestOperationManager alloc]
            initWithBaseURL:apiURL] autorelease];
        self.requestManager.responseSerializer.acceptableContentTypes =
            [NSSet setWithObject:@"text/plain"];
    }
    return self;
}

+ (instancetype)sharedController
{
    static __strong TAServerAPIController *instance;
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
       instance = [[self alloc]init];
    });
    return instance;
}

- (void)getJSONWithSuccessBlock:(void(^)(NSDictionary *))success
    failureBlock:(void(^)(NSError *))failure
{
    NSString *requestString = @"list.json";
    [self.requestManager
        GET:requestString
        parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(responseObject);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];

}

- (void)dealloc
{
    [_requestManager release];
    _requestManager = nil;
    [super dealloc];
}

@end
