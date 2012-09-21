//
//  video.m
//  AVTEST
//
//  Created by 皓斌 朱 on 12-2-3.
//  Copyright 2012年 sfls. All rights reserved.
//

#import "video.h"

@implementation video
@synthesize videoInfo;
@synthesize videoName,newVideoContent;
@synthesize moviePlayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
     [super.navigationController setNavigationBarHidden:YES animated:TRUE];
    isflage=YES;
    
    videoName.text=newVideoContent.videoName;
    videoInfo.text=newVideoContent.videoInfo;
    if ([newVideoContent.videoInfo isEqualToString:@"(null)"]) {
        newVideoContent.videoInfo=@"抱歉，暂无该视频介绍！";
        NSLog(@"没有介绍");
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        UIImageView *videobackImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"videoback_iphone.png"]];
        videobackImageView.frame=self.view.frame;//CGRectMake(0, 0, 320, 480);
    
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 70, 165, 30)];
        CGAffineTransform ro=CGAffineTransformMakeRotation(-M_PI/10.5);
        [titleLabel setTransform:ro];
        titleLabel.text=self.title;
        titleLabel.backgroundColor=[UIColor clearColor];
        [titleLabel setTextAlignment:UITextAlignmentCenter];
    
        UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 150, 250, 180)];
        contentLabel.text=newVideoContent.videoInfo;
        [contentLabel setLineBreakMode:UILineBreakModeWordWrap];
        contentLabel.numberOfLines=5;
        [contentLabel setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image_back.png"]];
        imageView.backgroundColor=[UIColor clearColor];
        int scaleimage=20;
        imageView.frame=CGRectMake(20, 310, 6.85*scaleimage, 5.18*scaleimage);
        NSString *image_path=[newVideoContent.videoPath stringByReplacingOccurrencesOfString:@".m3u8" withString:@".jpg"];
        NSLog(@"data:%@",image_path);
        NSData *image_data=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://teacher.sfls.cn/sflsapp/video/movie/images/%@",image_path]]];
        UIImage *video_image=[UIImage imageWithData:image_data];
        UIImageView *video_image_view=[[UIImageView alloc]initWithImage:video_image];
        video_image_view.frame=CGRectMake(8, 8, 6.01*scaleimage, 4.01*scaleimage);
        [imageView addSubview:video_image_view];
        
        
        UIButton *viewButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [viewButton setTitle:@"点击观看" forState:UIControlStateNormal];
        viewButton.frame=CGRectMake(165, 353, 90, 30);
        [viewButton setTransform:ro];
        [viewButton addTarget:self action:@selector(clickToPlay:) forControlEvents:UIControlEventTouchUpInside];
    
        [self.view addSubview:videobackImageView];
        [self.view addSubview:titleLabel];
        [self.view addSubview:contentLabel];
        [self.view addSubview:viewButton];
        [self.view addSubview:imageView];
    }
    else{
        UIImageView *videobackImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"videoback_ipad.png"]];
        videobackImageView.frame=self.view.frame;//CGRectMake(0, 0, 320, 480);
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(180, 130, 335, 80)];
        CGAffineTransform ro=CGAffineTransformMakeRotation(-M_PI/30);
        [titleLabel setTransform:ro];
        titleLabel.text=self.title;
        [titleLabel setFont:[UIFont systemFontOfSize:40]];
        titleLabel.backgroundColor=[UIColor clearColor];
        [titleLabel setTextAlignment:UITextAlignmentCenter];
        
        UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(180, 290, 450, 400)];
        contentLabel.text=newVideoContent.videoInfo;
        [contentLabel setLineBreakMode:UILineBreakModeWordWrap];
        contentLabel.numberOfLines=5;
        [contentLabel setBackgroundColor:[UIColor clearColor]];
        [contentLabel setFont:[UIFont systemFontOfSize:30]];
        
        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image_back.png"]];
        imageView.backgroundColor=[UIColor clearColor];
        int scaleimage=40;
        imageView.frame=CGRectMake(80, 700, 6.85*scaleimage, 5.18*scaleimage);
        NSString *image_path=[newVideoContent.videoPath stringByReplacingOccurrencesOfString:@".m3u8" withString:@".jpg"];
        NSLog(@"data:%@",image_path);
        NSData *image_data=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://teacher.sfls.cn/sflsapp/video/movie/images/%@",image_path]]];
        UIImage *video_image=[UIImage imageWithData:image_data];
        UIImageView *video_image_view=[[UIImageView alloc]initWithImage:video_image];
        video_image_view.frame=CGRectMake(17, 17, 6.01*scaleimage, 4.01*scaleimage);
        [imageView addSubview:video_image_view];

        
        UIButton *viewButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [viewButton setTitle:@"点击观看" forState:UIControlStateNormal];
        viewButton.frame=CGRectMake(405, 770, 180, 55);
        [viewButton setTransform:ro];
        [viewButton addTarget:self action:@selector(clickToPlay:) forControlEvents:UIControlEventTouchUpInside];
        [viewButton setFont:[UIFont systemFontOfSize:40]];
        
        [self.view addSubview:videobackImageView];
        [self.view addSubview:titleLabel];
        [self.view addSubview:contentLabel];
        [self.view addSubview:viewButton];
        [self.view addSubview:imageView];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setVideoName:nil];
    [self setVideoInfo:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)dealloc {
    [videoName release];
    [videoInfo release];
    [super dealloc];
}
#pragma playing Movie
-(void)initAndPlay:(NSString *)videoURL

