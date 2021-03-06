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

static NSString *const kReorderTitleNormal = @"Reorder";
static NSString *const kReorderTitleSelected = @"Done!";


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
            if (jsonDictionary[@"vehicles"]) {
                [TAPreferences standardPreferences].downloaded = YES;
                [TAPreferences standardPreferences].vehicles = jsonDictionary[@"vehicles"];
                blockSelf.mutableVehicles =
                    [[[TAPreferences standardPreferences].vehicles mutableCopy] autorelease];
                [grayView removeFromSuperview];
                [blockSelf sortVehicles];
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
    TAEditVehicleVC *const editVC = [[[TAEditVehicleVC alloc]
        initWithVehicle:[NSDictionary dictionary] indexPath:nil] autorelease];
    
    
    editVC.delegate = self;
    
    UINavigationController *const navigationController =
        [[[UINavigationController alloc] initWithRootViewController:editVC] autorelease];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (IBAction)didTouchOptionsBarButtonItem:(UIBarButtonItem *)sender
{
    [TAPreferences standardPreferences].downloaded = NO;
    [self loadVehicles];
}

- (IBAction)didTouchReorderBarButtonItem:(UIBarButtonItem *)sender
{
    if ([sender.title isEqualToString:kReorderTitleSelected]) {
        [self.tableView setEditing:NO animated:NO];
        [sender setTitle:kReorderTitleNormal];
    }
    else {
        [self.tableView setEditing:YES animated:YES];
        [sender setTitle:kReorderTitleSelected];
    }
}


#pragma mark TAEditVehicleVCDelegate Methods
- (void) editVehicleVC:(TAEditVehicleVC *)sender
    didFinishedWithVehicle:(id)vehicle indexPath:(NSIndexPath *)indexPath
{
    if (indexPath) {
        if (indexPath.section == VehicleTypeCars) {
            [self.mutableCars insertObject:vehicle atIndex:indexPath.row];
        }
        else if (indexPath.section == VehicleTypeBikes) {
            [self.mutableBikes insertObject:vehicle atIndex:indexPath.row];
        }
        else if (indexPath.section == VehicleTypeTrucks) {
            [self.mutableTrucks insertObject:vehicle atIndex:indexPath.row];
        }
        // Save changes.
        NSMutableArray *commonArray = [NSMutableArray arrayWithArray:self.mutableCars];
        [commonArray addObjectsFromArray:self.mutableBikes];
        [commonArray addObjectsFromArray:self.mutableTrucks];
        [TAPreferences standardPreferences].vehicles = [[commonArray copy] autorelease];
        [self.tableView reloadData];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TAVehicle *vehicle = nil;
    if (indexPath.section == VehicleTypeCars) {
        vehicle = [[[self.mutableCars objectAtIndex:indexPath.row] copy] autorelease];
        [self.mutableCars removeObject:vehicle];
    }
    else if (indexPath.section == VehicleTypeBikes) {
        vehicle = [[[self.mutableBikes objectAtIndex:indexPath.row] copy] autorelease];
        [self.mutableBikes removeObject:vehicle];
    }
    else if (indexPath.section == VehicleTypeTrucks) {
        vehicle = [[[self.mutableTrucks objectAtIndex:indexPath.row] copy] autorelease];
        [self.mutableTrucks removeObject:vehicle];
    }

    TAEditVehicleVC *const editVC =
        [[[TAEditVehicleVC alloc] initWithVehicle:vehicle indexPath:indexPath] autorelease];
    
    
    editVC.delegate = self;
    
    UINavigationController *const navigationController =
        [[[UINavigationController alloc] initWithRootViewController:editVC] autorelease];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    TAVehicle *vehicle = nil;
    if (indexPath.section == VehicleTypeCars) {
        vehicle = [[[self.mutableCars objectAtIndex:indexPath.row] copy] autorelease];
        [self.mutableCars removeObject:vehicle];
    }
    else if (indexPath.section == VehicleTypeBikes) {
        vehicle = [[[self.mutableBikes objectAtIndex:indexPath.row] copy] autorelease];
        [self.mutableBikes removeObject:vehicle];
    }
    else if (indexPath.section == VehicleTypeTrucks) {
        vehicle = [[[self.mutableTrucks objectAtIndex:indexPath.row] copy] autorelease];
        [self.mutableTrucks removeObject:vehicle];
    }
        // Save changes
        NSMutableArray *commonArray = [NSMutableArray arrayWithArray:self.mutableCars];
        [commonArray addObjectsFromArray:self.mutableBikes];
        [commonArray addObjectsFromArray:self.mutableTrucks];
        [TAPreferences standardPreferences].vehicles = [[commonArray copy] autorelease];
    
        [tableView beginUpdates];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]
            withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [tableView endUpdates];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
        toIndexPath:(NSIndexPath *)destinationIndexPath {
    TAVehicle *vehicle = nil;
    if (sourceIndexPath.section == VehicleTypeCars) {
        vehicle = [[[self.mutableCars objectAtIndex:sourceIndexPath.row] copy] autorelease];
        [self.mutableCars removeObjectAtIndex:sourceIndexPath.row];
        [self.mutableCars insertObject:vehicle atIndex:destinationIndexPath.row];
    }
    else if (sourceIndexPath.section == VehicleTypeBikes) {
        vehicle = [[[self.mutableBikes objectAtIndex:sourceIndexPath.row] copy] autorelease];
        [self.mutableBikes removeObjectAtIndex:sourceIndexPath.row];
        [self.mutableBikes insertObject:vehicle atIndex:destinationIndexPath.row];
    }
    else if (sourceIndexPath.section == VehicleTypeTrucks) {
        vehicle = [[[self.mutableTrucks objectAtIndex:sourceIndexPath.row] copy] autorelease];
        [self.mutableTrucks removeObjectAtIndex:sourceIndexPath.row];
        [self.mutableTrucks insertObject:vehicle atIndex:destinationIndexPath.row];
    }
    // Save changes
        NSMutableArray *commonArray = [NSMutableArray arrayWithArray:self.mutableCars];
        [commonArray addObjectsFromArray:self.mutableBikes];
        [commonArray addObjectsFromArray:self.mutableTrucks];
        [TAPreferences standardPreferences].vehicles = [[commonArray copy] autorelease];
}

- (NSIndexPath *)tableView:(UITableView *)tableView
        targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
        toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    NSUInteger sectionCount = 0;
    if (sourceIndexPath.section == VehicleTypeCars) {
        sectionCount = [self.mutableCars count];
    }
    else if (sourceIndexPath.section == VehicleTypeBikes) {
        sectionCount = [self.mutableBikes count];
    }
    else if (sourceIndexPath.section == VehicleTypeTrucks) {
        sectionCount = [self.mutableTrucks count];
    }
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSUInteger rowInSourceSection =
             (sourceIndexPath.section > proposedDestinationIndexPath.section) ?
               0 : sectionCount - 1;
        return [NSIndexPath indexPathForRow:rowInSourceSection inSection:sourceIndexPath.section];
    } else if (proposedDestinationIndexPath.row >= sectionCount) {
        return [NSIndexPath indexPathForRow:sectionCount - 1 inSection:sourceIndexPath.section];
    }
    // Allow the proposed destination.
    return proposedDestinationIndexPath;
}






