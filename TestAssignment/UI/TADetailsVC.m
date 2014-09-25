//
//  TADetailsVC.m
//  TestAssignment
//
//  Created by Vadim Smirnov on 25/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "TADetailsVC.h"
#import "TAVehicle.h"


@implementation TADetailsVC

- (void)textFieldWillEndEditing:(UITextField *)textField
{
    NSLog(@"Abstract methode isn't implemented in child-class.");
}

@end


@interface TACarVC ()

@property (nonatomic, unsafe_unretained) IBOutlet UITextField *handDriveField;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *seatsCountField;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *doorsField;

@end


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


@interface TABikeVC ()

@property (nonatomic, unsafe_unretained) IBOutlet UITextField *bikeTypeField;

@end


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


@interface TATruckVC ()

@property (nonatomic, unsafe_unretained) IBOutlet UITextField *handDriveField;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *seatsCountField;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *carryingCapacityKgField;

@end


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
