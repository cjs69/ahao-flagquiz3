//  utf-8;134217984h
//  flagquiz
//
//  Created by XuanHao on 8/15/14.
//  Copyright (c) 2014 VIETKIDGAME. All rights reserved.
//
@import GoogleMobileAds;
#import <UIKit/UIKit.h>

@interface VKGPlay : UIViewController
@property long levelID;
@property (weak, nonatomic) IBOutlet UILabel *lbltime;
@property (weak, nonatomic) IBOutlet UILabel *lblscore;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lblinfo;

@property (weak, nonatomic) IBOutlet UIButton *btt1;
@property (weak, nonatomic) IBOutlet UIButton *btt2;
@property (weak, nonatomic) IBOutlet UIButton *btt3;
@property (weak, nonatomic) IBOutlet UIButton *btt4;

@property (weak, nonatomic) IBOutlet UIImageView *imglive3;
@property (weak, nonatomic) IBOutlet UIImageView *imglive2;
@property (weak, nonatomic) IBOutlet UIImageView *imglive1;

@property (weak, nonatomic) IBOutlet UIImageView *imglevel;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;


@end
