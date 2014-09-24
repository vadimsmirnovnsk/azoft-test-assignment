//
//  TADetailsVC.m
//  TestAssignment
//
//  Created by Vadim Smirnov on 25/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "TADetailsVC.h"
#import "TAVehicle.h"


@interface TADetailsVC ()
@end

@implementation TADetailsVC
@end


@interface TACarVC ()

@property (nonatomic, unsafe_unretained) IBOutlet UITextField *handDriveField;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *seatsCountField;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *doorsField;

@end

@implementation TACarVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.handDriveField.placeholder = self.vehicle[kHandDriveKey];
    self.seatsCountField.placeholder = [self.vehicle[kSeatsCountKey] stringValue];
    self.doorsField.placeholder = [self.vehicle[kDoorsKey] stringValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
}

@end


@interface TABikeVC ()

@property (nonatomic, unsafe_unretained) IBOutlet UITextField *bikeTypeField;

@end


@implementation TABikeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.bikeTypeField.placeholder = self.vehicle[kBikeTypeKey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
}

@end


@interface TATruckVC ()

@property (nonatomic, unsafe_unretained) IBOutlet UITextField *handDriveField;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *seatsCountField;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *carryingCapacityKgField;

@end


@implementation TATruckVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.handDriveField.placeholder = self.vehicle[kHandDriveKey];
    self.seatsCountField.placeholder = [self.vehicle[kSeatsCountKey] stringValue];
    self.carryingCapacityKgField.placeholder = [self.vehicle[kCarryingCapacityKgKey] stringValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
}

@end
