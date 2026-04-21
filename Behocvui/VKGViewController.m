//
//  VKGViewController.m
//  Behocvui
//
//  Created by XuanHao on 6/16/14.
//  Copyright (c) 2014 VIETKIDGAME. All rights reserved.
//

#import "VKGViewController.h"
#import "VKGCVController.h"
#import <Social/Social.h>
#import <MobileCoreServices/MobileCoreServices.h>
@import GoogleMobileAds;

@interface VKGViewController () {
    SLComposeViewController *mySLComposerSheet;
    
    //NSArray *titlelist;
}
@property (nonatomic, strong) GADBannerView *bannerView;
@end

@implementation VKGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"zbg.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
   
    [self setupBannerAds];

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self layoutBannerAdsInView:self.view];
}

- (void)setupBannerAds
{
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    self.bannerView.adUnitID = @"ca-app-pub-7823577003605319/6590867985";
    self.bannerView.rootViewController = self;
    self.bannerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:self.bannerView];
    [self layoutBannerAdsInView:self.view];
    [self.bannerView loadRequest:[GADRequest request]];
}

- (void)layoutBannerAdsInView:(UIView *)containerView
{
    CGSize bannerSize = CGSizeFromGADAdSize(kGADAdSizeBanner);
    CGFloat x = (CGRectGetWidth(containerView.bounds) - bannerSize.width) / 2.0;
    CGFloat bottomInset = 8.0;
    if (@available(iOS 11.0, *)) {
        bottomInset += containerView.safeAreaInsets.bottom;
    }
    CGFloat y = CGRectGetHeight(containerView.bounds) - bannerSize.height - bottomInset;
    self.bannerView.frame = CGRectMake(x, y, bannerSize.width, bannerSize.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)behocvui:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/be-hoc-vui/id894300312?mt=8"]];
}
- (IBAction)nhaccu:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/am-thanh-nhac-cu/id895692836?mt=8"]];

}
- (IBAction)dongvat:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/tieng-ong-vat/id896425828?mt=8"]];

}


- (UIImage *) captureView {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
        
        [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
}

- (IBAction)rateapp:(id)sender {
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        mySLComposerSheet = [[SLComposeViewController alloc] init];
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [mySLComposerSheet setInitialText:NSLocalizedString(@"Mess", nil)];
        [mySLComposerSheet addImage:[self captureView]];
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:NSLocalizedString(@"infor", nil)
                                     message:NSLocalizedString(@"Share_app", nil)
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"OKZ", nil)
                                    style:UIAlertActionStyleDestructive
                                    handler:^(UIAlertAction * action)
                                    {
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
- (IBAction)ratethisapp:(id)sender {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/quoc-ky-cac-nuoc-tren-the-gioi/id910465935?ls=1&mt=8"]];

}


@end
