//
//  SSUIViewMiniMe.m
//  SSUIViewMiniMeDemo
//
//  Created by Segev on 12/13/13.
//  Copyright (c) 2013 Segev. All rights reserved.
//

#import "SSUIViewMiniMe.h"

#define HEIGHT 430
#define WIDTH 320

@implementation SSUIViewMiniMe
{
    UIView *zoomedView;
    UIView *miniMe;
    UIImageView *miniMeImageView;
    UIView *miniMeIndicator;
    NSInteger viewRatio;
}

-(SSUIViewMiniMe *)initWithView:(UIView *)viewToMap withRatio:(NSInteger)ratio
{
    self = [super initWithFrame:viewToMap.frame];

    if (self)
    {
        zoomedView = viewToMap;
        viewRatio = ratio;
        [self setBackgroundColor:[UIColor whiteColor]];
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        self.scrollView.contentSize = CGSizeMake(viewToMap.bounds.size.width, viewToMap.bounds.size.height);
        self.scrollView.delegate = self;
        self.scrollView.minimumZoomScale = 1;
        self.scrollView.maximumZoomScale = 20;
        [self.scrollView setBounces:NO];
        [self.scrollView addSubview:viewToMap];

        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        
        tapGesture.numberOfTapsRequired=1;
        tapGesture.cancelsTouchesInView = NO;
        [self.scrollView addGestureRecognizer:tapGesture];
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(holdAction:)];
        longGesture.cancelsTouchesInView = NO;
        [self.scrollView addGestureRecognizer:longGesture];
        
        [self addSubview:self.scrollView];
        
        
        //[miniMe addSubview:miniMeSelectorBtn];
    }
    return self;
}


- (void)tapAction:(UITapGestureRecognizer *)sender
{
    [self performSelector:@selector(updateMiniMe) withObject:nil afterDelay:0.1];
}

- (void)holdAction:(UILongPressGestureRecognizer *)holdRecognizer
{
    if (holdRecognizer.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"Holding...");
    }
    else if (holdRecognizer.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"Released...");
        [self updateMiniMe];
    }
}

- (void)updateMiniMe
{
    miniMeImageView.image = [self captureScreen:zoomedView];
}


-(UIImage*)captureScreen:(UIView*) viewToCapture
{
    CGRect rect = [viewToCapture bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    //[self drawViewHierarchyInRect:viewToCapture.bounds afterScreenUpdates:YES]; //Faster on iOS 7 ?
    [viewToCapture.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(enlargedView:willBeginDragging:)])
    {
        [self.delegate enlargedView:self willBeginDragging:self.scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    miniMeIndicator.frame =
    CGRectMake(self.scrollView.contentOffset.x/viewRatio/self.scrollView.zoomScale,
               self.scrollView.contentOffset.y/viewRatio/self.scrollView.zoomScale,
               miniMeIndicator.frame.size.width,
               miniMeIndicator.frame.size.height);

    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(enlargedView:didScroll:)])
    {
        [self.delegate enlargedView:self didScroll:self.scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(enlargedView:didEndDragging:)])
    {
        [self.delegate enlargedView:self didEndDragging:self.scrollView];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(enlargedView:willBeginDecelerating:)])
    {
        [self.delegate enlargedView:self willBeginDecelerating:self.scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(enlargedView:didEndDecelerating:)])
    {
        [self.delegate enlargedView:self didEndDecelerating:self.scrollView];
    }
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return zoomedView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    miniMeIndicator.frame = CGRectMake(miniMeIndicator.frame.origin.x
                                       , miniMeIndicator.frame.origin.y,
                                       miniMe.frame.size.width/self.scrollView.zoomScale,
                                       miniMe.frame.size.height/self.scrollView.zoomScale);
}

@end
