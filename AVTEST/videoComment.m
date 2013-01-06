//
//  videoComment.m
//  附中视频推送
//
//  Created by 朱 皓斌 on 12-10-18.
//  Copyright (c) 2012年 sfls. All rights reserved.
//

#import "videoComment.h"

@interface videoComment ()

@end

@implementation videoComment
@synthesize thenewVideoContent,xmlDocument,commentArray,username;

-(void)xmlDocumentDelegateParsingFinished:(XMLDocument *)paramSender{
    commentArray=[[NSMutableArray alloc]init];
    commentArray= self.xmlDocument.rootElement.children;
    NSLog(@"%@",[commentArray componentsJoinedByString:@"|"]);
    [commentTableView2 reloadData];
    
}



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
    self.title=@"评论";
    username=[[NSString alloc]init];
    //parse the xml file
    NSString *xmlPath=[NSString stringWithFormat: @"http://teacher.sfls.cn/sflsapp/video/list_comment.asp?bigclass=%@&smallclass=%@&videoname=%@",thenewVideoContent.bigClassName,thenewVideoContent.smallClassName,thenewVideoContent.videoName];
    NSLog(@"%@",xmlPath);
    XMLDocument *newDocument=[[XMLDocument alloc]initWithDelegate:self];
    self.xmlDocument=newDocument;
    [self.xmlDocument parseRemoteXMLWithURL:xmlPath];
    
    //NSLog(@"%@",self.thenewVideoContent);
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

    //
    float x1,y1,w1,h1,x2,y2,w2,h2,x3,y3,w3,h3,x4,y4,w4,h4;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if ([UIScreen mainScreen].bounds.size.height==568.f) {//iphone5
            x1=0;
            y1=376+88;
            w1=320;
            h1=40;
            x2=0;
            y2=20;
            w2=320;
            h2=367+88;
            x3=5;
            y3=5;
            w3=230;
            h3=30;
            x4=250;
            y4=5;
            w4=50;
            h4=30;

        }
        else{
        x1=0;
        y1=376;
        w1=320;
        h1=40;
        x2=0;
        y2=20;
        w2=320;
        h2=367;
        x3=5;
        y3=5;
        w3=230;
        h3=30;
        x4=250;
        y4=5;
        w4=50;
        h4=30;
        }
    }
    else{
        
        x1=0;
        y1=902;
        w1=768;
        h1=40;
        x2=20;     
        y2=0;
        w2=768;
        h2=1024-64-40;
        x3=5;
        y3=5;
        w3=230;
        h3=30;
        x4=250;
        y4=5;
        w4=50;
        h4=30;
        
    }
    //commentTableView=[[UITableViewController alloc]init];
    //commentTableView2=[[UITableView alloc]init];
    commentTableView2.frame=CGRectMake(x2, y2, w2, h2);
    [commentTableView2 setDelegate:self];
    [commentTableView2 setDataSource:self];
    //[self.view addSubview:commentTableView2];
    
    commentTextBack=[[UIView alloc]initWithFrame:CGRectMake(x1, y1, w1, h1)];
    commentTextBack.backgroundColor=[UIColor underPageBackgroundColor];
        
    commentText=[[UITextField alloc]initWithFrame:CGRectMake(x3,y3, w3,h3)];
    [commentText setBorderStyle:UITextBorderStyleRoundedRect];
    [commentText setDelegate:self];
    [commentText setClearButtonMode:UITextFieldViewModeUnlessEditing];
    UIButton *submitButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitButton.frame=CGRectMake(x4, y4,w4, h4);
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(commentSubmit) forControlEvents:UIControlEventTouchUpInside];
    
    
    [commentTextBack addSubview:submitButton];
    [commentTextBack addSubview:commentText];
    
    [self.view addSubview:commentTableView2];
    [self.view addSubview:commentTextBack];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    

}
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
        //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
#endif
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_2
            NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
#else
            NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey];
#endif
            CGRect keyboardBounds;
            [keyboardBoundsValue getValue:&keyboardBounds];
            //UIEdgeInsets e = UIEdgeInsetsMake(0, 0, keyboardBounds.size.height, 0);
            //[keyboardScrollView setScrollIndicatorInsets:e];
            //[keyboardScrollView setContentInset:e];
            NSInteger offset;
             if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                 offset = 104;
             }
             else{
                 offset = 104;             }
            [UIView beginAnimations:@"anim" context:NULL];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.3];
            //处理移动事件，将各视图设置最终要达到的状态
            
            commentTextBack.frame=CGRectMake(commentTextBack.frame.origin.x, keyboardBounds.origin.y-offset, commentTextBack.frame.size.width, commentTextBack.frame.size.height);
            NSLog(@"keybordheight%f",keyboardBounds.origin.y);
            
            
            [UIView commitAnimations];
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
        //}
