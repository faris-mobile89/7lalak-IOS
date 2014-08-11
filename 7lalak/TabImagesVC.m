//
//  TabImagesVC.m
//  7lalak
//
//  Created by Faris IOS on 6/23/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "TabImagesVC.h"

@interface TabImagesVC ()
@end

@implementation TabImagesVC
@synthesize jsonObject;

ICETutorialPage *layer1,*layer2,*layer3,*layer4,*layer5,*layer6,*layer7;

#pragma mark - View lifecycle

-(void)initLayer :(NSString *)url :(NSInteger) index{
    
    // Init the pages texts, and pictures.
    switch (index) {
        case 1:
            layer1 = [[ICETutorialPage alloc] initWithTitle:@"Picture 1"
                                                   subTitle:@""
                                                pictureName:url
                                                   duration:3.0];
            break;
        case 2:
            layer2 = [[ICETutorialPage alloc] initWithTitle:@"Picture 1"
                                                   subTitle:@""
                                                pictureName:url
                                                   duration:3.0];
            break;
        case 3:
            layer3 = [[ICETutorialPage alloc] initWithTitle:@"Picture 1"
                                                   subTitle:@""
                                                pictureName:url
                                                   duration:3.0];
            break;
        case 4:
            layer4 = [[ICETutorialPage alloc] initWithTitle:@"Picture 1"
                                                   subTitle:@""
                                                pictureName:url
                                                   duration:3.0];
            break;
        case 5:
            layer5 = [[ICETutorialPage alloc] initWithTitle:@"Picture 1"
                                                   subTitle:@""
                                                pictureName:url
                                                   duration:3.0];
            break;
        case 6:
            layer6 = [[ICETutorialPage alloc] initWithTitle:@"Picture 1"
                                                   subTitle:@""
                                                pictureName:url
                                                   duration:3.0];
            break;
        case 7:
            layer7 = [[ICETutorialPage alloc] initWithTitle:@"Picture 1"
                                                   subTitle:@""
                                                pictureName:url
                                                   duration:3.0];
            
        default:
            break;
    }

}


- (void)viewDidLoad {
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
// please not that enoh ana ma 3mlt optimizaiotion la had el code , cuz el dedline la project !!!!!
    NSArray *itemLayers ;
    
    NSArray * images = [jsonObject objectForKey:@"imgs"];
    
                      
    switch ([[jsonObject objectForKey:@"imgs"]count]) {
        case 1:
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:0] :1];
             itemLayers = @[layer1];
            break;
        case 2:
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:0]:1];
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:1] :2];
            itemLayers = @[layer1,layer2];
            break;
        case 3:
            
            [self initLayer:[images objectAtIndex:0]:1];
            [self initLayer:[images objectAtIndex:1] :2];
            [self initLayer:[images objectAtIndex:2] :3];
            itemLayers = @[layer1,layer2,layer3];

            break;

        case 4:
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:0]:1];
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:1] :2];
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:2] :3];
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:3] :4];
            itemLayers = @[layer1,layer2,layer3,layer4];

            break;
        case 5:
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:0]:1];
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:1] :2];
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:2] :3];
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:3] :4];
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:4] :5];
            itemLayers = @[layer1,layer2,layer3,layer4,layer5];

            break;
        case 6:
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:0]:1];
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:1] :2];
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:2] :3];
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:3] :4];
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:4] :5];
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:5] :6];
            itemLayers = @[layer1,layer2,layer3,layer4,layer5,layer6];
            
            break;
        case 7:
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:0]:1];
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:1] :2];
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:2] :3];
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:3] :4];
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:4] :5];
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:5] :6];
            [self initLayer:[[jsonObject objectForKey:@"imgs"]objectAtIndex:6] :7];
            itemLayers = @[layer1,layer2,layer3,layer4,layer5,layer6,layer7];
            break;
            
        default:
            break;
    }
    
    // Set the subTitles style with few properties and let the others by default.
    [[ICETutorialStyle sharedInstance] setSubTitleColor:[UIColor whiteColor]];
    [[ICETutorialStyle sharedInstance] setSubTitleOffset:200];
    
    
    
    // Init tutorial.
    self.viewController = [[ICETutorialController alloc] initWithPages:itemLayers
                                                              delegate:self];
    
    // Run it.
    [self.viewController startScrolling];
     self.viewController.view.frame = CGRectMake(0, 10, 320, 410);
    [self.view addSubview: self.viewController.view];

    [super viewDidLoad];

}
- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
