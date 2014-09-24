//
//  TAEditVehicleVC.m
//  TestAssignment
//
//  Created by Vadim Smirnov on 24/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "TAEditVehicleVC.h"
#import "TAVehicle.h"
#import "TADetailsVC.h"


static CGRect const kDetailsViewFrame = (CGRect){0.f, 212.f, 320.f, 394.f};


@interface TAEditVehicleVC ()

@property (nonatomic, strong) id vehicle;
@property (nonatomic, strong) TADetailsVC *detailsVC;

@end


@implementation TAEditVehicleVC

- (instancetype)initWithVehicle:(id)vehicle
{
    if (self = [super init]) {
        _vehicle = vehicle;
    };
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _vehicle = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!!self.navigationItem) {
        UIBarButtonItem *const cancelBarButtonItem =
            [[[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                     target:self
                                     action:@selector(didTouchCancelBarButtonItem:)] autorelease];
        [self.navigationItem setLeftBarButtonItem:cancelBarButtonItem];

        UIBarButtonItem *const saveBarButtonItem =
            [[[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                     target:self
                                     action:@selector(didTouchSaveBarButtonItem:)] autorelease];
        [self.navigationItem setRightBarButtonItem:saveBarButtonItem];
    }
    if ([self.vehicle[kVehicleTypeKey] isEqualToString:kVehicleTypeCar]) {
        _detailsVC = [[[TACarVC alloc] init] autorelease];
    }
    else if ([self.vehicle[kVehicleTypeKey] isEqualToString:kVehicleTypeBike]) {
        _detailsVC = [[[TABikeVC alloc] init] autorelease];
    }
    else if ([self.vehicle[kVehicleTypeKey] isEqualToString:kVehicleTypeTruck]) {
        _detailsVC = [[[TATruckVC alloc] init] autorelease];
    }
    _detailsVC.vehicle = self.vehicle;
    _detailsVC.view.frame = kDetailsViewFrame;
    [self.view addSubview:_detailsVC.view];
    [self addChildViewController:_detailsVC];
    [_detailsVC didMoveToParentViewController:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.manufacturerField.placeholder = self.vehicle[kManufacturerKey];
    self.modelField.placeholder = self.vehicle[kModelKey];
    self.horsePowerField.placeholder = [self.vehicle[kHorsePowerKey] stringValue];
}

#pragma mark - Actions

- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender
{
    [self.delegate editVehicleVC:self didFinishedWithVehicle:self.vehicle];
}

- (void)didTouchSaveBarButtonItem:(UIBarButtonItem *)sender
{
}


#pragma MRR
- (void)dealloc
{
    [_vehicle release];
    _vehicle = nil;
    [super dealloc];
}

@end
