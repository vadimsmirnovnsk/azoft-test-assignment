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


@interface TAEditVehicleVC () <UITextFieldDelegate, TAGalleryDelegate>

@property (nonatomic, strong) id vehicle;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *manufacturerField;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *modelField;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *horsePowerField;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *imageView;

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
    
    TADetailsVC *detailsVC = nil;
    if ([self.vehicle[kVehicleTypeKey] isEqualToString:kVehicleTypeCar]) {
        detailsVC = [[TACarVC alloc] init];
    }
    else if ([self.vehicle[kVehicleTypeKey] isEqualToString:kVehicleTypeBike]) {
        detailsVC = [[TABikeVC alloc] init];
    }
    else if ([self.vehicle[kVehicleTypeKey] isEqualToString:kVehicleTypeTruck]) {
        detailsVC = [[TATruckVC alloc] init];
    }
    
    detailsVC.vehicle = self.vehicle;
    detailsVC.textFieldDelegate = self;
    detailsVC.view.frame = kDetailsViewFrame;
    
    [self.view addSubview:detailsVC.view];
    [self addChildViewController:detailsVC];
    [detailsVC didMoveToParentViewController:self];
    
    [detailsVC autorelease];
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

#pragma mark - Actions
- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender
{
    [self.delegate editVehicleVC:self didFinishedWithVehicle:self.vehicle];
}

- (void)didTouchSaveBarButtonItem:(UIBarButtonItem *)sender
{
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

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
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
    [_vehicle release];
    _vehicle = nil;
    [super dealloc];
}

@end
