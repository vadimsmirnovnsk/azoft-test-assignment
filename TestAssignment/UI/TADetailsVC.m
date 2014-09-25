//
//  TADetailsVC.m
//  TestAssignment
//
//  Created by Vadim Smirnov on 25/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "TADetailsVC.h"
#import "TAVehicle.h"


#pragma mark - TADetailsVC Implementation

// Abstract class
@implementation TADetailsVC

+ (id) detailVCWithVehicleType:(NSString *)vehicleType
{
    if ([vehicleType isEqualToString:kVehicleTypeCar]) {
        return [[[TACarVC alloc] init] autorelease];
    }
    else if ([vehicleType isEqualToString:kVehicleTypeBike]) {
        return [[[TABikeVC alloc] init] autorelease];
    }
    else if ([vehicleType isEqualToString:kVehicleTypeTruck]) {
        return[[[TATruckVC alloc] init] autorelease];
    }
    else return [[[TACarVC alloc] init] autorelease];
}

- (void)textFieldWillEndEditing:(UITextField *)textField
{
    NSLog(@"Abstract method isn't implemented in child-class.");
}

@end


#pragma mark - TACarVC Extension

@interface TACarVC ()

@property (nonatomic, unsafe_unretained) IBOutlet UITextField *handDriveField;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *seatsCountField;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *doorsField;

@end


#pragma mark - TACarVC Implementation

@implementation TACarVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.handDriveField.placeholder = self.vehicle[kHandDriveKey];
    self.handDriveField.delegate = self.textFieldDelegate;
    
    self.seatsCountField.placeholder = [self.vehicle[kSeatsCountKey] stringValue];
    self.seatsCountField.delegate = self.textFieldDelegate;
    
    self.doorsField.placeholder = [self.vehicle[kDoorsKey] stringValue];
    self.doorsField.delegate = self.textFieldDelegate;
}

- (void)textFieldWillEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.handDriveField]) {
        self.editedVehicle[kHandDriveKey] = self.handDriveField.text;
    }
    else if ([textField isEqual:self.seatsCountField]) {
        if ([self.seatsCountField.text integerValue]) {
            self.editedVehicle[kSeatsCountKey] = @([self.seatsCountField.text integerValue]);
        }
    }
    else if ([textField isEqual:self.doorsField]) {
        if ([self.doorsField.text integerValue]) {
            self.editedVehicle[kDoorsKey] = @([self.doorsField.text integerValue]);
        }
    }
}

@end


#pragma mark - TABikeVC Extension

@interface TABikeVC ()

@property (nonatomic, unsafe_unretained) IBOutlet UITextField *bikeTypeField;

@end


#pragma mark - TABikeVC Implementation

@implementation TABikeVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.bikeTypeField.placeholder = self.vehicle[kBikeTypeKey];
    self.bikeTypeField.delegate = self.textFieldDelegate;
}

- (void)textFieldWillEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.bikeTypeField]) {
        self.editedVehicle[kBikeTypeKey] = self.bikeTypeField.text;
    }
}

@end


#pragma mark - TATruckVC Extansion

@interface TATruckVC ()

@property (nonatomic, unsafe_unretained) IBOutlet UITextField *handDriveField;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *seatsCountField;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *carryingCapacityKgField;

@end


#pragma mark - TATruckVC Implementation

@implementation TATruckVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.handDriveField.placeholder = self.vehicle[kHandDriveKey];
    self.handDriveField.delegate = self.textFieldDelegate;
    
    self.seatsCountField.placeholder = [self.vehicle[kSeatsCountKey] stringValue];
    self.seatsCountField.delegate = self.textFieldDelegate;
    
    self.carryingCapacityKgField.placeholder = [self.vehicle[kCarryingCapacityKgKey] stringValue];
    self.carryingCapacityKgField.delegate = self.textFieldDelegate;
}

- (void)textFieldWillEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.handDriveField]) {
        self.editedVehicle[kHandDriveKey] = self.handDriveField.text;
    }
    else if ([textField isEqual:self.seatsCountField]) {
        if ([self.seatsCountField.text integerValue]) {
            self.editedVehicle[kSeatsCountKey] = @([self.seatsCountField.text integerValue]);
        }
    }
    else if ([textField isEqual:self.carryingCapacityKgField]) {
        if ([self.carryingCapacityKgField.text integerValue]) {
            self.editedVehicle[kCarryingCapacityKgKey] =
                @([self.carryingCapacityKgField.text integerValue]);
        }
    }
}

@end
