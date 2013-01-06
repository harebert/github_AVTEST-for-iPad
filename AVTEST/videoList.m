//
//  videoList.m
//  AVTEST
//
//  Created by 皓斌 朱 on 12-2-3.
//  Copyright 2012年 sfls. All rights reserved.
//

#import "videoList.h"
#import "videoContent.h"
#import "video.h"
@implementation videoList
@synthesize listOfVideo,xmlDocument,videoContentList,mySmallClass;
@synthesize dataFilePath,databaseExisted,bigClassName,smallClassName;
-(void)xmlDocumentDelegateParsingFinished:(XMLDocument *)paramSender{
    dataFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"database.sqlite"];
    listOfVideo=self.xmlDocument.rootElement.children;//这是所有的vido层面的群
    NSLog(@"the small class list has%@",[listOfVideo componentsJoinedByString:@"haha"]);
    NSLog(@"the count of listofVideo is %i",[listOfVideo count]);
    if ([listOfVideo count]==0) {
        return;
    }
    int i;
    int j;
    NSMutableArray *videoTempContentList=[[NSMutableArray alloc]init ];
    XMLelement *tempelement2;
    XMLelement *tempelement;
    
    for (i=0; i<[listOfVideo count]; i++) 
    {
        tempelement=[listOfVideo objectAtIndex:i];
        videoContent *newVideoContent=[[videoContent alloc]init];
        for (j=0; j<=[tempelement.children count]-1; j++) 
        {//这是单个video下的属性群
            tempelement2=[tempelement.children objectAtIndex:j];
            switch (j) 
            {
                case 0:
                    newVideoContent.videoisHot=tempelement2.text;
                    NSMutableDictionary *newDic=tempelement2.attributes;
                    newVideoContent.videoId=[[newDic objectForKey:@"id"] intValue];
                    break;
                case 1:
                    newVideoContent.hotImage=tempelement2.text;
                    break;
                case 2:
                    newVideoContent.videoName=tempelement2.text;
                    break;
                case 3:
                    newVideoContent.videoInfo=tempelement2.text;
                    break;
                case 4:
                    newVideoContent.videoPath=tempelement2.text;
                    break;
                    
                default:
                    break;
            }
        }
        [videoTempContentList addObject:newVideoContent];
        //[newVideoContent release];
    }
    int k;
    for (k=0; k<[videoTempContentList count]; k++) {
        videoContent *newVideoContent=[videoTempContentList objectAtIndex:k];
        char *errmsg;
        sqlite3_open([dataFilePath UTF8String], &db);
        NSString *insertSQL=[NSString stringWithFormat:@"INSERT OR REPLACE INTO video ('videoId','hotImage','videoName','videoInfo','videoPath','smallclassname') VALUES(%i,'%@','%@','%@','%@','%@')",newVideoContent.videoId,newVideoContent.hotImage,newVideoContent.videoName,newVideoContent.videoInfo,newVideoContent.videoPath,self.title];
        sqlite3_exec(db, [insertSQL UTF8String], NULL, NULL, &errmsg);
        NSLog(@"%s",errmsg);
    }
    if (!databaseExisted) {
        videoContentList=[[NSMutableArray alloc]init];
        self.videoContentList=videoTempContentList;
        [self.tableView reloadData];
    }
  
    //[self.tableView reloadData];
    

    
}
-(void)xmlDocumentDelegateParsingFailed:(XMLDocument *)paramSender withError:(NSError *)paramError{
    NSLog(@"Parse xml failed");
    UILabel *newLabel=[[UILabel alloc]init];
    newLabel.text=@"网络出现问题，请查看!";
    newLabel.textColor=[UIColor whiteColor];
    newLabel.textAlignment=UITextAlignmentCenter;
    newLabel.backgroundColor=[UIColor blackColor];
    [newLabel setLineBreakMode:UILineBreakModeTailTruncation];
    newLabel.numberOfLines=1;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        newLabel.frame=CGRectMake(20, 416, 280, 30);
        [newLabel.layer setCornerRadius:5];
        [newLabel.layer setOpacity:0.5f];
        [self.view addSubview:newLabel];
        CGContextRef context = UIGraphicsGetCurrentContext();   
        [UIView beginAnimations:@"Curl" context:context];   
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];   
        [UIView setAnimationDuration:2]; 
        //selfTableView.frame=CGRectMake(0, 50, 768, 1024);
        newLabel.frame=CGRectMake(20, 386, 280, 30);
        [UIView commitAnimations];
    }
    else {
        newLabel.frame=CGRectMake(40, 994, 688, 30);
        [newLabel.layer setCornerRadius:5];
        [newLabel.layer setOpacity:0.5f];
        [self.view addSubview:newLabel];
        CGContextRef context = UIGraphicsGetCurrentContext();   
        [UIView beginAnimations:@"Curl" context:context];   
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];   
        [UIView setAnimationDuration:2]; 
        //selfTableView.frame=CGRectMake(0, 50, 768, 1024);
        newLabel.frame=CGRectMake(40, 924, 688, 30);
        [UIView commitAnimations];
    }
    
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    NSString *title=self.title;
    dataFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"database.sqlite"];
   
    if (sqlite3_open([dataFilePath UTF8String], &db)!=SQLITE_OK) {
        NSLog(@"数据库打开错误");
    }
    else
    {
        NSString *searchIfExistSQL=[NSString stringWithFormat: @"SELECT * FROM video WHERE smallclassname ='%@'",self.title];
        sqlite3_stmt *statement;
        sqlite3_prepare_v2(db, [searchIfExistSQL UTF8String], -1, &statement, nil);
        if (sqlite3_step(statement)==SQLITE_ROW)
        {
            NSLog(@"数据库里面有 sql语言：%@",searchIfExistSQL);
            databaseExisted=YES;
        }
        else
        {
            databaseExisted=NO;
            NSLog(@"数据库里面无 sql语言：%@",searchIfExistSQL);
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(db);
    
    if (!databaseExisted) {
        sqlite3_open([dataFilePath UTF8String], &db);
        char *errmsg;
        NSString *creatTableSQL=@"CREATE TABLE IF NOT EXISTS 'video' ('videoId' INTEGER primary key,'hotImage' TEXT,'videoName' TEXT,'videoInfo' TEXT,'videoPath' TEXT,'smallclassname' TEXT)";
        sqlite3_exec(db, [creatTableSQL UTF8String], NULL, NULL, &errmsg);
        sqlite3_close(db);
    }
    else
    {
        videoContentList=[[NSMutableArray alloc]init];
        sqlite3_open([dataFilePath UTF8String], &db);
        sqlite3_stmt *statement;
        NSString *selectSQL=[NSString stringWithFormat:@"SELECT * FROM video WHERE smallclassname='%@'",self.title];
        sqlite3_prepare_v2(db, [selectSQL UTF8String], -1, &statement, nil);
        while (sqlite3_step(statement)==SQLITE_ROW) {
            NSLog(@"数据库里面有videolist");
            videoContent *newVideoContent=[[videoContent alloc]init];
            newVideoContent.videoId=sqlite3_column_int(statement, 0);
            newVideoContent.hotImage=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            newVideoContent.videoName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            newVideoContent.videoInfo=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            newVideoContent.videoPath=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            [self.videoContentList addObject:newVideoContent];  
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
        
    }
    //[self.tableView reloadData];
    
    
    NSString *xmlPath=[NSString stringWithFormat: @"http://teacher.sfls.cn/sflsapp/video/creatVideo_ipad_charge.asp?query=videolist&smallclassname=%@",title];
    NSLog(@"xml path is %@",xmlPath);
    XMLDocument *newDocument=[[XMLDocument alloc]initWithDelegate:self];
    self.xmlDocument=newDocument;
    [newDocument release];
    [self.xmlDocument parseRemoteXMLWithURL:xmlPath];
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return videoContentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"in cell the number is %@",indexPath);
    static NSString *CellIdentifier = @"listCell";
    //NSLog(@"cell is %i",[indexPath row]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //}
    
    videoContent *newVideoContent4TableView=[videoContentList objectAtIndex:[indexPath row]];
    UILabel *newLabel=(UILabel *)[cell viewWithTag:1];
    newLabel.text=newVideoContent4TableView.videoName;
    
    //下载图片开始
    DownImage *newdownLoad=[[DownImage alloc]init];
    [newdownLoad setDelegate:self];
    newdownLoad.imageUrl=[NSString stringWithFormat:@"http://teacher.sfls.cn/sflsapp/video/movie/images/%@", [newVideoContent4TableView.videoPath stringByReplacingOccurrencesOfString:@"m3u8" withString:@"jpg"]];
    newdownLoad.imageViewIndex=indexPath.row;
    [newdownLoad startDownload];
    
    //添加转轮
    UIImageView *newimageView=(UIImageView *)[cell viewWithTag:2];
    //NSLog(@"width=%f",[cell viewWithTag:2].frame.size.width);
    newimageView.layer.borderColor=[UIColor grayColor].CGColor;
    newimageView.layer.borderWidth=3;
    newimageView.layer.cornerRadius=5;
    [newimageView.layer setMasksToBounds:YES];
    loadingImage=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingImage.frame=CGRectMake(25, 17.5, 20, 20);
    [loadingImage startAnimating];
    //[newimageView addSubview:loadingImage];
    
    
    
    return cell;
    // Configure the cell...
    
    //return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self performSegueWithIdentifier:@"goVideo" sender:self];
    }
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    int row=[self.tableView indexPathForCell:sender].row;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        videoContent *newVideoContent=[self.videoContentList objectAtIndex:row];
        video *newVideo=(video *)[segue destinationViewController];
        newVideoContent.bigClassName=self.bigClassName;
        newVideoContent.smallClassName=self.smallClassName;
        newVideo.newVideoContent=newVideoContent;
        newVideo.title=newVideoContent.videoName;
        //[self.navigationController pushViewController:newVideo animated:YES];
    }
    else
    {
        videoContent *newVideoContent=[self.videoContentList objectAtIndex:row];
        video *newVideo=(video *)[segue destinationViewController];
        newVideoContent.bigClassName=self.bigClassName;
        newVideoContent.smallClassName=self.smallClassName;
        newVideo.newVideoContent=newVideoContent;
        newVideo.title=newVideoContent.videoName;
        //[self.navigationController pushViewController:newVideo animated:YES];
    }
    
    

}

#pragma downloadimage degegate
-(void)appImageDidLoad:(NSInteger)indexTag urlImage:(NSString *)imageUrl imageName:(NSString *)imageName{
    NSIndexPath *newPath=[NSIndexPath indexPathForRow:indexTag inSection:0];
    UITableViewCell *newCell=[self.tableView cellForRowAtIndexPath:newPath];
    UIImageView *newiMageView=(UIImageView *)[newCell viewWithTag:2];
    //UIActivityIndicatorView *newActView=(UIActivityIndicatorView *)[newiMageView.subviews objectAtIndex:0];
    //newActView.hidden=YES;
    //[newActView stopAnimating];
    newiMageView.image=[UIImage imageWithContentsOfFile:imageUrl];
    newiMageView.layer.opacity=0;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    newiMageView.layer.opacity=1;
    [UIView commitAnimations];
    
    NSLog(@"%@ is ok path=%@",newPath,imageUrl);
    }

@end
