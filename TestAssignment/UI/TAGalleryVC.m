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

static CGRect const kBackButtonFrame = (CGRect){10.f, 30.f, 50.f, 30.f};
static CGRect const kStatusLabelFrame = (CGRect){0.f, 30.f, 320.f, 30.f};

@interface TAGalleryVC ()<UIGestureRecognizerDelegate>

@property (nonatomic, copy) NSArray *imagesNames;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *nextImageView;
@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, readwrite) NSInteger currentImageIndex;
@property (nonatomic, strong) UILabel *statusLabel;

@end


@implementation TAGalleryVC

- (instancetype) initWithImagesArray:(NSArray *)imagesNames
{
    if (self = [super init]) {
        _imagesNames = [imagesNames copy];
        _currentImageIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor =
        [UIColor colorWithRed:45.f/255.f green:45.f/255.f blue:45.f/255.f alpha:1.f];
    
    self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.imageButton addTarget:self action:@selector(didTouchImageButton:)
        forControlEvents:UIControlEventTouchUpInside];
    
    self.imageView = [[UIImageView alloc]init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.nextImageView = [[UIImageView alloc] init];
    self.nextImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.nextImageView];
    [self.view addSubview:self.imageButton];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    
    self.statusLabel = [[UILabel alloc]initWithFrame:kStatusLabelFrame];
    self.statusLabel.textColor = [UIColor lightGrayColor];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self updateStatusLabel];
    [self.view addSubview:self.statusLabel];
    
    [self.backButton addTarget:self action:@selector(didTouchBackButton:)
        forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.backButton];
    
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc]
        initWithTarget:self action:@selector(didSwipeLeftImage)];
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc]
        initWithTarget:self action:@selector(didSwipeRightImage)];

    [swipeLeftRecognizer setDirection: (UISwipeGestureRecognizerDirectionLeft)];
    [swipeRightRecognizer setDirection: (UISwipeGestureRecognizerDirectionRight)];
    
    [[self view] addGestureRecognizer:swipeLeftRecognizer];
    [[self view] addGestureRecognizer:swipeRightRecognizer];
    
    [swipeLeftRecognizer release];
    [swipeRightRecognizer release];
}

- (void)updateStatusLabel
{
    self.statusLabel.text = [NSString stringWithFormat:
        @"%d / %d", self.currentImageIndex + 1, [self.imagesNames count]];
}

- (void)didTouchImageButton:(UIButton *)sender
{
    NSLog(@"Touch Button");
    
}

- (void)didTouchBackButton:(UIButton *)sender
{
    [self.delegate gallery:self didFinishedWithIndex:0];
}

- (void)didSwipeLeftImage
{
    if (self.currentImageIndex + 1 < [self.imagesNames count]) {
        self.currentImageIndex = self.currentImageIndex + 1;
    }
    else self.currentImageIndex = 0;
    if (CGRectContainsPoint([UIScreen mainScreen].bounds, self.imageView.center)) {
        [self changeLeftOldImageView:self.imageView
            toNewImageView:self.nextImageView withNextImageIndex:self.currentImageIndex];
    }
    else if (CGRectContainsPoint([UIScreen mainScreen].bounds, self.nextImageView.center)) {
        [self changeLeftOldImageView:self.nextImageView
            toNewImageView:self.imageView withNextImageIndex:self.currentImageIndex];
    }
}

- (void)didSwipeRightImage
{
    if (self.currentImageIndex - 1 >= 0) {
        self.currentImageIndex = self.currentImageIndex - 1;
    }
    else self.currentImageIndex = [self.imagesNames count] - 1;
    if (CGRectContainsPoint([UIScreen mainScreen].bounds, self.imageView.center)) {
        [self changeRightOldImageView:self.imageView
            toNewImageView:self.nextImageView withNextImageIndex:self.currentImageIndex];
    }
    else if (CGRectContainsPoint([UIScreen mainScreen].bounds, self.nextImageView.center)) {
        [self changeRightOldImageView:self.nextImageView
            toNewImageView:self.imageView withNextImageIndex:self.currentImageIndex];
    }
}


