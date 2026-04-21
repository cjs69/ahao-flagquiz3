//  Behocvui
//
//  Created by XuanHao on 6/17/14.
//  Copyright (c) 2014 VIETKIDGAME. All rights reserved.
//
#import "VKGTopicViewController.h"
#import "Constants.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@interface VKGTopicViewController ()

    @property (nonatomic) AVAudioPlayer *audioPlayerZ;
    @property (nonatomic) long itopic;

    // This object that will be used to count the 60 seconds of each level.
    @property (nonatomic, strong) NSTimer *gameTimer;
    
    // These two member variables that will store the operand values of the addition.
    @property (nonatomic) int correctResult;
    
    // The timer value.
    @property (nonatomic) int timerValue;
    @property (nonatomic) int timerStuff;

    // The current round of a level.
    @property (nonatomic) int currentAdditionCounter;
    @property (nonatomic) NSString *stringResult;
    //Total item of sub cate
    @property (nonatomic) long maxItemCount;

    // The player's score. Its type is int64_t so as to match the expected type by the respective method of GameKit.
    @property (nonatomic) int score;
    
    //Array store country name
    @property (nonatomic, strong) NSArray *pageNames;
    @property (nonatomic, strong) NSArray *pageImages;
    @property (nonatomic, strong) NSArray *pageConts;
    @property (nonatomic, strong) NSMutableArray *pageItems;
    @property (nonatomic, strong) NSArray *pageContImgs;

    -(void)initValues;
    
    
    // When it's called, the timerValue member variable gets its initial value, which is 0, and the timer
    // is re-scheduled in order to start counting the time for a new level.
    -(void)startTimer;
    
    
    // It updates the time label on the view with the current timer value.
    -(void)updateTimerLabel:(NSTimer *)timer;
    
    
    // It creates a new ramdom addition operation and shows is to the lblAddition label, as well as all the three
    // possible answers.
    -(void)createAddition;
    


@end

@implementation VKGTopicViewController

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
    _itopic = _topicID;
    
    //Show ads
    self.bannerView.adUnitID = @"ca-app-pub-7823577003605319/6590867985";
    self.bannerView.rootViewController = self;
    //GADRequest *request = [GADRequest request];
    // Enable test ads on simulators.
    //request.testDevices = @[ @"315f0d08ffee7ccfced67c8efcd992b5" ];
    //[self.bannerView loadRequest:request];
    [self.bannerView loadRequest:[GADRequest request]];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"zbg.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];

    [self initValues];
    // Do any additional setup after loading the view.
    [self createAddition];
    [self startTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self performSegueWithIdentifier:@"UnwindFromSecondView" sender:self];
    [_gameTimer invalidate];
    _gameTimer = nil;
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)bt1click:(id)sender {
    [self getAnswer:1];
}
- (IBAction)bt2click:(id)sender {
    [self getAnswer:2];
}
- (IBAction)bt3click:(id)sender {
    [self getAnswer:3];
}
- (IBAction)bt4click:(id)sender {
    [self getAnswer:4];
}

- (void)resetGame {
    // Set the initial value to all properties.
    //[self initValues];
    
    // Start the timer.
    if (_gameTimer != nil) {
        _gameTimer = nil;
    }
    [self startTimer];
    
    // Create a random addition.
    [self createAddition];
    
    
    // Set the initial score value to the respective label.
    [_lblscore setText:@"0"];
    [_lblinfo setText:@""];
    
}

- (IBAction)continue:(id)sender {
    _btcontinue.hidden = TRUE;
    _btt1.hidden = NO;
    _btt2.hidden = NO;
    _btt3.hidden = NO;
    _btt4.hidden = NO;
    
    [_lblinfo setText:@""];
    [self createAddition];
}