{
    
    if ([videoURL rangeOfString:@"http://"].location!=NSNotFound||[videoURL rangeOfString:@"https://"].location!=NSNotFound) 
        
    {
        
        NSURL *URL = [[NSURL alloc] initWithString:videoURL];
        
        if (URL) {
            MPMoviePlayerController* tmpMoviePlayViewController=[[MPMoviePlayerController alloc] initWithContentURL:URL];
            
            if (tmpMoviePlayViewController)
                
            {
                
                self.moviePlayer=tmpMoviePlayViewController;
                [self.moviePlayer play];
                [self.view addSubview:self.moviePlayer.view];
                [self.moviePlayer setFullscreen:YES animated:YES];
                
            }
            
            [tmpMoviePlayViewController release];    
            
            
            
            
            
            
            //视频播放完成通知
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(videoHasFinishedPlaying:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
            
        }
        
        [URL release];
        
    }
    
}
-(IBAction)stopPlayingVideo:(id)paramSender;{
    if (self.moviePlayer!=nil) {
        [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
        [self.moviePlayer stop];
        [self.moviePlayer.view removeFromSuperview];
    }
}
- (void) videoHasFinishedPlaying:(NSNotification *)paramNotification{
    /* Find out what the reason was for the player to stop */ NSNumber *reason =
    [paramNotification.userInfo
     valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    if (reason != nil){
        NSInteger reasonAsInteger = [reason integerValue];
        switch (reasonAsInteger){
            case MPMovieFinishReasonPlaybackEnded:{
                /* The movie ended normally */
                break; }
            case MPMovieFinishReasonPlaybackError:{
                /* An error happened and the movie ended */
                break; }
            case MPMovieFinishReasonUserExited:{ /* The user exited the player */
                break; }
        }
        //[self.moviePlayer.view removeFromSuperview];
        NSLog(@"Finish Reason = %ld", (long)reasonAsInteger);
        [self stopPlayingVideo:nil]; } /* if (reason != nil){ */
}

- (IBAction)clickToPlay:(id)sender {
    NSString *url=@"http://teacher.sfls.cn/sflsapp/video/Movie/";
    NSString *videoPath =[NSString stringWithFormat:@"%@%@",url,self.newVideoContent.videoPath];    
    
    if (videoPath == NULL)
        
        return;
    
    
    
    [self initAndPlay:videoPath];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    isflage=!isflage;
    [super.navigationController setNavigationBarHidden:isflage animated:TRUE];
    //[super.navigationController setToolbarHidden:isflage animated:TRUE];
}
@end
