//
//  AVTESTViewController.m
//  AVTEST
//
//  Created by 皓斌 朱 on 12-1-31.
//  Copyright 2012年 sfls. All rights reserved.
//

#import "AVTESTViewController.h"

@implementation AVTESTViewController
@synthesize auidioPlayer,moviePlayer,webData,soapResults;
@synthesize bigClassList,smallClassList,VideoList,xmlDocument;
#pragma theXmlParser
-(void)xmlDocumentDelegateParsingFinished:(XMLDocument *)paramSender{
    NSArray *temparray=self.xmlDocument.rootElement.children;
    XMLelement *tempelement=[temparray objectAtIndex:1];
    NSLog(@"Parser finish the first data is %@",tempelement.text);
    
    self.bigClassList=self.xmlDocument.rootElement.children;
    
    

}
-(void)xmlDocumentDelegateParsingFailed:(XMLDocument *)paramSender withError:(NSError *)paramError{
    NSLog(@"Parse xml failed");
}
#pragma theLifeCircle
-   (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"audio finished");
    if ([player isEqual:self.auidioPlayer]==YES) {
        self.auidioPlayer = nil;
    }
    else
    {
        [player release];
    }
}
-   (void)startPlayingAudio{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
    NSBundle *mainBundle=[NSBundle mainBundle];
    NSString *filePath=[mainBundle pathForResource:@"anotherday" ofType:@"mp3"];
    NSError *error=nil;
    NSData *fileData=[NSData dataWithContentsOfFile:filePath];
    AVAudioPlayer *newPlayer=[[AVAudioPlayer alloc]initWithData:fileData error:&error];
    self.auidioPlayer=newPlayer;
    [ newPlayer release];
    if (self.auidioPlayer!=nil) {
        self.auidioPlayer.delegate=self;
        if ([self.auidioPlayer prepareToPlay]==YES) {
            NSLog(@"prepare to play");
            [self.auidioPlayer play];
        }
        else
        {
            NSLog(@"notprepare to play");
        }
    }else
    {
        NSLog(@"fail to play");
    }
    [pool release];
}
-   (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *xmlPath=@"http://teacher.sfls.cn/sflsapp/video/creatVideo.asp?query=bigclass";
    
    XMLDocument *newDocument=[[XMLDocument alloc]initWithDelegate:self];
    self.xmlDocument=newDocument;
    [newDocument release];
    [self.xmlDocument parseRemoteXMLWithURL:xmlPath];
    //[NSThread detachNewThreadSelector:@selector(startPlayingAudio) toTarget:self withObject:nil];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
    //return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    //以上为永远停留在landscapemode
}
-(IBAction)startPlayingVideo:(id)paramSender{
    NSBundle *mainBundle=[NSBundle mainBundle];
    NSString *urlAsString=[mainBundle pathForResource:@"standford" ofType:@"mp4"];
    NSURL *url=[NSURL fileURLWithPath:urlAsString];
    if (self.moviePlayer!=nil) {
        [self stopPlayingVideo:nil];
    }
    MPMoviePlayerController *newMoviePlayer=[[MPMoviePlayerController alloc]initWithContentURL:url];
    self.moviePlayer=newMoviePlayer;
    [newMoviePlayer release];
    if (self.moviePlayer!=nil) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(videoHasFinishedPlaying:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
        NSLog(@"Successfully instantiated the movie player.");
        [self.moviePlayer play];
        [self.view addSubview:self.moviePlayer.view];
        //self.moviePlayer.view.frame=CGRectMake(320, 0, 320 , 480);
        [self.moviePlayer setFullscreen:YES animated:YES];
    }
    else{
        NSLog(@"failed to instantiate the movie player");
    }
   
}


-(IBAction)stopPlayingVideo:(id)paramSender;{
    if (self.moviePlayer!=nil) {
        [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
        [self.moviePlayer stop];
        [self.moviePlayer.view removeFromSuperview];
    }
}
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
- (IBAction) playURLVideo

{
    
    NSString *videoPath =@"http://teacher.sfls.cn/sflsapp/2010NWbimushi.mp4";
    
    
    if (videoPath == NULL)
        
        return;
    
    
    
    [self initAndPlay:videoPath];
    
    
    
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
        NSLog(@"Finish Reason = %ld", (long)reasonAsInteger);
        [self stopPlayingVideo:nil]; } /* if (reason != nil){ */
}
- (void)askForSoapRequest
{
    NSAutoreleasePool *pool1=[[NSAutoreleasePool alloc]init];
    //recordResults = NO;
    //封装soap请求消息
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getBigClassName xmlns=\"http://www.Nanonull.com/TimeService/\">\n"
                             "<requireType>className</requireType>\n"
                             "</getBigClassName>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n"
                             ];
    //NSLog(@"%@",soapMessage);
    //请求发送到的路径
    NSURL *url = [NSURL URLWithString:@"http://teacher.sfls.cn/sflsapp/video/creatVideo.asp?query=bigclass"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    //以下对请求信息添加属性前四句是必有的，第五句是soap信息。
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"" forHTTPHeaderField:@"SOAPAction"];
    
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
   
    //请求
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self startImmediately:YES];
    //如果连接已经建好，则初始化data
    if( theConnection )
    {
        webData = [[NSMutableData data] retain];
        NSLog(@"there is a connection");
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
    
    [pool1 release];
}//不能通过调用进程的方法来实现，至于为什么，还不知道



-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [webData setLength: 0];
    NSLog(@"connection: didReceiveResponse:1");
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
    NSLog(@"connection: didReceiveData:2");
    
}
//如果电脑没有连接网络，则出现此信息（不是网络服务器不通）
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR with theConenction");
    //[connection release];
    //[webData release];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"3 DONE. Received Bytes: %d,the data is ", [webData length]);
    NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"%@",theXML);
}
- (IBAction)sentMessage:(id)sender {
    //[NSThread detachNewThreadSelector:@selector(askForSoapRequest) toTarget:self withObject:nil];
    //[NSThread detachNewThreadSelector:@selector(askForSoapRequest) toTarget:self withObject:nil];
    //recordResults = NO;
    //封装soap请求消息
    NSString *soapMessage = [NSString stringWithFormat:
                             @//"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             //"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Envelope xmlns:soap=\"urn:schemas-xmlsoap-org:soap.v1\">"
                             "<soap:Body>\n"
                             "<getBigClassName>\n"
                             "<requireType>bigClass</requireType>\n"
                             "</getBigClassName>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n"
                             ];
    NSLog(@"%@",soapMessage);
    //请求发送到的路径
    NSURL *url = [NSURL URLWithString:@"http://teacher.sfls.cn/sflsapp/video/creatvideo.asp?query=bigclass"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    //以下对请求信息添加属性前四句是必有的，第五句是soap信息。
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"" forHTTPHeaderField:@"SOAPAction"];
    
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //请求
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self startImmediately:YES];
    //如果连接已经建好，则初始化data
    if( theConnection )
    {
        webData = [[NSMutableData data] retain];
        NSLog(@"there is a connection");
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }


}


#pragma tableView

@end








