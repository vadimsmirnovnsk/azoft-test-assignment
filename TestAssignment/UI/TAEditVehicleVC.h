//
//  TAEditVehicleVC.h
//  TestAssignment
//
//  Created by Vadim Smirnov on 24/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TAEditVehicleVC;
@protocol TAEditVehicleVCDelegate <NSObject>

- (void) editVehicleVC:(TAEditVehicleVC *)sender didFinishedWithVehicle:(id)vehicle
    indexPath:(NSIndexPath *)indexPath;

@end


@interface TAEditVehicleVC : UIViewController

@property (nonatomic, unsafe_unretained) id<TAEditVehicleVCDelegate> delegate;

- (instancetype)initWithVehicle:(id)vehicle indexPath:(NSIndexPath *)indexPath;

@end
