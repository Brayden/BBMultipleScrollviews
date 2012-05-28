//
// MultiScrollSection.m
// -- Easily constructed multi-column scroll views
// -- with customized images and parameter settings
// 
// Created by Brayden Wilmoth on 5/24/2012.
// Copyright (c) 2012 Branding Brand.  All rights reserved.


#import "MultiScrollSection.h"

/** Container View */
@implementation MultiScrollSection
@synthesize orientation = _orientation;
@synthesize doesFillPage = _doesFillPage;
@synthesize disableOverflow = _disableOverflow;
@synthesize sectionPadding = _sectionPadding;
@synthesize pagingInterval = _pagingInterval;
@synthesize subviewPadding = _subviewPadding;
@synthesize sectionsContent = _sectionsContent;
@synthesize scrollDirection = _scrollDirection;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor darkGrayColor];      // Default background color
        self.orientation = kOrientationHorizontal;           // Default value is horizontal
        self.scrollDirection = kOrientationScrollHorizontal; // Default scroll direction
        self.sectionPadding = [NSNumber numberWithInt:1];    // Default pixel padding
        self.pagingInterval = [NSNumber numberWithInt:3];    // Default amount of pages pre-loaded on each side of current
        self.disableOverflow = TRUE;                         // Default flag to disable overflowing of subview contents
        self.clipsToBounds = TRUE;                           // Default to now allow images to flow over container view, can be changed
    }
    
    return self;
}

-(void)drawRect:(CGRect)rect {
    int widthFill = 1;
    if(!self.doesFillPage)    widthFill = [self.pagingInterval intValue];
    
    for(int scrollViews = 0; scrollViews < self.sectionsContent.count; scrollViews++) {
        float x = (self.orientation == kOrientationHorizontal) ? [self.sectionPadding floatValue] + ((rect.size.width / self.sectionsContent.count) * scrollViews) : [self.sectionPadding floatValue];
        float y = (self.orientation == kOrientationHorizontal) ? [self.sectionPadding floatValue] : [self.sectionPadding floatValue] + ((rect.size.height / self.sectionsContent.count) * scrollViews);
        float w = (self.orientation == kOrientationHorizontal) ? (rect.size.width / self.sectionsContent.count) - ((self.sectionsContent.count + 1) * [self.sectionPadding floatValue]) + ([self.sectionPadding floatValue] * (self.sectionsContent.count - 1)) : ((rect.size.width - ([self.sectionPadding floatValue] * 2)) / widthFill);
        float h = (self.orientation == kOrientationHorizontal) ? ((rect.size.height - ([self.sectionPadding floatValue] * 2)) / widthFill) : (rect.size.height / self.sectionsContent.count) - ((self.sectionsContent.count + 1) * [self.sectionPadding floatValue]) + ([self.sectionPadding floatValue] * (self.sectionsContent.count - 1));
        
        SingleScrollSection *scrollSection = [[SingleScrollSection alloc] initWithFrame:(self.orientation == kOrientationVertical) ? CGRectMake((rect.size.width / 2) - (w / 2), y, w, h) : CGRectMake(x, (rect.size.height / 2) - (h / 2), w, h) andArray:[self.sectionsContent objectAtIndex:scrollViews] andInterval:self.pagingInterval allowOverflow:self.disableOverflow];
        scrollSection.contentSize = CGSizeMake((self.scrollDirection == kOrientationScrollHorizontal) ? (w * [[self.sectionsContent objectAtIndex:scrollViews] count]) : 0,
                                               (self.scrollDirection == kOrientationScrollHorizontal) ? 0 : (h * [[self.sectionsContent objectAtIndex:scrollViews] count]));
        scrollSection.subviewPadding = self.subviewPadding;
        scrollSection.scrollDirection = self.scrollDirection;
        [self addSubview:scrollSection];
    }
}

@end






/** Single Scrolling View */
@implementation SingleScrollSection
@synthesize contentArray = _contentArray;
@synthesize subviewPadding = _subviewPadding;
@synthesize pagingInterval = _pagingInterval;
@synthesize scrollDirection = _scrollDirection;

