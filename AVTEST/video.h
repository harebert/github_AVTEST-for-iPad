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
@interface video : UIViewController {
    UILabel *videoName;
    UITextView *videoInfo;
    videoContent *newVideoContent;
    MPMoviePlayerController *moviePlayer;
    BOOL isflage;
}
- (IBAction)clickToPlay:(id)sender;
@property (nonatomic, retain) IBOutlet UITextView *videoInfo;
@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;
@property (nonatomic, retain) IBOutlet UILabel *videoName;
@property (nonatomic, retain)videoContent *newVideoContent;
@end
