//
//  TAPreferences.h
//  TestAssignment
//
//  Created by Vadim Smirnov on 23/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kVehiclesKey = @"vehicles";


#pragma mark - Preferences Interface

@interface TAPreferences : NSObject

@property (nonatomic, readwrite, getter = isDownloaded) BOOL downloaded;
@property (nonatomic, unsafe_unretained, readwrite) NSArray /* of NSDictionary's */ *vehicles;

+ (instancetype)standardPreferences;

@end
