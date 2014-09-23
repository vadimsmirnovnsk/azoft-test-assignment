//
//  TAPreferences.m
//  TestAssignment
//
//  Created by Vadim Smirnov on 23/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "TAPreferences.h"

static NSString *const kIsDownloadedKey = @"isDownloaded";


#pragma mark - Preferences Extansion

@interface TAPreferences ()

- (void)registerUserDefaultsFromSettingsBundle;

@end


#pragma mark Preferences Implementation

@implementation TAPreferences

#pragma mark Inits and Create Methods
+ (instancetype)standardPreferences
{
    static dispatch_once_t onceToken = 0;
    static __strong TAPreferences *standardPreferences = nil;
    dispatch_once(&onceToken, ^{
        standardPreferences = [[self alloc] init];
    });
    return standardPreferences;
}

- (id)init
{
    if ((self = [super init])) {
        [self registerUserDefaultsFromSettingsBundle];
    }
    return self;
}

#pragma mark Getters
- (BOOL)isDownloaded
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsDownloadedKey];
}

- (NSArray *)vehicles
{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:kVehiclesKey];
}

#pragma mark Setters
- (void)setDownloaded:(BOOL)downloaded
{
    [[NSUserDefaults standardUserDefaults] setBool:downloaded forKey:kIsDownloadedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)setVehicles:(NSArray *)vehicles
{
    [[NSUserDefaults standardUserDefaults] setObject:vehicles forKey:kVehiclesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark Registering settings bundle
- (void)registerUserDefaultsFromSettingsBundle
{
    NSString *const settingsBundlePath =
        [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];

    NSMutableDictionary *const defaultsToRegister = [NSMutableDictionary dictionary];
    if (settingsBundlePath) {
        NSString *const rootPlistPath =
            [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        NSDictionary *const preferences =
            [NSDictionary dictionaryWithContentsOfFile:rootPlistPath];
        NSArray *const preferenceSpecifiers =
            [preferences objectForKey:@"PreferenceSpecifiers"];
        for (NSDictionary *specifier in preferenceSpecifiers) {
            NSString *const key = [specifier objectForKey:@"Key"];
            if (key) {
                [defaultsToRegister setValue:[specifier objectForKey:@"DefaultValue"]
                    forKey:key];
            }
        }
    }
    [defaultsToRegister setValue:@(NO) forKey:kIsDownloadedKey];
    [defaultsToRegister setObject:@[] forKey:kVehiclesKey];

    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
