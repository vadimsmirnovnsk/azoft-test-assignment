//
//  TADetailsVC.h
//  TestAssignment
//
//  Created by Vadim Smirnov on 25/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark - TADetailsVC Interface

// Abstrac Class
@interface TADetailsVC : UIViewController

@property (nonatomic, unsafe_unretained) id vehicle;
@property (nonatomic, unsafe_unretained) id editedVehicle;
@property (nonatomic, unsafe_unretained) id<UITextFieldDelegate> textFieldDelegate;

+ (id) detailVCWithVehicleType:(NSString *)vehicleType;
- (void)textFieldWillEndEditing:(UITextField *)textField;

@end


#pragma mark - TACarVC Interface

@interface TACarVC : TADetailsVC

@end


#pragma mark - TABikeVC Interface

@interface TABikeVC : TADetailsVC

@end


#pragma mark - TATruckVC Interface

@interface TATruckVC : TADetailsVC

@end
