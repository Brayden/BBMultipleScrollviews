//
//  MultiScrollSection.h
//  StyleMixer
//
//  Created by Brayden Wilmoth on 5/24/12.
//  Copyright (c) 2012 Ball State University. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kOrientationHorizontal,
    kOrientationVertical
} kOrientation;

typedef enum {
    kOrientationScrollHorizontal,
    kOrientationScrollVertical
} kScrollDirection;

/** Container View */
@interface MultiScrollSection : UIView

@property(nonatomic)BOOL                    disableOverflow;    // Flag determines if the sub-scroll views content can overflow (i.e. - clipToBounds)
@property(nonatomic)BOOL                    doesFillPage;       // Flag whether to fill the view or allow for overflow content
@property(nonatomic)kOrientation            orientation;        // Determines which way the scroll views are laid out
@property(nonatomic)kScrollDirection        scrollDirection;    // Determines whether it allows for vertical or horizontal scrolling
@property(nonatomic, retain)NSNumber       *sectionPadding;     // Pixels of padding between the scroll views
@property(nonatomic, retain)NSNumber       *subviewPadding;     // Pixels of padding between scroll view content
@property(nonatomic, retain)NSNumber       *pagingInterval;     // Amount of frames to load extra in each direction (Default: 3)
@property(nonatomic, retain)NSMutableArray *sectionsContent;    // Array space contains another array of image names for each scroll view

@end



/** Single Scrolling View */
@interface SingleScrollSection : UIScrollView <UIScrollViewDelegate> {
    BOOL  scrollUp;
    float scrollPos;
}

- (id)initWithFrame:(CGRect)frame andArray:(NSArray *)array andInterval:(NSNumber *)interval allowOverflow:(BOOL)overflow;

@property(nonatomic)kScrollDirection     scrollDirection;
@property(nonatomic, retain)NSNumber    *pagingInterval;
@property(nonatomic, retain)NSNumber    *subviewPadding;
@property(nonatomic, retain)NSArray     *contentArray;

@end
