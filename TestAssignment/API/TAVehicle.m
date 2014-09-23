//
//  TAVehicle.m
//  TestAssignment
//
//  Created by Vadim Smirnov on 22/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "TAVehicle.h"


#pragma mark - TAVehicle Extension

@interface TAVehicle ()

@property (nonatomic, copy) NSMutableArray */* with NSStrings */mutableImages;

- (instancetype)initWithManufacturer:(NSString *)manufacturer model:(NSString *)model
    horsePower:(NSNumber *)horsePower images:(NSArray *)imagesNames;

@end


#pragma mark - TAAuto Extension

@interface TAAuto ()

- (instancetype)initWithManufacturer:(NSString *)manufacturer model:(NSString *)model
    horsePower:(NSNumber *)horsePower images:(NSArray *)imagesNames
    handDrive:(NSString *)handDrive seatsCount:(NSNumber */* with NSUInteger */)seatsCount;

@end


#pragma mark - TABike Implementation

@implementation TABike

// Designated initializer
- (instancetype)initWithManufacturer:(NSString *)manufacturer model:(NSString *)model
    horsePower:(NSNumber *)horsePower images:(NSArray *)imagesNames
    bikeType:(NSString *)bikeType
{
    self = [super initWithManufacturer:manufacturer model:model horsePower:horsePower images:imagesNames];
    if (self) {
        _bikeType = [bikeType copy];
    }
    return self;
}

- (instancetype)init
{
    NSLog(@"Please use designated initializer:\n"
        "- initWithManufacturer:(NSString *)manufacturer model:(NSString *)model "
        "horsePower:(NSString *)horsePower images:(NSArray *)imagesNames "
        "bikeType:(NSString *)bikeType");
    return nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ \"%@\"\nhorsePower: %@\nbikeType: %@\nimages: %@",
        self.manufacturer, self.model, self.horsePower, self.bikeType, self.images];
}

- (void)dealloc
{
    [_bikeType release];
    _bikeType = nil;
    [super dealloc];
}

@end


#pragma mark - TATruck Implementation

@implementation TATruck

// Designated initializer
- (instancetype)initWithManufacturer:(NSString *)manufacturer model:(NSString *)model
    horsePower:(NSNumber *)horsePower images:(NSArray *)imagesNames
    handDrive:(NSString *)handDrive seatsCount:(NSNumber *)seatsCount
    carryingCapacityKg:(NSNumber */* with NSUInteger */)carryingCapacityKg
{
    self = [super initWithManufacturer:manufacturer model:model horsePower:horsePower images:imagesNames handDrive:handDrive seatsCount:seatsCount];
    if (self) {
        _carryingCapacityKg = [carryingCapacityKg copy];
    }
    return self;
}

- (instancetype)init
{
    NSLog(@"Please use designated initializer:\n"
        "- initWithManufacturer:(NSString *)manufacturer model:(NSString *)model "
        "horsePower:(NSString *)horsePower images:(NSArray *)imagesNames "
        "handDrive:(NSString *)handDrive seatsCount:(NSNumber */* with NSUInteger */)seatsCount "
        "carryingCapacityKg:(NSNumber *)carryingCapacityKg");
    return nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ \"%@\"\nhorsePower: %@\nhandDrive: %@\nseatsCount: %@\n"
        "carryingCapacityKg: %@\nimages:%@",
        self.manufacturer, self.model, self.horsePower, self.handDrive, self.seatsCount,
        self.carryingCapacityKg, self.images];
}

- (void)dealloc
{
    [_carryingCapacityKg release];
    _carryingCapacityKg = nil;
    [super dealloc];
}

@end


#pragma mark - TACar Implementation

@implementation TACar

// Designated initializer
- (instancetype)initWithManufacturer:(NSString *)manufacturer model:(NSString *)model
    horsePower:(NSNumber *)horsePower images:(NSArray *)imagesNames
    handDrive:(NSString *)handDrive seatsCount:(NSNumber *)seatsCount
    doors:(NSNumber *)doors
{
    self = [super initWithManufacturer:manufacturer model:model horsePower:horsePower images:imagesNames handDrive:handDrive seatsCount:seatsCount];
    if (self) {
        _doors = [doors copy];
    }
    return self;
}

