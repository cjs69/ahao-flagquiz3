//utf-8;13421798484troller.m
//  Behocvui
//
//  Created by XuanHao on 6/16/14.
//  Copyright (c) 2014 VIETKIDGAME. All rights reserved.
//

#import "VKGPlay.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface VKGPlay ()

// This object that will be used to count the 60 seconds of each level.
@property (nonatomic, strong) NSTimer *gameTimer;
@property (nonatomic) AVAudioPlayer *audioPlayerZ;
// These two member variables that will store the operand values of the addition.
@property (nonatomic) int correctResult;

// The timer value.
@property (nonatomic) int timerValue;

// The current level.
@property (nonatomic) int level;

// The current round of a level.
@property (nonatomic) int currentAdditionCounter;

// The player's score. Its type is int64_t so as to match the expected type by the respective method of GameKit.
@property (nonatomic) int64_t score;

// The number of remaining "lives" in the game.
@property (nonatomic) int lives;

// A flag indicating whether the Game Center features can be used after a user has been authenticated.
@property (nonatomic) BOOL gameCenterEnabled;

// This property stores the default leaderboard's identifier.
@property (nonatomic, strong) NSString *leaderboardIdentifier;

//Array store country name
@property (nonatomic, strong) NSArray *pageNames;
@property (nonatomic, strong) NSArray *pageImages;

@property (nonatomic, strong) NSArray *arr_asks;
@property (nonatomic, strong) NSArray *arr_times;
@property (nonatomic, strong) NSArray *arr_lives;
@property (nonatomic, strong) NSArray *arr_imglevels;
// This method is used to set the initial values to all member variables.
-(void)initValues;


// When it's called, the timerValue member variable gets its initial value, which is 0, and the timer
// is re-scheduled in order to start counting the time for a new level.
-(void)startTimer;


// It updates the time label on the view with the current timer value.
-(void)updateTimerLabel:(NSTimer *)timer;


// It creates a new ramdom addition operation and shows is to the lblAddition label, as well as all the three
// possible answers.
-(void)createAddition;


// It updates the level, both internally and visually.
-(void)updateLevelLabel;


// It sets the initial value to the lives member variable and makes visible all "life" images.
-(void)initLives;

@property (nonatomic) int additionsPerLevel;
@property (nonatomic) long maxItemCount;
@property (nonatomic) long currentLevel;
@property (nonatomic) int timeLevel;

@end

@implementation VKGPlay

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
    
    //Show ads
    self.bannerView.adUnitID = @"ca-app-pub-7823577003605319/6590867985";
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    // Enable test ads on simulators.
    //request.testDevices = @[ @"315f0d08ffee7ccfced67c8efcd992b5" ];
    [self.bannerView loadRequest:request];
    
    //Init array values
    [self initValues];
    
    self.navigationController.navigationBar.hidden = NO;
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"zbg.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];

    // Do any additional setup after loading the view.
    [self startTimer];
    [self createAddition];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)close:(id)sender {
    if (_gameTimer != nil) {
        [_gameTimer invalidate];
        _gameTimer = nil;
    }
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)resetGame {
        // Set the initial value to all properties.
        //[self initValues];
        
        // Start the timer.
        if (_gameTimer != nil) {
            [_gameTimer invalidate];
            _gameTimer = nil;
        }
        [self startTimer];
    
        // Make all lives available to the player.
        [self initLives];

        // Create a random addition.
        [self createAddition];
        
    
        // Set the initial score value to the respective label.
        [_lblscore setText:@"0"];
        [_lblinfo setText:@""];
    
   }


