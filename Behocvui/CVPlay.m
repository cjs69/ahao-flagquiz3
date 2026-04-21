//
//  CVPlay.m
//  flagquiz
//
//  Created by XuanHao on 8/14/14.
//  Copyright (c) 2014 VIETKIDGAME. All rights reserved.
//

#import "CVPlay.h"
#import "VKGPlay.h"
@import GoogleMobileAds;

@interface CVPlay () {
    NSArray *levellist;
    NSArray *arr_ask;
    NSArray *arr_time;
    NSArray *arr_color;
    long indexpathrow;
    BOOL isnolocked;
}

@property (nonatomic, strong) GADBannerView *bannerView;

@end

@implementation CVPlay

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Datalist" ofType:@"plist"];
    NSDictionary * words = [NSDictionary dictionaryWithContentsOfFile:path];
    levellist = [words objectForKey:@"level"];
   
    arr_ask = @[@10, @20, @30, @40, @50]; //So cau hoi tung muc
    arr_time = @[@100, @180, @240, @280, @100];      //thoi gian tra loi (giay)
    
    UIColor *myColor1=[[UIColor alloc]initWithRed:(204/255.0) green:(221/255.0) blue:(221/255.0) alpha:1];
    UIColor *myColor2=[[UIColor alloc]initWithRed:(33/255.0) green:(255/255.0) blue:(138/255.0) alpha:1];
    UIColor *myColor3=[[UIColor alloc]initWithRed:(1/255.0) green:(204/255.0) blue:(255/255.0) alpha:1];
    UIColor *myColor4=[[UIColor alloc]initWithRed:(255/255.0) green:(221/255.0) blue:(68/255.0) alpha:1];
    UIColor *myColor5=[[UIColor alloc]initWithRed:(1/255.0) green:(170/255.0) blue:(239/255.0) alpha:1];
    
    arr_color= @[myColor1,myColor2,myColor3,myColor4,myColor5];
    
    self.collectionView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zbg.jpg"]];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 66, 0);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    
    //[self.view setNeedsDisplay];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupBannerAds];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self layoutBannerAds];
}

- (void)setupBannerAds
{
    if (self.bannerView != nil) {
        if (self.bannerView.superview == nil) {
            [self.navigationController.view addSubview:self.bannerView];
        }
        [self layoutBannerAds];
        return;
    }
    
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    self.bannerView.adUnitID = @"ca-app-pub-7823577003605319/6590867985";
    self.bannerView.rootViewController = self;
    self.bannerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.navigationController.view addSubview:self.bannerView];
    [self layoutBannerAds];
    [self.bannerView loadRequest:[GADRequest request]];
}

- (void)layoutBannerAds
{
    UIView *containerView = self.navigationController.view;
    if (containerView == nil || self.bannerView == nil) {
        return;
    }
    
    CGSize bannerSize = CGSizeFromGADAdSize(kGADAdSizeBanner);
    CGFloat x = (CGRectGetWidth(containerView.bounds) - bannerSize.width) / 2.0;
    CGFloat bottomInset = 8.0;
    if (@available(iOS 11.0, *)) {
        bottomInset += containerView.safeAreaInsets.bottom;
    }
    CGFloat y = CGRectGetHeight(containerView.bounds) - bannerSize.height - bottomInset;
    self.bannerView.frame = CGRectMake(x, y, bannerSize.width, bannerSize.height);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [levellist count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    BOOL ishidden_nolock = 1;
    if (indexPath.row>0)
        ishidden_nolock = [self LoadLevelLock:indexPath.row];
    
    UIButton *bt = (UIButton *) [cell viewWithTag:100];
    if (!ishidden_nolock)
        [bt setAccessibilityHint:@"locked"];
    
    UIImageView *lockImage = (UIImageView *)[cell viewWithTag:2];
    lockImage.image = [UIImage imageNamed:@"zlock.png"];
    [lockImage setHidden: ishidden_nolock];
    
    UILabel *lvLabel = (UILabel *)[cell viewWithTag:1];
    NSString *tt = levellist[indexPath.row];
    lvLabel.text = tt;

    UILabel *lvLabelz = (UILabel *)[cell viewWithTag:3];
    NSString *ttz = [NSString stringWithFormat:NSLocalizedString(@"Mess_time", nil), arr_ask[indexPath.row],arr_time[indexPath.row]];
    lvLabelz.text = ttz;
    //Set back ground
    [cell setBackgroundColor: arr_color[indexPath.row]];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)LoadLevelLock:(long) iLevel
{
    NSString *strFromInt = [NSString stringWithFormat:@"LEVEL%ld",iLevel];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:strFromInt];
    int i = [str intValue];
    if (i==0)
        return FALSE;
    else
        return TRUE;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"playgame"]) {
        VKGPlay *destViewController = segue.destinationViewController;
        destViewController.levelID = indexpathrow;
    }

}

- (IBAction)getindexpath:(UIButton *)sender {
    NSString *strz = sender.accessibilityHint;
    isnolocked = YES;
    if ([strz isEqualToString:@"locked"])
    {
        isnolocked = NO;
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:NSLocalizedString(@"infor", nil)
                                     message:NSLocalizedString(@"Mess_lock", nil)
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"OKZ", nil)
                                    style:UIAlertActionStyleDestructive
                                    handler:^(UIAlertAction * action)
                                    {
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    NSIndexPath *indexPath = nil;
    indexPath = [self.collectionView indexPathForItemAtPoint:[self.collectionView convertPoint:sender.center fromView:sender.superview]];
    indexpathrow = indexPath.row;
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"playgame"])
    {
        return isnolocked;
    }
    return YES;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [self.bannerView removeFromSuperview];
    self.bannerView = nil;
    /*
    UIImage * backButtonImage = [[UIImage imageNamed:@"zback.png"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(6, 15, 6, 7)];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:self.title
                                                                   style:UIBarButtonItemStylePlain target:nil action:NULL];
    [buttonItem setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal
                                  barMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = buttonItem;
    */
    
}

@end