- (id)initWithFrame:(CGRect)frame andArray:(NSArray *)array andInterval:(NSNumber *)interval allowOverflow:(BOOL)overflow
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;                               // Scroll view delegate is itself for accessor methods
        self.pagingEnabled = YES;                           // Always set scroll view to page between images
        self.backgroundColor = [UIColor clearColor];        // Background color set to transparent
        self.contentArray = array;                          // Input array immutable copy
        self.pagingInterval = interval;                     // Number of pages loaded in each direction
        self.clipsToBounds = overflow;                      // Flag enable/disable overflow content
        self.showsVerticalScrollIndicator = FALSE;          // Do not show scrolling indicator
        self.showsHorizontalScrollIndicator = FALSE;        // Do not show scrolling indicator
    }
    
    return self;
}


-(void)drawRect:(CGRect)rect {
    /** Place all the pages */
    for(int pages = 0; pages < self.contentArray.count; pages++) {
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [self.contentArray objectAtIndex:pages]]]];
        image.frame = CGRectMake( (self.scrollDirection == kOrientationScrollHorizontal) ? rect.size.width * pages : 0, 
                                 (self.scrollDirection == kOrientationScrollHorizontal) ? 0 : rect.size.height * pages, 
                                 rect.size.width, 
                                 rect.size.height);
        [self addSubview:image];
    }
    
    
    
    /** Place pages before normal pages */
    for(int previous = [self.pagingInterval intValue]; previous > 0; previous--) {
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [self.contentArray objectAtIndex:(self.contentArray.count - previous)]]]];
        image.frame = CGRectMake( (self.scrollDirection == kOrientationScrollHorizontal) ? -rect.size.width * (previous): 0, 
                                 (self.scrollDirection == kOrientationScrollHorizontal) ? 0 : -rect.size.height * (previous), 
                                 rect.size.width, 
                                 rect.size.height);
        [self addSubview:image];
    }
    
    
    
    /** Place pages after normal pages */
    for(int next = [self.pagingInterval intValue] + 1; next > 0; next--) {
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [self.contentArray objectAtIndex:next - 1]]]];
        image.frame = CGRectMake( (self.scrollDirection == kOrientationScrollHorizontal) ? rect.size.width * ((next + self.contentArray.count) - 1): 0, 
                                 (self.scrollDirection == kOrientationScrollHorizontal) ? 0 : rect.size.height * ((next + self.contentArray.count) - 1), 
                                 rect.size.width, 
                                 rect.size.height);
        [self addSubview:image];
    }
    
    [self setContentSize:CGSizeMake((self.scrollDirection == kOrientationScrollHorizontal) ? rect.size.width * (self.contentArray.count + [self.pagingInterval intValue]) : rect.size.width, (self.scrollDirection == kOrientationScrollVertical) ? rect.size.height * (self.contentArray.count + [self.pagingInterval intValue]) : 0)];
    [self setContentOffset:(self.scrollDirection == kOrientationScrollHorizontal) ? CGPointMake(self.frame.size.width, 0) : CGPointMake(0, self.frame.size.height) animated:NO];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float scrollViewHeight = (self.scrollDirection == kOrientationScrollVertical) ? scrollView.frame.size.height : scrollView.frame.size.width;
    float scrollContentSizeHeight = (self.scrollDirection == kOrientationScrollVertical) ? scrollView.contentSize.height : scrollView.contentSize.width;
    float scrollOffset = (self.scrollDirection == kOrientationScrollVertical) ? scrollView.contentOffset.y : scrollView.contentOffset.x;
    
    if(scrollOffset == 0)
        [self setContentOffset:CGPointMake((self.scrollDirection == kOrientationScrollHorizontal) ? self.frame.size.width * (self.contentArray.count) : 0, (self.scrollDirection == kOrientationScrollVertical) ? self.frame.size.height * (self.contentArray.count) : 0)];
    else if((self.scrollDirection == kOrientationScrollHorizontal) ? scrollOffset + scrollViewHeight > scrollContentSizeHeight - (self.frame.size.width) : scrollOffset + scrollViewHeight > scrollContentSizeHeight - (self.frame.size.height))
        [self setContentOffset:CGPointMake((self.scrollDirection == kOrientationScrollHorizontal) ? self.frame.size.width : 0, (self.scrollDirection == kOrientationScrollVertical) ? self.frame.size.height : 0)];
}




















@end