- (void) getAnswer:(int) buttonz {
    // Get the sender's title and check if it matches to the correct result.
    int answer = buttonz;
    
    // Declare and init a flag that will indicate whether the game should continue after a
    // player selects wrong answer.
    BOOL shouldContinue = YES;
    
    if (answer == _correctResult) {
        // In case of a correct answer, then add 10 more points to the score and update
        // the lblScore label.
        _score += 1;
        [_lblscore setText:[NSString stringWithFormat:@"%lld", _score]];
        [_lblinfo setText:NSLocalizedString(@"Mess_Correct", nil)];
        NSString *strfile= @"zok";
        [self playSoundFile:strfile];
       
    }
    else{
        // If the player select a wrong answer, then decrease the available amount of lives by one.
        NSString *strfile= @"zerr";
        [self playSoundFile:strfile];

        _lives--;
        [_lblinfo setText:NSLocalizedString(@"Mess_InCorrect", nil)];
        // Next, depending on the number of the remaining lives hide any unnecessary icons to reflect
        // the remaining lives to the player.
        switch (_lives) {
            case 2:
                _imglive3.hidden = YES;
                break;
            case 1:
                _imglive2.hidden = YES;
                break;
            case 0:
                _imglive1.hidden = YES;
                break;
                
            default:
                break;
        }
        
        // If no more lives have been left, the game must stop.
        if (_lives == 0) {
            // Show a "Game Over" message.            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:NSLocalizedString(@"infor", nil)
                                         message:NSLocalizedString(@"OverWrong", nil)
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:NSLocalizedString(@"OKZ", nil)
                                        style:UIAlertActionStyleDestructive
                                        handler:^(UIAlertAction * action)
                                        {
                                        }];
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
            
            // Indicate that the game should not continue.
            shouldContinue = NO;
            
            // Hide any unnecessary controls.
            [self resetGame];
        }
        
    }
    
    // The next part will be executed only if the game is still on.
    if (shouldContinue) {
        // Create a new random addition.
        [self createAddition];
        
        // Increase the round counter value by one.
        _currentAdditionCounter++;
        
        // If the counter becomes equal to the allowed additions per level, then set its initial value,
        // update the level and restart the timer.
        if (_currentAdditionCounter == _additionsPerLevel) {
            _currentAdditionCounter = 0;
            [self updateLevelLabel];
            
            [_gameTimer invalidate];
            _gameTimer = nil;
            
            [self startTimer];
        }
    }
}

