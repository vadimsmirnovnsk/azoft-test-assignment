//
//  TAVehiclesVC.m
//  TestAssignment
//
//  Created by Vadim Smirnov on 23/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "TAVehiclesVC.h"
#import "TAVehicle.h"
#import "TAServerAPIController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "TAPreferences.h"
#import "TAEditVehicleVC.h"


static NSString *const userCellId = @"UserCellId";
static NSString *const kSectionTitleCars = @"Cars";
static NSString *const kSectionTitleBikes = @"Bikes";
static NSString *const kSectionTitleTrucks = @"Trucks";

typedef NS_ENUM(NSUInteger, SectionType) {
    SectionTypeCars = 0,
    SectionTypeBikes = 1,
    SectionTypeTrucks = 2,
};


#pragma mark - TAVehiclesVC Extension

@interface TAVehiclesVC () <UITableViewDataSource, UITableViewDelegate, TAEditVehicleVCDelegate>

@property (nonatomic, copy) NSMutableArray *mutableVehicles;
@property (nonatomic, copy) NSMutableArray *mutableCars;
@property (nonatomic, copy) NSMutableArray *mutableTrucks;
@property (nonatomic, copy) NSMutableArray *mutableBikes;

- (void)loadVehicles;
- (void)sortVehicles;

@end


#pragma mark - TAVehiclesVC Implementation

@implementation TAVehiclesVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _mutableBikes = [@[] mutableCopy];
        _mutableCars = [@[] mutableCopy];
        _mutableTrucks = [@[] mutableCopy];
        _mutableVehicles = [@[] mutableCopy];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadVehicles];
}

#pragma mark Inner Methods
- (void)loadVehicles
{
    if (![[TAPreferences standardPreferences]isDownloaded]) {
        // Add gray view
        UIView *grayView = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
        grayView.backgroundColor = [UIColor darkGrayColor];
        grayView.alpha = 0.5f;
        UILabel *loadingLabel = [[[UILabel alloc] initWithFrame:(CGRect){
            0,
            [UIScreen mainScreen].bounds.size.height / 2,
            320,
            30
        }] autorelease];
        loadingLabel.text = @"Loading...";
        loadingLabel.textColor = [UIColor whiteColor];
        loadingLabel.textAlignment = NSTextAlignmentCenter;
        [grayView addSubview:loadingLabel];
        [self.view addSubview:grayView];
        // Get json from server
        __unsafe_unretained typeof(self) blockSelf = self;
        [[TAServerAPIController sharedController] getJSONWithSuccessBlock:^(NSDictionary *jsonDictionary) {
            @autoreleasepool {
                if (jsonDictionary[@"vehicles"]) {
                    [TAPreferences standardPreferences].downloaded = YES;
                    [TAPreferences standardPreferences].vehicles = jsonDictionary[@"vehicles"];
                    blockSelf.mutableVehicles =
                        [[[TAPreferences standardPreferences].vehicles mutableCopy] autorelease];
                    [grayView removeFromSuperview];
                    [blockSelf sortVehicles];
                }
            }
        } failureBlock:^(NSError *error) {
            if (!!error) {
                NSLog(@"%@", error.userInfo);
                [grayView removeFromSuperview];
            }
        }];
    }
    else {
        self.mutableVehicles =
            [[[TAPreferences standardPreferences].vehicles mutableCopy] autorelease];
        [self sortVehicles];
    }
}

- (void)sortVehicles
{
    [self.mutableBikes removeAllObjects];
    [self.mutableCars removeAllObjects];
    [self.mutableTrucks removeAllObjects];
    for (id vehicle in self.mutableVehicles) {
        if (vehicle[kVehicleTypeKey]) {
            if ([vehicle[kVehicleTypeKey] isEqualToString:kVehicleTypeBike]) {
                [self.mutableBikes addObject:vehicle];
            }
            else if ([vehicle[kVehicleTypeKey] isEqualToString:kVehicleTypeCar]) {
                [self.mutableCars addObject:vehicle];
            }
            else if ([vehicle[kVehicleTypeKey] isEqualToString:kVehicleTypeTruck]) {
                [self.mutableTrucks addObject:vehicle];
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark Action
- (IBAction)didTouchAddBarButtonItem:(UIBarButtonItem *)sender
{
}

- (IBAction)didTouchOptionsBarButtonItem:(UIBarButtonItem *)sender
{
}

#pragma mark TAEditVehicleVCDelegate Methods
- (void) editVehicleVC:(TAEditVehicleVC *)sender didFinishedWithVehicle:(id)vehicle
{
    if (vehicle) {
    
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TAVehicle *vehicle = nil;
    if (indexPath.section == SectionTypeCars) {
        vehicle = [self.mutableCars objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == SectionTypeBikes) {
        vehicle = [self.mutableBikes objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == SectionTypeTrucks) {
        vehicle = [self.mutableTrucks objectAtIndex:indexPath.row];
    }

    TAEditVehicleVC *const editVC =
        [[TAEditVehicleVC alloc] initWithVehicle:vehicle];
    
    editVC.delegate = self;
    
    UINavigationController *const navigationController =
        [[UINavigationController alloc] initWithRootViewController:editVC];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [navigationController release];
    [editVC release];
}

#pragma mark UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
if (section == SectionTypeCars) {
        return [kSectionTitleCars autorelease];
    }
    else if (section == SectionTypeBikes) {
        return [kSectionTitleBikes autorelease];
    }
    else if (section == SectionTypeTrucks) {
        return [kSectionTitleTrucks autorelease];
    }
    else return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* tableViewCell;
    tableViewCell = [tableView dequeueReusableCellWithIdentifier:userCellId];
    if (!tableViewCell) {
        tableViewCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                               reuseIdentifier:userCellId] autorelease];
    }
    if(indexPath.section == SectionTypeCars) {
        NSDictionary *vehicle = self.mutableCars[indexPath.row];
        tableViewCell.textLabel.text = vehicle[kManufacturerKey];
        tableViewCell.detailTextLabel.text = vehicle[kModelKey];
    }
    else if(indexPath.section == SectionTypeBikes) {
        NSDictionary *vehicle = self.mutableBikes[indexPath.row];
        tableViewCell.textLabel.text = vehicle[kManufacturerKey];
        tableViewCell.detailTextLabel.text = vehicle[kModelKey];
    }
    else if(indexPath.section == SectionTypeTrucks) {
        NSDictionary *vehicle = self.mutableTrucks[indexPath.row];
        tableViewCell.textLabel.text = vehicle[kManufacturerKey];
        tableViewCell.detailTextLabel.text = vehicle[kModelKey];
    }
    return tableViewCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == SectionTypeCars) {
        return [self.mutableCars count];
    }
    else if (section == SectionTypeBikes) {
        return [self.mutableBikes count];
    }
    else if (section == SectionTypeTrucks) {
        return [self.mutableTrucks count];
    }
    else return 0;
}

#pragma mark MRR
- (void) dealloc
{
    [_mutableVehicles release];
    _mutableVehicles = nil;
    [_mutableCars release];
    _mutableVehicles = nil;
    [_mutableBikes release];
    _mutableVehicles = nil;
    [_mutableTrucks release];
    _mutableVehicles = nil;
    [super dealloc];
}

@end
