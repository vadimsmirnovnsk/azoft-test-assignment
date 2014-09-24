//
//  TADetailsVC.h
//  TestAssignment
//
//  Created by Vadim Smirnov on 25/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TADetailsVC : UIViewController

@property (nonatomic, unsafe_unretained) id vehicle;
@property (nonatomic, unsafe_unretained) id<UITextFieldDelegate> textFieldDelegate;

@end


@interface TACarVC : TADetailsVC

@end


@interface TABikeVC : TADetailsVC

@end


@interface TATruckVC : TADetailsVC

@end