-(void)initValues{
    // Set the initial values to all member variables.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Datalist" ofType:@"plist"];
    NSDictionary * words = [NSDictionary dictionaryWithContentsOfFile:path];
    _pageNames = [words objectForKey:@"country"];
    
    _arr_asks = @[@10, @20, @30, @40, @50];       //So cau hoi tung muc
    _arr_times = @[@100, @80, @60, @50, @30];      //thoi gian tra loi (giay)

    _pageImages = @[@"af.png",@"ala.png",@"al.png",@"dz.png",@"as.png",@"ad.png",@"ao.png",@"ai.png",@"ag.png",@"ar.png",@"am.png",@"aw.png",@"au.png",@"at.png",@"az.png",@"bs.png",@"bh.png",@"bd.png",@"bb.png",@"by.png",@"be.png",@"bz.png",@"bj.png",@"bm.png",@"bt.png",@"bo.png",@"ba.png",@"bw.png",@"br.png",@"bri.png",@"vg.png",@"bn.png",@"bg.png",@"bf.png",@"mm.png",@"bi.png",@"kh.png",@"cm.png",@"ca.png",@"cv.png",@"ky.png",@"cf.png",@"td.png",@"cl.png",@"cn.png",@"chr.png",@"co.png",@"km.png",@"coo.png",@"cr.png",@"hr.png",@"cu.png",@"crc.png",@"cy.png",@"cz.png",@"cg.png",@"dk.png",@"dj.png",@"dm.png",@"dom.png",@"ec.png",@"eg.png",@"sv.png",@"gq.png",@"er.png",@"ee.png",@"et.png",@"fk.png",@"fo.png",@"fj.png",@"fi.png",@"fr.png",@"pf.png",@"gm.png",@"ga.png",@"ge.png",@"de.png",@"gh.png",@"gi.png",@"gr.png",@"gl.png",@"gd.png",@"gu.png",@"gt.png",@"gue.png",@"gn.png",@"gw.png",@"gy.png",@"ht.png",@"hn.png",@"hk.png",@"hu.png",@"is.png",@"in.png",@"id.png",@"ir.png",@"iq.png",@"ie.png",@"im.png",@"il.png",@"it.png",@"ci.png",@"jm.png",@"jp.png",@"je.png",@"jo.png",@"kz.png",@"ke.png",@"ki.png",@"kv.png",@"kw.png",@"kg.png",@"la.png",@"lv.png",@"lb.png",@"ls.png",@"lr.png",@"ly.png",@"li.png",@"lt.png",@"lu.png",@"mo.png",@"mk.png",@"mg.png",@"mw.png",@"my.png",@"mv.png",@"ml.png",@"mt.png",@"mh.png",@"mar.png",@"mr.png",@"mu.png",@"mx.png",@"fm.png",@"md.png",@"mc.png",@"mn.png",@"me.png",@"ms.png",@"ma.png",@"mz.png",@"na.png",@"nr.png",@"np.png",@"nl.png",@"net.png",@"nc.png",@"nz.png",@"ni.png",@"ne.png",@"ng.png",@"niue.png",@"nor.png",@"kp.png",@"norm.png",@"no.png",@"om.png",@"pk.png",@"pw.png",@"pal.png",@"pa.png",@"pg.png",@"py.png",@"pe.png",@"ph.png",@"pit.png",@"pl.png",@"pt.png",@"pr.png",@"qa.png",@"cd.png",@"ro.png",@"ru.png",@"rw.png",@"bl.png",@"sh.png",@"kn.png",@"lc.png",@"mf.png",@"pm.png",@"vc.png",@"ws.png",@"sm.png",@"st.png",@"sa.png",@"sn.png",@"rs.png",@"sc.png",@"sl.png",@"sg.png",@"sai.png",@"sk.png",@"si.png",@"sb.png",@"so.png",@"za.png",@"sou.png",@"kr.png",@"sos.png",@"es.png",@"lk.png",@"sd.png",@"sr.png",@"sva.png",@"sz.png",@"se.png",@"ch.png",@"sy.png",@"tw.png",@"tj.png",@"tz.png",@"th.png",@"tibet.png",@"tl.png",@"tg.png",@"tok.png",@"to.png",@"tt.png",@"tn.png",@"tr.png",@"tm.png",@"tc.png",@"tv.png",@"ug.png",@"ua.png",@"ae.png",@"gb.png",@"us.png",@"uy.png",@"uz.png",@"vu.png",@"va.png",@"ve.png",@"vn.png",@"vi.png",@"wal.png",@"wet.png",@"ye.png",@"zm.png",@"zw.png"];
    
    _arr_imglevels = @[@"zlevel0.png",@"zlevel1.png",@"zlevel2.png",@"zlevel3.png",@"zlevel4.png"];
    _timerValue = 0;
    _currentLevel = _levelID;
    _currentAdditionCounter = 0;
    _score = 0;
    _lives = 3;
    _imglevel.image = [UIImage imageNamed:[_arr_imglevels objectAtIndex:_currentLevel]];
    _timeLevel = [[_arr_times objectAtIndex:_currentLevel] intValue];
    _additionsPerLevel = [[_arr_asks objectAtIndex:_currentLevel] intValue];
    _maxItemCount = [_pageImages count];
    
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

- (void)playSoundFile:(NSString*)fileName {
    NSURL* musicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:@"caf"]];
    _audioPlayerZ  = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile  error:nil];
    [_audioPlayerZ setNumberOfLoops:0];
    [_audioPlayerZ play];
}

