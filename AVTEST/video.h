//
//  video.h
//  AVTEST
//
//  Created by 皓斌 朱 on 12-2-3.
//  Copyright 2012年 sfls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "videoContent.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "videoComment.h"
#import "DownImage.h"
#import <QuartzCore/QuartzCore.h>
@interface video : UIViewController <DownloaderDelegate>{
    UILabel *videoName;
    UITextView *videoInfo;
    videoContent *newVideoContent;
    MPMoviePlayerController *moviePlayer;
    BOOL isflage;
    UIImageView *videoImageView;
}
- (IBAction)clickToPlay:(id)sender;
@property (nonatomic, retain) IBOutlet UITextView *videoInfo;
@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;
@property (nonatomic, retain) IBOutlet UILabel *videoName;
@property (nonatomic, retain)videoContent *newVideoContent;
@property (nonatomic, retain) UIImageView *videoImageView;
@end
