//
//  TAVehicle.h
//  TestAssignment
//
//  Created by Vadim Smirnov on 22/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TACar;
@class TABike;
@class TATruck;


#pragma mark - TAVehicle Interface

@interface TAVehicle : NSObject

@property (nonatomic, copy) NSString *manufacturer;
@property (nonatomic, copy) NSString *model;
@property (nonatomic, copy) NSNumber */* with NSUInteger */horsePower;
@property (nonatomic, readonly) NSArray */* with NSStrings */images;

+ (TACar *)carWithManufacturer:(NSString *)manufacturer model:(NSString *)model
    horsePower:(NSNumber *)horsePower images:(NSArray *)imagesNames
    handDrive:(NSString *)handDrive seatsCount:(NSNumber *)seatsCount
    doors:(NSNumber *)doors;

+ (TATruck *)truckWithManufacturer:(NSString *)manufacturer model:(NSString *)model
    horsePower:(NSNumber *)horsePower images:(NSArray *)imagesNames
    handDrive:(NSString *)handDrive seatsCount:(NSNumber *)seatsCount
    carryingCapacityKg:(NSNumber *)carryingCapacityKg;

+ (TABike *)bikeWithManufacturer:(NSString *)manufacturer model:(NSString *)model
    horsePower:(NSNumber *)horsePower images:(NSArray *)imagesNames
    bikeType:(NSString *)bikeType;

@end


#pragma mark - TAAuto Interface

@interface TAAuto : TAVehicle

@property (nonatomic, copy) NSString *handDrive;
@property (nonatomic, strong) NSNumber */* with NSUInteger */seatsCount;

@end


#pragma mark - TACar Interface

@interface TACar : TAAuto

@property (nonatomic, strong) NSNumber */* with NSUInteger */doors;

@end


#pragma mark - TATruck Interface

@interface TATruck : TAAuto

@property (nonatomic, strong) NSNumber */* with NSUInteger */carryingCapacityKg;

@end


#pragma mark - TABike Interface

@interface TABike : TAVehicle

@property (nonatomic, copy) NSString *bikeType;

@end
