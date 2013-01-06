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
@synthesize videoImageView;

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
    NSLog(@"!!!!!!!!!!!!!!!%@",newVideoContent);
     [super.navigationController setNavigationBarHidden:YES animated:TRUE];
    isflage=YES;
    //先给videoimageview一个旋转轮，然后再给它赋值照片
    videoImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image_back.png"]];
    
    //下载视频图片
    DownImage *newDown=[[DownImage alloc]init];
    NSString *image_path=[newVideoContent.videoPath stringByReplacingOccurrencesOfString:@".m3u8" withString:@".jpg"];
    newDown.imageUrl=[NSString stringWithFormat: @"http://teacher.sfls.cn/sflsapp/video/movie/images/%@",image_path];
    [newDown setDelegate:self];
    [newDown startDownload];
    
    videoName.text=newVideoContent.videoName;
    videoInfo.text=newVideoContent.videoInfo;
    if ([newVideoContent.videoInfo isEqualToString:@"(null)"]) {
        newVideoContent.videoInfo=@"抱歉，暂无该视频介绍！";
        NSLog(@"没有介绍");
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if ([UIScreen mainScreen].bounds.size.height==568.f) {//iphone5
            NSLog(@"this is iphone5");
            UIImageView *videobackImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"videoback_iphone.png"]];
            videobackImageView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 90, 165, 30)];
            CGAffineTransform ro=CGAffineTransformMakeRotation(-M_PI/9);
            [titleLabel setTransform:ro];
            titleLabel.text=self.title;
            titleLabel.backgroundColor=[UIColor clearColor];
            [titleLabel setTextAlignment:UITextAlignmentCenter];
            
            UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 150, 250, 180)];
            contentLabel.text=newVideoContent.videoInfo;
            [contentLabel setLineBreakMode:UILineBreakModeWordWrap];
            contentLabel.numberOfLines=5;
            [contentLabel setBackgroundColor:[UIColor clearColor]];
            int scaleimage=20;
            videoImageView.frame=CGRectMake(20, 310, 6.85*scaleimage, 5.18*scaleimage);
            UIActivityIndicatorView *downLoadingIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            downLoadingIndicator.frame=CGRectMake(6.5*scaleimage/2-10, 5.18*scaleimage/2-10, 20, 20);
            [downLoadingIndicator startAnimating];
            [videoImageView addSubview:downLoadingIndicator];
            UIButton *viewButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            [viewButton setTitle:@"点击观看" forState:UIControlStateNormal];
            viewButton.frame=CGRectMake(165, 423, 90, 30);
            [viewButton setTransform:ro];
            [viewButton addTarget:self action:@selector(clickToPlay:) forControlEvents:UIControlEventTouchUpInside];
            
            [[self.view viewWithTag:1] addSubview:videobackImageView];
            [self.view addSubview:titleLabel];
            [self.view addSubview:contentLabel];
            [self.view addSubview:viewButton];
            [self.view addSubview:videoImageView];
        }
        else
        {//iphone4
            UIImageView *videobackImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"videoback_iphone.png"]];
            videobackImageView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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
            int scaleimage=20;
            videoImageView.frame=CGRectMake(20, 310, 6.85*scaleimage, 5.18*scaleimage);
            UIActivityIndicatorView *downLoadingIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            downLoadingIndicator.frame=CGRectMake(6.5*scaleimage/2-10, 5.18*scaleimage/2-10, 20, 20);
            [downLoadingIndicator startAnimating];
            [videoImageView addSubview:downLoadingIndicator];
            UIButton *viewButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            [viewButton setTitle:@"点击观看" forState:UIControlStateNormal];
            viewButton.frame=CGRectMake(165, 353, 90, 30);
            [viewButton setTransform:ro];
            [viewButton addTarget:self action:@selector(clickToPlay:) forControlEvents:UIControlEventTouchUpInside];
    
            [[self.view viewWithTag:1] addSubview:videobackImageView];
            [self.view addSubview:titleLabel];
            [self.view addSubview:contentLabel];
            [self.view addSubview:viewButton];
            [self.view addSubview:videoImageView];
            }
    }
    else{
        UIImageView *videobackImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"videoback_ipad.png"]];
       videobackImageView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
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
        
        /*
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
         */
        int scaleimage=40;
        videoImageView.frame=CGRectMake(80, 700, 6.85*scaleimage, 5.18*scaleimage);
        UIActivityIndicatorView *downLoadingIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        downLoadingIndicator.frame=CGRectMake(6.5*scaleimage/2-10, 5.18*scaleimage/2-10, 20, 20);
        [downLoadingIndicator startAnimating];
        [videoImageView addSubview:downLoadingIndicator];
        
        UIButton *viewButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [viewButton setTitle:@"点击观看" forState:UIControlStateNormal];
        viewButton.frame=CGRectMake(405, 770, 180, 55);
        [viewButton setTransform:ro];
        [viewButton addTarget:self action:@selector(clickToPlay:) forControlEvents:UIControlEventTouchUpInside];
        [viewButton setFont:[UIFont systemFontOfSize:40]];
        
       
        [self.view addSubview:videobackImageView];
        
        [self.view addSubview:contentLabel];
        [self.view addSubview:viewButton];
        [self.view addSubview:titleLabel];
        [self.view addSubview:videoImageView];
    }
    UIBarButtonItem *goToComment=[[UIBarButtonItem alloc]initWithTitle:@"评论" style:UIBarButtonItemStyleBordered target:self action:@selector(goComment)];
    
    self.navigationItem.rightBarButtonItem=goToComment;
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

-(void)goComment{
    [self performSegueWithIdentifier:@"goComment" sender:self];
    //[self.navigationController pushViewController:newComment animated:YES];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    videoComment *newComment=[segue destinationViewController];
    newComment.thenewVideoContent=self.newVideoContent;
}

#pragma downloadimage protacal
-(void)appImageDidLoad:(NSInteger)indexTag urlImage:(NSString *)imageUrl imageName:(NSString *)imageName{
    UIImageView *newImageView=[[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:imageUrl]];
    NSLog(@"this is download image address %@",imageUrl);
    
     if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    newImageView.frame=CGRectMake(videoImageView.frame.origin.x+8 , videoImageView.frame.origin.y+8, videoImageView.frame.size.width-18, videoImageView.frame.size.height-24);
     }
     else{
    newImageView.frame=CGRectMake(videoImageView.frame.origin.x+17 , videoImageView.frame.origin.y+17, videoImageView.frame.size.width-34, videoImageView.frame.size.height-47);
     }
    newImageView.layer.opacity=0;
    [self.view addSubview:newImageView];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    newImageView.layer.opacity=1;
    [UIView commitAnimations];
    
}
@end
