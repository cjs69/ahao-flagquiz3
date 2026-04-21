//utf-8;13421798484// behocvui
//
//
//
//
@import GoogleMobileAds;
#import <UIKit/UIKit.h>

@interface VKGTopicViewController : UIViewController
@property long topicID;

@property (weak, nonatomic) IBOutlet UIImageView *imglevel;
@property (weak, nonatomic) IBOutlet UILabel *lbltime;
@property (weak, nonatomic) IBOutlet UILabel *lblscore;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lblinfo;
@property (weak, nonatomic) IBOutlet UIButton *btt1;
@property (weak, nonatomic) IBOutlet UIButton *btt2;
@property (weak, nonatomic) IBOutlet UIButton *btt3;
@property (weak, nonatomic) IBOutlet UIButton *btt4;
@property (weak, nonatomic) IBOutlet UIButton *btcontinue;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end