//
//  TAVehicle.h
//  TestAssignment
//
//  Created by Vadim Smirnov on 22/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import <Foundation/Foundation.h>


// Vehicle Types
static NSString *const kVehicleTypeCar = @"car";
static NSString *const kVehicleTypeTruck = @"truck";
static NSString *const kVehicleTypeBike = @"bike";


// Vehicle Common Keys
static NSString *const kVehicleTypeKey = @"type";
static NSString *const kManufacturerKey = @"manufacturer";
static NSString *const kModelKey = @"model";
static NSString *const kHorsePowerKey = @"horsePower";
static NSString *const kImagesKey = @"images";

// Auto Common Keys
static NSString *const kHandDriveKey = @"handDrive";
static NSString *const kSeatsCountKey = @"seatsCount";

// Car Keys
static NSString *const kDoorsKey = @"doors";

// Truck Keys
static NSString *const kCarryingCapacityKgKey = @"carryingCapacityKg";

// Bike Keys
static NSString *const kBikeTypeKey = @"bikeType";

typedef NS_ENUM(NSUInteger, VehicleType) {
    VehicleTypeCars = 0,
    VehicleTypeBikes = 1,
    VehicleTypeTrucks = 2,
};


@class TACar;
@class TABike;
@class TATruck;


#pragma mark - TAVehicle Interface

@interface TAVehicle : NSObject

@property (nonatomic, copy) NSString *manufacturer;
@property (nonatomic, copy) NSString *model;
@property (nonatomic, copy) NSNumber */* with NSUInteger */horsePower;
@property (nonatomic, readonly) NSArray */* with NSStrings */images;
@property (nonatomic, copy) NSString *type;

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

+ (id)vehicleWithParameters:(NSDictionary *)parameters;

@end


#pragma mark - TAAuto Interface

@interface TAAuto : TAVehicle

@property (nonatomic, copy) NSString *handDrive;
@property (nonatomic, strong) NSNumber */* with NSUInteger */seatsCount;

@end


#pragma mark - TACar Interface

@interface TACar : TAAuto <NSCopying>

@property (nonatomic, strong) NSNumber */* with NSUInteger */doors;

@end


#pragma mark - TATruck Interface

@interface TATruck : TAAuto <NSCopying>

@property (nonatomic, strong) NSNumber */* with NSUInteger */carryingCapacityKg;

@end


#pragma mark - TABike Interface

@interface TABike : TAVehicle <NSCopying>

@property (nonatomic, copy) NSString *bikeType;

@end