#pragma mark UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
if (section == VehicleTypeCars) {
        return [kSectionTitleCars autorelease];
    }
    else if (section == VehicleTypeBikes) {
        return [kSectionTitleBikes autorelease];
    }
    else if (section == VehicleTypeTrucks) {
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
    if(indexPath.section == VehicleTypeCars) {
        NSDictionary *vehicle = self.mutableCars[indexPath.row];
        tableViewCell.textLabel.text = vehicle[kManufacturerKey];
        tableViewCell.detailTextLabel.text = vehicle[kModelKey];
    }
    else if(indexPath.section == VehicleTypeBikes) {
        NSDictionary *vehicle = self.mutableBikes[indexPath.row];
        tableViewCell.textLabel.text = vehicle[kManufacturerKey];
        tableViewCell.detailTextLabel.text = vehicle[kModelKey];
    }
    else if(indexPath.section == VehicleTypeTrucks) {
        NSDictionary *vehicle = self.mutableTrucks[indexPath.row];
        tableViewCell.textLabel.text = vehicle[kManufacturerKey];
        tableViewCell.detailTextLabel.text = vehicle[kModelKey];
    }
    return tableViewCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == VehicleTypeCars) {
        return [self.mutableCars count];
    }
    else if (section == VehicleTypeBikes) {
        return [self.mutableBikes count];
    }
    else if (section == VehicleTypeTrucks) {
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