- (void) getAnswer:(int) buttonz {

    // Get the sender's title and check if it matches to the correct result.
    int answer = buttonz;
    _timerStuff = 0;
    if (answer == _correctResult) {
        // In case of a correct answer, then add 10 more points to the score and update
        // the lblScore label.
        _score += 1;
        [_lblinfo setText:NSLocalizedString(@"Mess_Correct", nil)];
        NSString *strfile= @"zok";
        [self playSoundFile:strfile];
        [self createAddition];
    }
    else{
        _btcontinue.hidden = NO;
        _btt1.hidden = YES;
        _btt2.hidden = YES;
        _btt3.hidden = YES;
        _btt4.hidden = YES;
        NSString *strfile= @"zerr";
        [self playSoundFile:strfile];
        [_lblinfo setText:[NSString stringWithFormat: NSLocalizedString(@"Mess_Answer", nil), _stringResult]];
    }
    //update score
    [_lblscore setText:[NSString stringWithFormat: @"%d/%d",_score, _currentAdditionCounter]];
    
    
}

-(void)initValues{
    // Set the initial values to all member variables.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Datalist" ofType:@"plist"];
    NSDictionary * words = [NSDictionary dictionaryWithContentsOfFile:path];
    _pageNames = [words objectForKey:@"country"];
    
    _pageImages = @[@"af.png",@"ala.png",@"al.png",@"dz.png",@"as.png",@"ad.png",@"ao.png",@"ai.png",@"ag.png",@"ar.png",@"am.png",@"aw.png",@"au.png",@"at.png",@"az.png",@"bs.png",@"bh.png",@"bd.png",@"bb.png",@"by.png",@"be.png",@"bz.png",@"bj.png",@"bm.png",@"bt.png",@"bo.png",@"ba.png",@"bw.png",@"br.png",@"bri.png",@"vg.png",@"bn.png",@"bg.png",@"bf.png",@"mm.png",@"bi.png",@"kh.png",@"cm.png",@"ca.png",@"cv.png",@"ky.png",@"cf.png",@"td.png",@"cl.png",@"cn.png",@"chr.png",@"co.png",@"km.png",@"coo.png",@"cr.png",@"hr.png",@"cu.png",@"crc.png",@"cy.png",@"cz.png",@"cg.png",@"dk.png",@"dj.png",@"dm.png",@"dom.png",@"ec.png",@"eg.png",@"sv.png",@"gq.png",@"er.png",@"ee.png",@"et.png",@"fk.png",@"fo.png",@"fj.png",@"fi.png",@"fr.png",@"pf.png",@"gm.png",@"ga.png",@"ge.png",@"de.png",@"gh.png",@"gi.png",@"gr.png",@"gl.png",@"gd.png",@"gu.png",@"gt.png",@"gue.png",@"gn.png",@"gw.png",@"gy.png",@"ht.png",@"hn.png",@"hk.png",@"hu.png",@"is.png",@"in.png",@"id.png",@"ir.png",@"iq.png",@"ie.png",@"im.png",@"il.png",@"it.png",@"ci.png",@"jm.png",@"jp.png",@"je.png",@"jo.png",@"kz.png",@"ke.png",@"ki.png",@"kv.png",@"kw.png",@"kg.png",@"la.png",@"lv.png",@"lb.png",@"ls.png",@"lr.png",@"ly.png",@"li.png",@"lt.png",@"lu.png",@"mo.png",@"mk.png",@"mg.png",@"mw.png",@"my.png",@"mv.png",@"ml.png",@"mt.png",@"mh.png",@"mar.png",@"mr.png",@"mu.png",@"mx.png",@"fm.png",@"md.png",@"mc.png",@"mn.png",@"me.png",@"ms.png",@"ma.png",@"mz.png",@"na.png",@"nr.png",@"np.png",@"nl.png",@"net.png",@"nc.png",@"nz.png",@"ni.png",@"ne.png",@"ng.png",@"niue.png",@"nor.png",@"kp.png",@"norm.png",@"no.png",@"om.png",@"pk.png",@"pw.png",@"pal.png",@"pa.png",@"pg.png",@"py.png",@"pe.png",@"ph.png",@"pit.png",@"pl.png",@"pt.png",@"pr.png",@"qa.png",@"cd.png",@"ro.png",@"ru.png",@"rw.png",@"bl.png",@"sh.png",@"kn.png",@"lc.png",@"mf.png",@"pm.png",@"vc.png",@"ws.png",@"sm.png",@"st.png",@"sa.png",@"sn.png",@"rs.png",@"sc.png",@"sl.png",@"sg.png",@"sai.png",@"sk.png",@"si.png",@"sb.png",@"so.png",@"za.png",@"sou.png",@"kr.png",@"sos.png",@"es.png",@"lk.png",@"sd.png",@"sr.png",@"sva.png",@"sz.png",@"se.png",@"ch.png",@"sy.png",@"tw.png",@"tj.png",@"tz.png",@"th.png",@"tibet.png",@"tl.png",@"tg.png",@"tok.png",@"to.png",@"tt.png",@"tn.png",@"tr.png",@"tm.png",@"tc.png",@"tv.png",@"ug.png",@"ua.png",@"ae.png",@"gb.png",@"us.png",@"uy.png",@"uz.png",@"vu.png",@"va.png",@"ve.png",@"vn.png",@"vi.png",@"wal.png",@"wet.png",@"ye.png",@"zm.png",@"zw.png"];
    
    _pageContImgs = @[@"zlearn0.png", @"zlearn1.png", @"zlearn2.png", @"zlearn3.png", @"zlearn4.png", @"zlearn5.png"];
    _pageConts = @[
                   @[@2,@5,@10,@13,@19,@20,@26,@32,@50,@53,@54,@56,@65,@68,@70,@71,@75,@76,@79,@84,@78,@91,@92,@97,@98,@100,@104,@109,@113,@118,@119,@120,@122,@128,@135,@136,@138,@145,@156,@167,@168,@172,@173,@183,@187,@192,@193,@200,@206,@207,@220,@225,@227,@232],
                   @[@0,@14,@16,@17,@24,@31,@36,@44,@90,@93,@94,@95,@96,@99,@103,@105,@106,@110,@111,@112,@114,@121,@125,@126,@137,@34,@144,@154,@157,@158,@160,@165,@170,@185,@190,@198,@201,@208,@209,@210,@214,@221,@212,@226,@230,@234,@238],
                   @[@3,@6,@22,@27,@33,@35,@37,@39,@41,@47,@55,@42,@171,@57,@61,@63,@64,@66,@74,@73,@77,@85,@86,@101,@107,@115,@116,@117,@123,@124,@127,@131,@132,@140,@141,@142,@150,@151,@174,@176,@184,@186,@188,@189,@195,@196,@199,@202,@205,@211,@215,@219,@224,@239,@240],
                   @[@8,@7,@9,@11,@15,@18,@21,@23,@25,@28,@30,@38,@40,@46,@49,@51,@52,@43,@58,@59,@60,@62,@67,@80,@81,@83,@87,@88,@89,@102,@130,@133,@139,@149,@161,@163,@164,@169,@178,@179,@180,@181,@175,@191,@177,@203,@222,@218,@228,@229,@233,@235],
                   @[@12,@69,@72,@82,@108,@129,@134,@147,@148,@162,@182,@4,@194,@217,@223,@231,@159,@143]
        ];
    
    _pageItems = [[NSMutableArray alloc] init];
    if (_itopic==5)
    {
        _maxItemCount = [_pageImages count];
        for (int i = 0; i < _maxItemCount; ++i) {
            [_pageItems addObject:[NSNumber numberWithInt:i]];
        }
    }
    else
    {
        _pageItems = [[NSMutableArray alloc] initWithArray:_pageConts[_itopic]];
        _maxItemCount = [_pageItems count];
    }
    
    _timerValue = 0;
    _currentAdditionCounter = 0;
    _score = 0;
    _imglevel.image = [UIImage imageNamed:[_pageContImgs objectAtIndex:_itopic]];
    _btcontinue.hidden = YES;
    
}