- (instancetype)init
{
    NSLog(@"Please use designated initializer:\n"
        "- initWithManufacturer:(NSString *)manufacturer model:(NSString *)model "
        "horsePower:(NSString *)horsePower images:(NSArray *)imagesNames "
        "handDrive:(NSString *)handDrive seatsCount:(NSNumber */* with NSUInteger */)seatsCount "
        "doors:(NSNumber *)doors");
    return nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ \"%@\"\nhorsePower: %@\nhandDrive: %@\nseatsCount: %@\n"
        "doors: %@\nimages:%@",
        self.manufacturer, self.model, self.horsePower, self.handDrive, self.seatsCount,
        self.doors, self.images];
}

- (void)dealloc
{
    [_doors release];
    _doors = nil;
    [super dealloc];
}

@end


#pragma mark - TAAuto Implementation

@implementation TAAuto

// Designated initializer
- (instancetype)initWithManufacturer:(NSString *)manufacturer model:(NSString *)model
    horsePower:(NSNumber *)horsePower images:(NSArray *)imagesNames
    handDrive:(NSString *)handDrive seatsCount:(NSNumber */* with NSUInteger */)seatsCount
{
    self = [super initWithManufacturer:manufacturer model:model
        horsePower:horsePower images:imagesNames];
    if (self) {
        _handDrive = [handDrive copy];
        _seatsCount = [seatsCount copy];
    }
    return self;
}

- (instancetype)init
{
    NSLog(@"Please use designated initializer:\n"
        "- initWithManufacturer:(NSString *)manufacturer model:(NSString *)model"
        "horsePower:(NSString *)horsePower images:(NSArray *)imagesNames"
        "handDrive:(NSString *)handDrive seatsCount:(NSNumber */* with NSUInteger */)seatsCount");
    return nil;
}

- (void)dealloc
{
    [_handDrive release];
    _handDrive = nil;
    [_seatsCount release];
    _seatsCount = nil;
    [super dealloc];
}

@end


#pragma mark - TAVehicle Implementation

@implementation TAVehicle

#pragma mark Init and Create methods
+ (TACar *)carWithManufacturer:(NSString *)manufacturer model:(NSString *)model
    horsePower:(NSNumber *)horsePower images:(NSArray *)imagesNames
    handDrive:(NSString *)handDrive seatsCount:(NSNumber *)seatsCount
    doors:(NSNumber *)doors
{
    return [[[TACar alloc]initWithManufacturer:manufacturer model:model horsePower:horsePower
        images:imagesNames handDrive:handDrive seatsCount:seatsCount
        doors:doors] autorelease];
}

+ (TATruck *)truckWithManufacturer:(NSString *)manufacturer model:(NSString *)model
    horsePower:(NSNumber *)horsePower images:(NSArray *)imagesNames
    handDrive:(NSString *)handDrive seatsCount:(NSNumber *)seatsCount
    carryingCapacityKg:(NSNumber *)carryingCapacityKg
{
    return [[[TATruck alloc]initWithManufacturer:manufacturer model:model horsePower:horsePower
        images:imagesNames handDrive:handDrive seatsCount:seatsCount
        carryingCapacityKg:carryingCapacityKg] autorelease];
}

+ (TABike *)bikeWithManufacturer:(NSString *)manufacturer model:(NSString *)model
    horsePower:(NSNumber *)horsePower images:(NSArray *)imagesNames
    bikeType:(NSString *)biketype
{
    return [[[TABike alloc]initWithManufacturer:manufacturer model:model horsePower:horsePower
        images:imagesNames bikeType:biketype] autorelease];
}

// Designated initializer
- (instancetype)initWithManufacturer:(NSString *)manufacturer model:(NSString *)model
    horsePower:(NSNumber *)horsePower images:(NSArray *)imagesNames
{
    self = [super init];
    if (self) {
        _manufacturer = [manufacturer copy];
        _model = [model copy];
        _horsePower = [horsePower copy];
        _mutableImages = [imagesNames mutableCopy];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithManufacturer:@"Unknown manufacturer" model:@"Unknown model"
            horsePower:@(0) images:nil];
}

#pragma mark Getters
- (NSArray *)images
{
    return [[self.mutableImages copy] autorelease];
}

- (void)dealloc
{
    [_manufacturer release];
    _manufacturer = nil;
    [_model release];
    _model = nil;
    [_horsePower release];
    _horsePower = nil;
    [super dealloc];
}

@end
