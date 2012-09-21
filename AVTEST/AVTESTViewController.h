//
//  AVTESTViewController.h
//  AVTEST
//
//  Created by 皓斌 朱 on 12-1-31.
//  Copyright 2012年 sfls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "XMLelement.h"
#import "XMLDocument.h"

@interface AVTESTViewController : UIViewController<AVAudioPlayerDelegate,UITableViewDelegate,UITableViewDataSource,XMLDocumentDelegate>{
    @public
    XMLDocument *xmlDocument;
    AVAudioPlayer *audioPlayer;
    MPMoviePlayerController *moviePlayer;
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSArray *bigClassList;
    NSArray *smallClassList;
    NSArray *VideoList;
    
}
- (IBAction)sentMessage:(id)sender;

@property(nonatomic,retain) AVAudioPlayer *auidioPlayer;
@property(nonatomic,retain) MPMoviePlayerController *moviePlayer;
@property(nonatomic,retain)NSMutableData *webData;
@property(nonatomic,retain)NSMutableString *soapResults;
@property(nonatomic,retain)NSArray *bigClassList;
@property(nonatomic,retain)NSArray *smallClassList;
@property(nonatomic,retain)NSArray *VideoList;
@property(nonatomic,retain)XMLDocument *xmlDocument;
-(IBAction)startPlayingVideo:(id)paramSender;
-(IBAction)stopPlayingVideo:(id)paramSender;
- (IBAction) playURLVideo;
- (void)askForSoapRequest;
@end
