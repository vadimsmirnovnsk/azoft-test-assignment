//
//  TAVehiclesVC.h
//  TestAssignment
//
//  Created by Vadim Smirnov on 23/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAVehiclesVC : UIViewController

@property (nonatomic, unsafe_unretained) IBOutlet UITableView *tableView;

- (IBAction)didTouchAddBarButtonItem:(UIBarButtonItem *)sender;
- (IBAction)didTouchOptionsBarButtonItem:(UIBarButtonItem *)sender;

@end
