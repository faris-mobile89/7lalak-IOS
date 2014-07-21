//
//  PlayListPicker1.m
//  7lalak
//
//  Created by Faris IOS on 7/21/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "PlayListPicker1.h"
#import "FSPlayerVC.h"
;
@interface PlayListPicker1 ()

@end

@implementation PlayListPicker1

-(void)viewWillAppear:(BOOL)animated{
    
    UINavigationBar *bar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
  
    bar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBarHidden = NO;
  [self.view addSubview:bar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];

}
@end