-(void)updateTimerLabel:(NSTimer *)timer{
    // Increase the timer value and set it to the lblTime label.
    _timerValue++;
    
    [_lbltime setText:[NSString stringWithFormat:@"%d", (_timeLevel-_timerValue)]];
    
    // If the timerValue value becomes greater than then end the game.
    if (_timerValue > _timeLevel) {
        // Show a "Time is Up" message.
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:NSLocalizedString(@"infor", nil)
                                     message:NSLocalizedString(@"TimeUp", nil)
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"OKZ", nil)
                                    style:UIAlertActionStyleDestructive
                                    handler:^(UIAlertAction * action)
                                    {
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        // Hide any unnecessary controls.
        [self resetGame];
    }
}


-(void)createAddition{
    // Generate two random integer numbers.
    int randomResult0 = arc4random() % _maxItemCount;
    
    //Set the flag
    _img.image = [UIImage imageNamed:[_pageImages objectAtIndex:randomResult0]];
    
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
    
    switch (_correctResult) {
        case 1:
            [_btt1 setTitle:[_pageNames objectAtIndex:randomResult0] forState:UIControlStateNormal];
            [_btt2 setTitle:[_pageNames objectAtIndex:randomResult1] forState:UIControlStateNormal];
            [_btt3 setTitle:[_pageNames objectAtIndex:randomResult2] forState:UIControlStateNormal];
            [_btt4 setTitle:[_pageNames objectAtIndex:randomResult3] forState:UIControlStateNormal];
            break;
        case 2:
            [_btt1 setTitle:[_pageNames objectAtIndex:randomResult1] forState:UIControlStateNormal];
            [_btt2 setTitle:[_pageNames objectAtIndex:randomResult0] forState:UIControlStateNormal];
            [_btt3 setTitle:[_pageNames objectAtIndex:randomResult2] forState:UIControlStateNormal];
            [_btt4 setTitle:[_pageNames objectAtIndex:randomResult3] forState:UIControlStateNormal];
            break;
        case 3:
            [_btt1 setTitle:[_pageNames objectAtIndex:randomResult1] forState:UIControlStateNormal];
            [_btt2 setTitle:[_pageNames objectAtIndex:randomResult2] forState:UIControlStateNormal];
            [_btt3 setTitle:[_pageNames objectAtIndex:randomResult0] forState:UIControlStateNormal];
            [_btt4 setTitle:[_pageNames objectAtIndex:randomResult3] forState:UIControlStateNormal];
            break;
        case 4:
            [_btt1 setTitle:[_pageNames objectAtIndex:randomResult1] forState:UIControlStateNormal];
            [_btt2 setTitle:[_pageNames objectAtIndex:randomResult2] forState:UIControlStateNormal];
            [_btt3 setTitle:[_pageNames objectAtIndex:randomResult3] forState:UIControlStateNormal];
            [_btt4 setTitle:[_pageNames objectAtIndex:randomResult0] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}


-(void)updateLevelLabel{
    // Increase the level counter by 1 and show it to the level label.
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:NSLocalizedString(@"infor", nil)
                                 message:NSLocalizedString(@"Mess_Success", nil)
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"OKZ", nil)
                                style:UIAlertActionStyleDestructive
                                handler:^(UIAlertAction * action)
                                {
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
    _currentLevel++;
    [self SaveData];
    _imglevel.image = [UIImage imageNamed:[_arr_imglevels objectAtIndex:_currentLevel]];
    _timeLevel = [[_arr_times objectAtIndex:_currentLevel] intValue];
    _additionsPerLevel = [[_arr_asks objectAtIndex:_currentLevel] intValue];

    [self initLives];

}

-(void)initLives{
    // Set the initial value to the lives property and make all images visible.
    _lives = 3;
    _imglive1.hidden = NO;
    _imglive2.hidden = NO;
    _imglive3.hidden = NO;
    _currentAdditionCounter = 0;
    _score = 0;
}

- (void)SaveData {
    NSString *strKey = [NSString stringWithFormat:@"LEVEL%ld",_currentLevel];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"1" forKey:strKey];
}

@end
