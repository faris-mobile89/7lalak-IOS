
#import "InAppAPHelper.h"
#import "BuyTableVC.h"
#import "ProductCell.h"
#import "LocalizeHelper.h"
#import "UIColor_hex.h"

@interface BuyTableVC ()

@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSNumberFormatter *priceFormatter;

@end

@implementation BuyTableVC
@synthesize colors;
#pragma mark - User Interface set up

- (id)init
{
    self = [super init];
    if (self) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Restore"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(restoreTapped:)];
        
        self.priceFormatter = [[NSNumberFormatter alloc] init];
        [self.priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [self.priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = LocalizedString(@"TITLE_MORE_BUY_Ads");
    
     colors = [[NSArray alloc]initWithObjects:@"#EB9532",@"#EE543A",@"#D8335B",@"#973163",@"#422E39", nil];
    

    [self.tableView registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil]forCellReuseIdentifier:@"Cell"];
    
    [self reload];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [super viewWillAppear:animated];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     ProductCell *cell = (ProductCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    SKProduct *product = self.products[indexPath.row];
    cell.produtName.text = product.localizedTitle;
    cell.productPrice.text =[[NSString alloc]initWithFormat:@"%@$",[product.price stringValue]];
    
    [self.priceFormatter setLocale:product.priceLocale];
    cell.detailTextLabel.text = [self.priceFormatter stringFromNumber:product.price];
    
    
        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        buyButton.frame = CGRectMake(0, 0, 50, 18);
        [buyButton setBackgroundColor:[UIColor colorWithHexString:@"#2ECC71"]];
        buyButton.layer.cornerRadius=8;
        [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
        [buyButton setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
        [buyButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
        buyButton.tag = indexPath.row;
        [buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = buyButton;
    
    if (indexPath.row % 2 == 0 )
        [cell setBackgroundColor:[UIColor colorWithHexString:@"#913D88"]];
    else
        [cell setBackgroundColor:[UIColor colorWithHexString:@"#422E39"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Gives the product back
    SKProduct *product = self.products[indexPath.row];
    
    // Creates the DetailViewController
    self.fruitDetailViewController = [[AdsDetailViewController alloc]init];
    self.fruitDetailViewController.product = product;
    
    // Pushes the DetailViewController
    [self.navigationController pushViewController:self.fruitDetailViewController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
}

#pragma mark - StoreKit

/*
 When the reload is called (whether it be the first manual call, or when the user pulls to refresh), it calls the FruitIAPHelper’s requestProductsWithCompletionHandler method we wrote earlier to return the In-App Purchase product info from iTunes Connect. When this completes, the block will be called. All it does is store the list of products in the instance variable, reload the table view to display them, and tells the refresh control to stop animating.
 */
- (void)reload
{
    self.products = nil;
    [self.tableView reloadData];
    [[InAppAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            self.products = products;
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)restoreTapped:(id)sender
{
    [[InAppAPHelper sharedInstance] restoreCompletedTransactions];
}

- (void)productPurchased:(NSNotification *)notification
{
    NSString *productIdentifier = notification.object;
    [self.products enumerateObjectsUsingBlock:^(SKProduct *product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            *stop = YES;
        }
    }];
}

- (void)buyButtonTapped:(id)sender
{
    UIButton *buyButton = (UIButton *)sender;
    SKProduct *product = self.products[buyButton.tag];
    NSLog(@"Buying %@ ... (buyButtonTapped in BuyTableVC.m", product.productIdentifier);
    [[InAppAPHelper sharedInstance] buyProduct:product];
}



@end