#endif
    
}

-(void)commentSubmit{
    
    
    NSLog(@"%@",commentText.text);
    if (commentText.text.length==0) {
        UIAlertView *newAlertView=[[UIAlertView alloc]initWithTitle:@"错误" message:@"请输入评论后提交！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [newAlertView show];
    }
    else{
        //弹出对话框要求输入名字
        UIAlertView *usernameAlert=[[UIAlertView alloc]initWithTitle:@"请输入姓名" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [usernameAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [usernameAlert textFieldAtIndex:0].text=username;
        //[usernameAlert setTitle:@"请输入姓名"];
        [usernameAlert show];
        
    }
    

}

#pragma tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%i",[commentArray count]);
    return [self.commentArray count];
    
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"commentCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
       // cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //[cell setSelectionStyle:UITableViewCellEditingStyleNone];//设置不被选中
    
        XMLelement *newXMlElement;
        newXMlElement=[self.commentArray objectAtIndex:[indexPath row]];
        XMLelement *commentElement;
        commentElement=[newXMlElement.children objectAtIndex:0];
        XMLelement *usernameElement;
        usernameElement=[newXMlElement.children objectAtIndex:1];
        UILabel *newLabel1=(UILabel *)[cell viewWithTag:1];
        UILabel *newLabel2=(UILabel *)[cell viewWithTag:2];
    
        newLabel1.text=[NSString stringWithFormat:@"-%@",commentElement.text];
        newLabel2.text=[NSString stringWithFormat:@"by:%@",usernameElement.text];
        
        NSLog(@"asdfasdfasdfasdf%@",commentElement.text);
        //[tempelement release];
    cell.backgroundColor=[UIColor blackColor];
        return cell;

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [commentText resignFirstResponder];
}

#pragma alertview
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField *newTextField=[[alertView textFieldAtIndex:0] retain];
    username=[newTextField.text retain];
    if ([alertView.title isEqualToString:@"请输入姓名"] && buttonIndex==0) {
        
        if ([alertView textFieldAtIndex:0].text.length==0)
        {
            UIAlertView *newAlertView=[[UIAlertView alloc]initWithTitle:@"错误" message:@"请一定填写姓名" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [newAlertView show];
        }
        else
        {
            
            NSLog(@"现在第一次输入username %@",username);
            NSString *url=[[NSString stringWithFormat:@"http://teacher.sfls.cn/sflsapp/video/post_comment.asp?comment=%@&user=%@&bigclass=%@&smallclass=%@&videoname=%@",commentText.text,[alertView textFieldAtIndex:0].text,thenewVideoContent.bigClassName,thenewVideoContent.smallClassName,thenewVideoContent.videoName]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //NSLog(@"%@",url);
            //NSString *url=[NSString stringWithFormat:@"http://teacher.sfls.cn/sflsapp/video/post_comment.asp?comment=asdf&user=asdf&bigclass=asdf&smallclass=asfd&videoname=waelfif"];
            
            
           
            NSURL *newUrl=[NSURL URLWithString:url];
            NSURLRequest *newRequest=[NSURLRequest requestWithURL:newUrl];
            NSURLConnection *newConnection=[[NSURLConnection alloc]initWithRequest:newRequest delegate:self startImmediately:YES];
            
            //重新刷新页面
            NSString *xmlPath=[NSString stringWithFormat: @"http://teacher.sfls.cn/sflsapp/video/list_comment.asp?bigclass=%@&smallclass=%@&videoname=%@",thenewVideoContent.bigClassName,thenewVideoContent.smallClassName,thenewVideoContent.videoName];
            NSLog(@"%@",xmlPath);
            XMLDocument *newDocument=[[XMLDocument alloc]initWithDelegate:self];
            self.xmlDocument=newDocument;
            [self.xmlDocument parseRemoteXMLWithURL:xmlPath];
            
            
            commentText.text=@"";
            [commentText resignFirstResponder];
            }
         
       
        
        
        
    }
}
- (void)dealloc {
    [commentTableView2 release];
    [super dealloc];
}
- (void)viewDidUnload {
    [commentTableView2 release];
    commentTableView2 = nil;
    [super viewDidUnload];
}
@end
