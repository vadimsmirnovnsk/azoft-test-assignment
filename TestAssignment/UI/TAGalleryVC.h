//
//  TAGalleryVC.h
//  TestAssignment
//
//  Created by Vadim Smirnov on 25/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TAGalleryVC;
@protocol TAGalleryDelegate <NSObject>

- (void)gallery:(TAGalleryVC *)sender didFinishedWithIndex:(NSUInteger)index;

@end


@interface TAGalleryVC : UIViewController

@property (nonatomic, unsafe_unretained) id<TAGalleryDelegate> delegate;

- (instancetype) initWithImagesArray:(NSArray *)imagesNames;

@end