- (void)changeLeftOldImageView:(UIImageView *)oldImageView
    toNewImageView:(UIImageView *)newImageView withNextImageIndex:(NSInteger)index
{
    __unsafe_unretained typeof(oldImageView) blockOldImageView = oldImageView;
    __unsafe_unretained typeof(newImageView) blockNewImageView = newImageView;
    
    // Move oldImageView to left, load newImageView
    
        [newImageView setImageWithURL:[NSURL URLWithString:
            [kBaseAPIURL stringByAppendingString:self.imagesNames[index]]]
            placeholderImage:[UIImage imageNamed:@"loading_placeholder"]];
    
        newImageView.frame = (CGRect) {
            [UIScreen mainScreen].bounds.origin.x + [UIScreen mainScreen].bounds.size.width,
            [UIScreen mainScreen].bounds.origin.y,
            [UIScreen mainScreen].bounds.size
        };
    
        [UIView animateWithDuration:0.3 animations:^{
            blockOldImageView.frame = (CGRect) {
                [UIScreen mainScreen].bounds.origin.x - [UIScreen mainScreen].bounds.size.width,
                [UIScreen mainScreen].bounds.origin.y,
                [UIScreen mainScreen].bounds.size
            };
            blockNewImageView.frame = [UIScreen mainScreen].bounds;
        } completion:^(BOOL finished) {
            // Clear cache
            [self updateStatusLabel];
        }];
}

- (void)changeRightOldImageView:(UIImageView *)oldImageView
    toNewImageView:(UIImageView *)newImageView withNextImageIndex:(NSInteger)index
{
    __unsafe_unretained typeof(oldImageView) blockOldImageView = oldImageView;
    __unsafe_unretained typeof(newImageView) blockNewImageView = newImageView;
    
    // Move oldImageView to right, load newImageView
    
        [newImageView setImageWithURL:[NSURL URLWithString:
            [kBaseAPIURL stringByAppendingString:self.imagesNames[index]]]
            placeholderImage:[UIImage imageNamed:@"loading_placeholder"]];
    
        newImageView.frame = (CGRect) {
            [UIScreen mainScreen].bounds.origin.x - [UIScreen mainScreen].bounds.size.width,
            [UIScreen mainScreen].bounds.origin.y,
            [UIScreen mainScreen].bounds.size
        };
    
        [UIView animateWithDuration:0.3 animations:^{
            blockOldImageView.frame = (CGRect) {
                [UIScreen mainScreen].bounds.origin.x + [UIScreen mainScreen].bounds.size.width,
                [UIScreen mainScreen].bounds.origin.y,
                [UIScreen mainScreen].bounds.size
            };
            blockNewImageView.frame = [UIScreen mainScreen].bounds;
        } completion:^(BOOL finished) {
            // Clear cache
            [self updateStatusLabel];
        }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.imageButton.frame = self.view.frame;
    self.imageView.frame = self.view.frame;
    self.nextImageView.frame = (CGRect) {
        [UIScreen mainScreen].bounds.origin.x + [UIScreen mainScreen].bounds.size.width,
        [UIScreen mainScreen].bounds.origin.y,
        [UIScreen mainScreen].bounds.size
    };
    self.backButton.frame = kBackButtonFrame;
    self.navigationController.navigationBar.alpha = 0.f;
    
    [self.imageView setImageWithURL:[NSURL URLWithString:
        [kBaseAPIURL stringByAppendingString:self.imagesNames[self.currentImageIndex]]]
        placeholderImage:[UIImage imageNamed:@"loading_placeholder"]];
}

- (void)dealloc
{
    [_imagesNames release];
    _imagesNames = nil;
    [_imageView release];
    _imageView = nil;
    [_imageButton release];
    _imageButton = nil;
    [_imageView release];
    _imageView = nil;
    [_nextImageView release];
    _nextImageView = nil;
    [super dealloc];
}


@end
