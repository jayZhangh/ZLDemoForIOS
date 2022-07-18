//
//  PlayerViewController.m
//  ZLDemo
//
//  Created by ZhangLiang on 2022/7/16.
//

#import "PlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

#define kPlayerURL @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"

@interface PlayerViewController ()
{
    NSInteger _seekTime;
}

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLab;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVURLAsset *urlAsset;
@property (weak, nonatomic) IBOutlet UIProgressView *playProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *bufferProgressView;

- (IBAction)playAction:(id)sender;
- (IBAction)pauseAction:(id)sender;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _seekTime = 0;
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    [headers setObject:@"yourHeader" forKey:@"User-Agent"];
    
    self.urlAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:kPlayerURL] options:@{@"AVURLAssetHTTPHeaderFieldsKey": headers}];
    
//    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:kPlayerURL]];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.playerView.bounds;
    [self.playerView.layer addSublayer:self.playerLayer];
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerMovieFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    
    __weak typeof(self) wekself = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time) {
        if (wekself.playerItem.currentTime.timescale != 0) {
            NSInteger currentTime = wekself.playerItem.currentTime.value / wekself.playerItem.currentTime.timescale;
            NSLog(@"当前播放时间: %ld", currentTime);
            [wekself.playProgressView setProgress:currentTime / CMTimeGetSeconds(wekself.playerItem.duration) animated:YES];
            wekself.currentTimeLab.text = [NSString stringWithFormat:@"%ld", currentTime];
        }
    }];
    
    [self pauseAction:self.pauseBtn];
}

- (void)playerMovieFinish:(NSNotification *)note {
    NSLog(@"%@", note);
    [self.pauseBtn setTitle:@"重新开始" forState:UIControlStateNormal];
    self.pauseBtn.selected = YES;
}

- (IBAction)pauseAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.player pause];
        [sender setTitle:@"播放" forState:UIControlStateNormal];
    } else {
        [self.player play];
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
    }
}

- (IBAction)playAction:(id)sender {
    float currentTime = self.playerItem.currentTime.value / self.playerItem.currentTime.timescale;
    float totleTime = CMTimeGetSeconds(self.playerItem.duration);
    NSLog(@"%f - %f", currentTime, totleTime);
    [self.player seekToTime:CMTimeMake(_seekTime += 10, 1)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        if ([keyPath isEqualToString:@"status"]) {
            switch ([self.playerItem status]) {
                case AVPlayerItemStatusReadyToPlay:
                    NSLog(@"AVPlayerItemStatusReadyToPlay");
                    self.totalTimeLab.text = [NSString stringWithFormat:@"/%ld", (NSInteger)CMTimeGetSeconds(self.playerItem.duration)];
                    break;
                case AVPlayerItemStatusUnknown:
                    NSLog(@"AVPlayerItemStatusUnknown");
                case AVPlayerItemStatusFailed:
                    NSLog(@"AVPlayerItemStatusFailed");
                default:
                    break;
            }
        }
        
        if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            NSArray *array = self.playerItem.loadedTimeRanges;
            // 本次缓存时间范围
            CMTimeRange timeRange = [[array firstObject] CMTimeRangeValue];
            float startSeconds = CMTimeGetSeconds(timeRange.start);
            float durationSeconds = CMTimeGetSeconds(timeRange.duration);
            NSTimeInterval totalBuffer = startSeconds + durationSeconds;
            NSLog(@"当前缓存时间: %f", totalBuffer);
            [self.bufferProgressView setProgress:totalBuffer / CMTimeGetSeconds(self.playerItem.duration) animated:YES];
        }
        
        if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            NSLog(@"playbackBufferEmpty");
        }
        
        if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            // 由于AVPlayer缓存不足就会自动暂停，所以缓存充足了需要手动播放，才能继续播放 [_player play]
//            [self.player play];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
}

@end
