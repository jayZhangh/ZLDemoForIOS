//
//  PlayerViewController.m
//  ZLDemo
//
//  Created by ZhangLiang on 2022/7/16.
//

#import "PlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayerViewController ()

@property (weak, nonatomic) IBOutlet UIView *playerView;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"]];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = self.playerView.bounds;
    [self.playerView.layer addSublayer:playerLayer];
    [player play];
}

@end