-(void)startTimer{
    // Set the initial value to the timerValue property and start the timer.
    if (_gameTimer == nil) {
        _timerValue = 0;
        
        _gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(updateTimerLabel:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    
}


-(void)updateTimerLabel:(NSTimer *)timer{
    // Increase the timer value and set it to the lblTime label.
    _timerValue++;
    _timerStuff++;
    [_lbltime setText:[NSString stringWithFormat:@"%d (s)", (_timerValue)]];
   if ((_timerStuff > 2) && (_btcontinue.hidden))
   {
       [_lblinfo setText:@""];
   }
}

-(void)createAddition{
    // Generate two random integer numbers.
    _currentAdditionCounter++;
    int i0, i1, i2, i3;
    int randomResult0 = arc4random() % _maxItemCount;
    
    
    // Produce two more random results.
    int randomResult1 = arc4random() % _maxItemCount;
    while (randomResult1==randomResult0)
    {
        randomResult1 = arc4random() % _maxItemCount;
    }
    int randomResult2 = arc4random() % _maxItemCount;
    while ((randomResult2==randomResult0) || (randomResult2==randomResult1))
    {
        randomResult2 = arc4random() % _maxItemCount;
    }
    int randomResult3 = arc4random() % _maxItemCount;
    while ((randomResult3==randomResult0) || (randomResult3==randomResult2) || (randomResult3==randomResult1))
    {
        randomResult3 = arc4random() % _maxItemCount;
    }
    // Pick randomly the button on which the correct answer will appear.
    _correctResult = arc4random() % 4 + 1;
    
    i0 = [[_pageItems objectAtIndex:randomResult0] intValue];
    i1 = [[_pageItems objectAtIndex:randomResult1] intValue];
    i2 = [[_pageItems objectAtIndex:randomResult2] intValue];
    i3 = [[_pageItems objectAtIndex:randomResult3] intValue];
    _stringResult = [_pageNames objectAtIndex:i0];
    //Set the flag
    _img.image = [UIImage imageNamed:[_pageImages objectAtIndex:i0]];
    
    switch (_correctResult) {
        case 1:
            [_btt1 setTitle:[_pageNames objectAtIndex:i0] forState:UIControlStateNormal];
            [_btt2 setTitle:[_pageNames objectAtIndex:i1] forState:UIControlStateNormal];
            [_btt3 setTitle:[_pageNames objectAtIndex:i2] forState:UIControlStateNormal];
            [_btt4 setTitle:[_pageNames objectAtIndex:i3] forState:UIControlStateNormal];
            break;
        case 2:
            [_btt1 setTitle:[_pageNames objectAtIndex:i1] forState:UIControlStateNormal];
            [_btt2 setTitle:[_pageNames objectAtIndex:i0] forState:UIControlStateNormal];
            [_btt3 setTitle:[_pageNames objectAtIndex:i2] forState:UIControlStateNormal];
            [_btt4 setTitle:[_pageNames objectAtIndex:i3] forState:UIControlStateNormal];
            break;
        case 3:
            [_btt1 setTitle:[_pageNames objectAtIndex:i1] forState:UIControlStateNormal];
            [_btt2 setTitle:[_pageNames objectAtIndex:i2] forState:UIControlStateNormal];
            [_btt3 setTitle:[_pageNames objectAtIndex:i0] forState:UIControlStateNormal];
            [_btt4 setTitle:[_pageNames objectAtIndex:i3] forState:UIControlStateNormal];
            break;
        case 4:
            [_btt1 setTitle:[_pageNames objectAtIndex:i1] forState:UIControlStateNormal];
            [_btt2 setTitle:[_pageNames objectAtIndex:i2] forState:UIControlStateNormal];
            [_btt3 setTitle:[_pageNames objectAtIndex:i3] forState:UIControlStateNormal];
            [_btt4 setTitle:[_pageNames objectAtIndex:i0] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}


- (void)playSoundFile:(NSString*)fileName {
    NSURL* musicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:@"caf"]];
    _audioPlayerZ  = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile  error:nil];
    [_audioPlayerZ setNumberOfLoops:0];
    [_audioPlayerZ play];
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    // Return the orientation you'd prefer - this is what it launches to. The
    // user can still rotate. You don't have to implement this method, in which
    // case it launches in the current orientation
    return UIInterfaceOrientationPortrait;
}

@end
