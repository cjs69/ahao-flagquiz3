//utf-8;13421798484troller.m
//  Behocvui
//
//  Created by XuanHao on 6/16/14.
//  Copyright (c) 2014 VIETKIDGAME. All rights reserved.
//

#import "VKGCVController.h"
#import "VKGTopicViewController.h"
#import <AudioToolbox/AudioToolbox.h> 
#import <AVFoundation/AVFoundation.h>

@interface VKGCVController () {
    NSArray *imglist;
    NSArray *titlelist;
    NSArray *strexCf;
    NSArray *strexTitle;
    NSArray *strexOK;
    NSArray *strexCancel;
    AVAudioPlayer *audioPlayer;
}
@end

@implementation VKGCVController

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

    //NSString *strfile= @"bgmusic";
    //[self playSoundFile:strfile];
    
    imglist = [NSArray arrayWithObjects:@"zeurope.png", @"zasia.png", @"zafrica.png", @"zamericas.png", @"zocean.png", @"zworld.png", nil];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Datalist" ofType:@"plist"];
    NSDictionary * words = [NSDictionary dictionaryWithContentsOfFile:path];
    titlelist = [words objectForKey:@"continent"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imglist.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *topicImageView = (UIImageView *)[cell viewWithTag:100];
    topicImageView.image = [UIImage imageNamed:[imglist objectAtIndex:indexPath.row]];
    
    UILabel *tpLabel = (UILabel *)[cell viewWithTag:200];
    tpLabel.text = [titlelist objectAtIndex:indexPath.row];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"topicPhoto"]) {
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        VKGTopicViewController *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        destViewController.topicID = indexPath.row;
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
    [audioPlayer pause];
}

- (void)playSoundFile:(NSString*)fileName {
    NSURL* musicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:@"mp3"]];
    audioPlayer  = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile  error:nil];
    [audioPlayer setNumberOfLoops:-1];
    [audioPlayer play];
}

- (IBAction)returnedFromSegue:(UIStoryboardSegue *)segue {
    [audioPlayer play];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
