//
//  TAGalleryVC.m
//  TestAssignment
//
//  Created by Vadim Smirnov on 25/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "TAGalleryVC.h"
#import "TAServerAPIController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface TAGalleryVC ()

@property (nonatomic, unsafe_unretained) NSArray *imagesNames;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *imageButton;

@end


@implementation TAGalleryVC

- (instancetype) initWithImagesArray:(NSArray *)imagesNames
{
    if (self = [super init]) {
        _imagesNames = [[imagesNames copy] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =
        [UIColor blackColor];
        //[UIColor colorWithRed:45.f/255.f green:45.f/255.f blue:45.f/255.f alpha:1.f];
    self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.imageButton addTarget:self action:@selector(didTouchImageButton)
        forControlEvents:UIControlEventTouchUpInside];
    self.imageView = [[UIImageView alloc]init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.imageButton];
}

- (void)didTouchImageButton
{
    NSLog(@"Touch Button");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.imageButton.frame = self.view.frame;
    self.imageView.frame = self.view.frame;
    [self.imageView setImageWithURL:[NSURL URLWithString:
        [kBaseAPIURL stringByAppendingString:self.imagesNames[0]]]
        placeholderImage:[UIImage imageNamed:@"loading_placeholder"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
