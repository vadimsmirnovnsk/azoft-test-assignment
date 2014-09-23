//
//  TAServerAPIController.h
//  TestAssignment
//
//  Created by Vadim Smirnov on 23/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAServerAPIController : NSObject

+ (instancetype)sharedController;

- (void)getJSONWithSuccessBlock:(void(^)(NSDictionary *))success
    failureBlock:(void(^)(NSError *))failure;

@end
