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
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "TAServerAPIController.h"
#import "TAGalleryVC.h"


static CGRect const kDetailsViewFrame = (CGRect){0.f, 212.f + 179.f, 320.f, 394.f};
static CGFloat const kKeyboardY = 312.f;

static void *const EditVCContext = (void *)&EditVCContext;

#pragma mark - TAEditVehicleVC Extension

@interface TAEditVehicleVC () <UITextFieldDelegate, TAGalleryDelegate>

@property (nonatomic, strong) id vehicle;
@property (nonatomic, strong) id editedVehicle;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *manufacturerField;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *modelField;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *horsePowerField;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) TADetailsVC *detailsVC;
@property (nonatomic, copy) NSIndexPath *indexPath;

@end


#pragma mark - TAEditVehicleVC Implementation

@implementation TAEditVehicleVC

#pragma mark Lifecycle
- (instancetype)initWithVehicle:(id)vehicle indexPath:(NSIndexPath *)indexPath
{
    if (self = [super init]) {
        _vehicle = vehicle;
        [_vehicle retain];
        _editedVehicle = [_vehicle mutableCopy];
        _indexPath = [indexPath copy];
    };
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _vehicle = nil;
        _editedVehicle = nil;
        _indexPath = nil;
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
        self.detailsVC = [[[TACarVC alloc] init] autorelease];
    }
    else if ([self.vehicle[kVehicleTypeKey] isEqualToString:kVehicleTypeBike]) {
        self.detailsVC = [[[TABikeVC alloc] init] autorelease];
    }
    else if ([self.vehicle[kVehicleTypeKey] isEqualToString:kVehicleTypeTruck]) {
        self.detailsVC = [[[TATruckVC alloc] init] autorelease];
    }
    
    self.detailsVC.vehicle = self.vehicle;
    self.detailsVC.editedVehicle = self.editedVehicle;
    self.detailsVC.textFieldDelegate = self;
    self.detailsVC.view.frame = kDetailsViewFrame;
    
    [self.view addSubview:self.detailsVC.view];
    [self addChildViewController:self.detailsVC];
    [self.detailsVC didMoveToParentViewController:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.manufacturerField.placeholder = self.vehicle[kManufacturerKey];
    self.modelField.placeholder = self.vehicle[kModelKey];
    self.horsePowerField.placeholder = [self.vehicle[kHorsePowerKey] stringValue];
    if (self.vehicle[kImagesKey]) {
        [self.imageView setImageWithURL:[NSURL URLWithString:
            [kBaseAPIURL stringByAppendingString:self.vehicle[kImagesKey][0]]]
            placeholderImage:[UIImage imageNamed:@"loading_placeholder"]];
    }
}

#pragma mark Inner
- (void)shiftViewForEditingTextField:(UITextField *)textField
{
    CGRect textFieldAbsolutFrame = [textField.superview
        convertRect:textField.frame toView:self.view];
    if ((textFieldAbsolutFrame.origin.y + textFieldAbsolutFrame.size.height) > kKeyboardY) {
        CGFloat shiftValue = textFieldAbsolutFrame.origin.y - kKeyboardY;
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = (CGRect){
                0,
                self.view.frame.origin.y - shiftValue,
                self.view.frame.size
            };
        }];
    }
}

- (void)unshiftViewForEditingTextField:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = [UIScreen mainScreen].bounds;
    }];
}

#pragma mark Actions
- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender
{
    [self.delegate editVehicleVC:self
        didFinishedWithVehicle:self.vehicle indexPath:self.indexPath];
}

- (void)didTouchSaveBarButtonItem:(UIBarButtonItem *)sender
{
    [self.delegate editVehicleVC:self
        didFinishedWithVehicle:self.editedVehicle indexPath:self.indexPath];
}

- (IBAction)didTouchImageButton:(UIButton *)sender
{
    TAGalleryVC *galleryVC =
        [[TAGalleryVC alloc]initWithImagesArray:self.vehicle[kImagesKey]];

    galleryVC.view.frame = [UIScreen mainScreen].bounds;
    galleryVC.view.alpha = 0.f;
    galleryVC.delegate = self;
    [self.view addSubview:galleryVC.view];
    [self addChildViewController:galleryVC];
    [galleryVC didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        galleryVC.view.alpha = 1.f;
    }];
    
    [galleryVC release];
}

#pragma mark UITextFieldDelegate Protocol Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self shiftViewForEditingTextField:textField];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.manufacturerField]) {
        self.editedVehicle[kManufacturerKey] = self.manufacturerField.text;
    }
    else if ([textField isEqual:self.modelField]) {
        self.editedVehicle[kModelKey] = self.modelField.text;
    }
    else if ([textField isEqual:self.horsePowerField]) {
        if ([self.horsePowerField.text integerValue]) {
            self.editedVehicle[kHorsePowerKey] = @([self.horsePowerField.text integerValue]);
        }
    }
    else [self.detailsVC textFieldWillEndEditing:textField];
    [textField resignFirstResponder];
    [self unshiftViewForEditingTextField:textField];
    return YES;
}

#pragma mark TAGalleryDelegate Protocol Methods
- (void) gallery:(TAGalleryVC *)sender didFinishedWithIndex:(NSUInteger)index
{
    [UIView animateWithDuration:0.3 animations:^{
        sender.view.alpha = 0.f;
        self.navigationController.navigationBar.alpha = 1.f;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark MRR
- (void)dealloc
{
    // MRR
    [_vehicle release];
    _vehicle = nil;
    [_editedVehicle release];
    _editedVehicle = nil;
    [_detailsVC release];
    _detailsVC = nil;
    [super dealloc];
}

@end
