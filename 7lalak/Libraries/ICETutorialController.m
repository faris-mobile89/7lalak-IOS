//
//  ICETutorialController.m
//
//
//  Created by Patrick Trillsam on 25/03/13.
//  Copyright (c) 2013 Patrick Trillsam. All rights reserved.
//

#import "ICETutorialController.h"
#import "UIImageView+ProgressView.h"
#import "UIColor_hex.h"
#import "FNImageViewZoomVC.h"
#import "ZoomVC.h"

@interface ICETutorialController ()
@property (nonatomic, strong, readonly) UIImageView *frontLayerView;
@property (nonatomic, strong, readonly) UIImageView *backLayerView;
@property (nonatomic, strong, readonly) UIImageView *gradientView;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UIPageControl *pageControl;
@property (nonatomic, assign) ScrollingState currentState;
@property (nonatomic, strong) NSArray *pages;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign) NSInteger nextPageIndex;

@end

@implementation ICETutorialController

UIImage *image;
UIImageView *img;
UIPinchGestureRecognizer *twoFingerPinch;

- (instancetype)initWithPages:(NSArray *)pages {
    self = [self init];
    if (self) {
        _autoScrollEnabled = YES;
        _pages = pages;
        _frontLayerView = [[UIImageView alloc] init];
        _backLayerView = [[UIImageView alloc] init];
        _gradientView = [[UIImageView alloc] init];
        _scrollView = [[UIScrollView alloc] init];
        _pageControl = [[UIPageControl alloc] init];
       
    }
    return self;
}

-(void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer{
    
        NSLog(@"Pinch scale: %f", recognizer.scale);
    if (recognizer.scale >1.0f && recognizer.scale < 2.5f) {
        CGAffineTransform transform = CGAffineTransformMakeScale(recognizer.scale, recognizer.scale);
        self.frontLayerView.transform = transform;
    }
}

- (instancetype)initWithPages:(NSArray *)pages
                     delegate:(id<ICETutorialControllerDelegate>)delegate {
    self = [self initWithPages:pages];
    if (self) {
        _delegate = delegate;
    }
    return self;
}


- (IBAction)zoomImage:(id)sender {
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    twoFingerPinch = [[UIPinchGestureRecognizer alloc]
                      initWithTarget:self
                      action:@selector(twoFingerPinch:)];
    

    _scrollView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_scrollView addGestureRecognizer:tap];
    
    [self setupView];
    
    // Overlays.
    [self setOverlayTexts];
    
    // Preset the origin state.
    [self setOriginLayersState];
 
	// Do any additional setup after loading the view, typically from a nib.
    
  
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer{
    
    int index = (int)self.pageControl.currentPage;
    NSString *imgUrl = [self.pages[index] pictureName];
    
    NSLog(@"C%@",imgUrl);
    
    FNImageViewZoomVC *zoomImageView = [[FNImageViewZoomVC alloc]init];
    zoomImageView.imageURl = [NSURL URLWithString:imgUrl];
    
    FNImageViewZoomVC *zImage = [self.storyboard instantiateViewControllerWithIdentifier:@"ImgZoom"];

    //ZoomVC *zoom = [[ZoomVC alloc]init];
    
    [self presentViewController:zImage animated:NO completion:nil];

}

- (void)setupView {
    //  [self.frontLayerView setFrame:self.view.bounds];
    //[self.backLayerView setFrame:self.view.bounds];
    
    CGRect newFrame = self.view.frame;
    
    newFrame.size.width = 320;
    newFrame.size.height = 400;
    [self.frontLayerView  setFrame:newFrame];
     [self.backLayerView setFrame:newFrame];
    
    // Decoration.
    //[self.gradientView setImage:[UIImage imageNamed:@"background-gradient.png"]];
    // ScrollView configuration.
    
    [self.scrollView setFrame:self.view.bounds];
    [self.scrollView setDelegate:self];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake([self numberOfPages] * self.view.frame.size.width,
                                                self.scrollView.contentSize.height)];


    // PageControl configuration.
    [self.pageControl setNumberOfPages:[self numberOfPages]];
    [self.pageControl setCurrentPage:0];
    [self.pageControl addTarget:self
                         action:@selector(didClickOnPageControl:)
               forControlEvents:UIControlEventValueChanged];
    
    
    [self.view addSubview:self.frontLayerView];
    [self.view addSubview:self.backLayerView];
    [self.view addSubview:self.gradientView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    
    [self addAllConstraints];
}

#pragma mark - Constraints management.

- (void)addAllConstraints {
    
    [self.frontLayerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	[self.backLayerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_pageControl, _gradientView);
    NSMutableArray *constraints = [NSMutableArray array];
    


    // PageControl.
    [self.pageControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [constraints addObject:@"V:[_pageControl(==32)]-60-|"];
    [constraints addObject:@"H:|-140-[_pageControl(==40)]"];

    // GradientView.
    [self.gradientView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [constraints addObject:@"V:[_gradientView(==200)]-0-|"];
    [constraints addObject:@"H:|-0-[_gradientView(==320)]-0-|"];
    
    // Set constraints.
    for (NSString *string in constraints) {
        [self.view addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:string
                                   options:0 metrics:nil
                                   views:views]];
    }
}


- (IBAction)didClickOnPageControl:(UIPageControl *)sender {
    [self stopScrolling];
    // Make the scrollView animation.
    [self scrollToNextPageIndex:sender.currentPage];
}

#pragma mark - Pages
// Set the list of pages (ICETutorialPage).
- (void)setPages:(NSArray *)pages {
    _pages = pages;
}

- (NSUInteger)numberOfPages {
    if (self.pages) {
        return [self.pages count];
    }
    
    return 0;
}

#pragma mark - Animations
- (void)animateScrolling {
    if (self.currentState & ScrollingStateManual) {
        return;
    }
    
    // Jump to the next page...
    NSInteger nextPage = self.currentPageIndex + 1;
    if (nextPage == [self numberOfPages]) {
        // ...stop the auto-scrolling or...
        if (!self.autoScrollEnabled) {
            self.currentState = ScrollingStateManual;
            return;
        }
        
        // ...jump to the first page.
        nextPage = 0;
        self.currentState = ScrollingStateLooping;
        
        // Set alpha on layers.
        [self setOriginLayerAlpha];
        [self setBackLayerPictureWithPageIndex:-1];
    } else {
        self.currentState = ScrollingStateAuto;
    }
    
    // Make the scrollView animation.
    [self scrollToNextPageIndex:nextPage];
    
    // Call the next animation after X seconds.
    [self autoScrollToNextPage];
}

// Call the next animation after X seconds.
- (void)autoScrollToNextPage {
    ICETutorialPage *page = self.pages[self.currentPageIndex];

    if (self.autoScrollEnabled) {
        [self performSelector:@selector(animateScrolling)
                   withObject:nil
                   afterDelay:page.duration];
    }
}

- (void)scrollToNextPageIndex:(NSUInteger)nextPageIndex {
    // Make the scrollView animation.
    [self.scrollView setContentOffset:CGPointMake(nextPageIndex * self.view.frame.size.width,0)
                             animated:YES];

    // Set the PageControl on the right page.
    [self.pageControl setCurrentPage:nextPageIndex];
    
}

#pragma mark - Scrolling management
// Run it.
- (void)startScrolling {
    [self autoScrollToNextPage];
}

// Manually stop the scrolling
- (void)stopScrolling {
    self.currentState = ScrollingStateManual;
}

#pragma mark - State management
// State.
- (ScrollingState)getCurrentState {
    return self.currentState;
}

#pragma mark - Overlay management

// Setup the Title/Subtitle style/text.
- (void)setOverlayTexts {
    int index = 0;    
    for (ICETutorialPage *page in self.pages) {
        // SubTitles.
        if ([[[page title] text] length]) {
            [self overlayLabelWithStyle:[page title]
                            commonStyle:[[ICETutorialStyle sharedInstance] titleStyle]
                                  index:index];
        }
        // Description.
        if ([[[page subTitle] text] length]) {
            [self overlayLabelWithStyle:[page subTitle]
                            commonStyle:[[ICETutorialStyle sharedInstance] subTitleStyle]
                                  index:index];
        }
        
        index++;
    }
}

- (void)overlayLabelWithStyle:(ICETutorialLabelStyle *)style
                  commonStyle:(ICETutorialLabelStyle *)commonStyle
                        index:(NSUInteger)index {
    // SubTitles.
    UILabel *overlayLabel = [[UILabel alloc] initWithFrame:CGRectMake((index * self.view.frame.size.width),
                                                                      self.view.frame.size.height - [commonStyle offset],
                                                                      self.view.frame.size.width,
                                                                      TUTORIAL_LABEL_HEIGHT)];
    [overlayLabel setNumberOfLines:[commonStyle linesNumber]];
    [overlayLabel setBackgroundColor:[UIColor clearColor]];
    [overlayLabel setTextAlignment:NSTextAlignmentCenter];  

    // Datas and style.
    [overlayLabel setText:[style text]];
    [style font] ? [overlayLabel setFont:[style font]] :
                   [overlayLabel setFont:[commonStyle font]];
    [style textColor] ? [overlayLabel setTextColor:[style textColor]] :
                        [overlayLabel setTextColor:[commonStyle textColor]];
  
    [self.scrollView addSubview:overlayLabel];
}

#pragma mark - Layers management
// Handle the background layer image switch.
- (void)setBackLayerPictureWithPageIndex:(NSInteger)index {
    [self setBackgroundImage:self.backLayerView withIndex:index + 1];
}

// Handle the front layer image switch.
- (void)setFrontLayerPictureWithPageIndex:(NSInteger)index {
    [self setBackgroundImage:self.frontLayerView withIndex:index];
}

#pragma mark ======== setImage ===========
// Handle page image's loading
- (void)setBackgroundImage:(UIImageView *)imageView withIndex:(NSInteger)index {
    
    if (index >= [self.pages count]) {
        [imageView setImage:nil];
        return;
    }
    
    //[imageView setImage:[UIImage imageNamed:[self.pages[index] pictureName]]];
    
    /**
     Customiztion by Faris.it.cs@gmail.com
     */
    //NSLog(@"Image URL%@",[self.pages[index] pictureName]);
    /*
    UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    animatedImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"image1.gif"],
                                         [UIImage imageNamed:@"image2.gif"],
                                         [UIImage imageNamed:@"image3.gif"],
                                         [UIImage imageNamed:@"image4.gif"], nil];
    animatedImageView.animationDuration = 1.0f;
    animatedImageView.animationRepeatCount = 0;
    [animatedImageView startAnimating];
    
    
    */
    //[imageView sd_setImageWithURL:[NSURL URLWithString:[self.pages[index] pictureName]] placeholderImage:[UIImage imageNamed:@"Icon-60.png"]];
    
    NSString *imgUrl = [self.pages[index] pictureName];
    
    [imageView setImageWithURL:[NSURL URLWithString:imgUrl] usingProgressView:nil];
    //[img setTag:index];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
}

//to scale images without changing aspect ratio
-(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize {
    
    float width = newSize.width;
    float height = newSize.height;
    
    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
    //indent in case of width or height difference
    float offset = (width - height) / 2;
    if (offset > 0) {
        rect.origin.y = offset;
    }
    else {
        rect.origin.x = -offset;
    }
    
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
    
}
// Setup lapyer's alpha.
- (void)setOriginLayerAlpha {
    [self.frontLayerView setAlpha:1];
    [self.backLayerView setAlpha:0];
}

// Preset the origin state.
- (void)setOriginLayersState {
    self.currentState = ScrollingStateAuto;
    [self.backLayerView setBackgroundColor:[UIColor blackColor]];
    [self.frontLayerView setBackgroundColor:[UIColor blackColor]];
    [self setLayersPicturesWithIndex:0];
}

// Setup the layers with the page index.
- (void)setLayersPicturesWithIndex:(NSInteger)index {
    self.currentPageIndex = index;
    [self setOriginLayerAlpha];
    [self setFrontLayerPictureWithPageIndex:index];
    [self setBackLayerPictureWithPageIndex:index];
}

// Animate the fade-in/out (Cross-disolve) with the scrollView translation.
- (void)disolveBackgroundWithContentOffset:(float)offset {
    if (self.currentState & ScrollingStateLooping){
        // Jump from the last page to the first.
        [self scrollingToFirstPageWithOffset:offset];
    } else {
        // Or just scroll to the next/previous page.
        [self scrollingToNextPageWithOffset:offset];
    }
}

// Handle alpha on layers when the auto-scrolling is looping to the first page.
- (void)scrollingToFirstPageWithOffset:(float)offset {
    // Compute the scrolling percentage on all the page.
    offset = (offset * self.view.frame.size.width) / (self.view.frame.size.width * [self numberOfPages]);
    
    // Scrolling finished...
    if (!offset){
        // ...reset to the origin state.
        [self setOriginLayersState];
        return;
    }
    
    // Invert alpha for the back picture.
    float backLayerAlpha = (1 - offset);
    float frontLayerAlpha = offset;
    
    // Set alpha.
    [self.backLayerView setAlpha:backLayerAlpha];
    [self.frontLayerView setAlpha:frontLayerAlpha];
}

// Handle alpha on layers when we are scrolling to the next/previous page.
- (void)scrollingToNextPageWithOffset:(float)offset {
    // Current page index in scrolling.
    NSInteger nextPage = (int)offset;
    
    // Keep only the float value.
    float alphaValue = offset - nextPage;
    
    // This is only when you scroll to the right on the first page.
    // That will fade-in black the first picture.
    if (alphaValue < 0 && self.currentPageIndex == 0){
        [self.backLayerView setImage:nil];
        [self.frontLayerView setAlpha:(1 + alphaValue)];
        return;
    }
    
    // Switch pictures, and imageView alpha.
    if (nextPage != self.currentPageIndex ||
       ((nextPage == self.currentPageIndex) && (0.0 < offset) && (offset < 1.0)))
        [self setLayersPicturesWithIndex:nextPage];
    
    // Invert alpha for the front picture.
    float backLayerAlpha = alphaValue;
    float frontLayerAlpha = (1 - alphaValue);
    
    // Set alpha.
    [self.backLayerView setAlpha:backLayerAlpha];
    [self.frontLayerView setAlpha:frontLayerAlpha];
}

#pragma mark - ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Get scrolling position, and nextPageindex.
    float scrollingPosition = scrollView.contentOffset.x / self.view.frame.size.width;
    int nextPageIndex = (int)scrollingPosition;
    
    // If we are looping, we reset the indexPage.
    if (self.currentState & ScrollingStateLooping) {
        nextPageIndex = 0;
    }
    
    // If we are going to the next page, let's call the delegate.
    if (nextPageIndex != self.nextPageIndex) {
        if ([self.delegate respondsToSelector:@selector(tutorialController:scrollingFromPageIndex:toPageIndex:)]) {
            [self.delegate tutorialController:self scrollingFromPageIndex:self.currentPageIndex toPageIndex:nextPageIndex];
        }
        
        self.nextPageIndex = nextPageIndex;
    }
    
    // Delegate when we reach the end.
    if (self.nextPageIndex == [self numberOfPages] - 1) {
        if ([self.delegate respondsToSelector:@selector(tutorialControllerDidReachLastPage:)]) {
            [self.delegate tutorialControllerDidReachLastPage:self];
        }
    }

    // Animate.
    [self disolveBackgroundWithContentOffset:scrollingPosition];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // At the first user interaction, we disable the auto scrolling.
    if (self.scrollView.isTracking) {
        [self stopScrolling];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // Update the page index.
    [self.pageControl setCurrentPage:self.currentPageIndex];
}

@end
