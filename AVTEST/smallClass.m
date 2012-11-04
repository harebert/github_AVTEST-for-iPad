//
//  smallClass.m
//  AVTEST
//
//  Created by 皓斌 朱 on 12-2-3.
//  Copyright 2012年 sfls. All rights reserved.
//

#import "smallClass.h"
#import "videoList.h"
@implementation smallClass
@synthesize xmlDocument,smallClassList,databaseExisted,dataFilePath,bigClassName;
#pragma theXmlParser
-(void)xmlDocumentDelegateParsingFinished:(XMLDocument *)paramSender{
    //smallClassList=self.xmlDocument.rootElement.children;
    NSLog(@"the small class list has%@",[smallClassList componentsJoinedByString:@"haha"]);
    //[self.tableView reloadData];
    if (databaseExisted) {
        char *errorMSG;
        dataFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"database.sqlite"];
        sqlite3_open([dataFilePath UTF8String], &db);
        NSString *delSQL=[NSString stringWithFormat: @"DELETE FROM smallclass WHERE bigclassname='%@'",self.title ];
        sqlite3_exec(db, [delSQL UTF8String], NULL, NULL, &errorMSG);
        sqlite3_close(db);
        sqlite3_open([dataFilePath UTF8String], &db);
        int i;
        
        for (i=0; i<[self.xmlDocument.rootElement.children count]; i++) {
            XMLelement *newXMLElement=[[XMLelement alloc]init];
            newXMLElement=[self.xmlDocument.rootElement.children objectAtIndex:i];
            NSMutableDictionary *attribute=newXMLElement.attributes;
            
            NSString *insertSQL=[NSString stringWithFormat:@"INSERT OR REPLACE INTO 'smallclass' ('id','smallclassname','bigclassname') VALUES ('%@','%@','%@')",[attribute objectForKey:@"smallclasstitleimage"],newXMLElement.text,self.title];
            sqlite3_exec(db, [insertSQL UTF8String], NULL, NULL, &errorMSG);
        }
        sqlite3_close(db);
    }
    else {
        self.smallClassList=[[NSMutableArray alloc]init];
        //NSString *dataFilePath;
        //dataFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"database.sqlite"];
        //sqlite3_open([dataFilePath UTF8String], &db);
               
        dataFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"database.sqlite"];
        sqlite3_open([dataFilePath UTF8String], &db);
        int i;
        char *errorMSG;
        for (i=0; i<[self.xmlDocument.rootElement.children count]; i++) {
            XMLelement *newXMLElement=[[XMLelement alloc]init];
            newXMLElement=[self.xmlDocument.rootElement.children objectAtIndex:i];
            NSMutableDictionary *attribute=newXMLElement.attributes;
            
           NSString *insertSQL=[NSString stringWithFormat:@"INSERT OR REPLACE INTO 'smallclass' ('id','smallclassname','bigclassname') VALUES ('%@','%@','%@')",[attribute objectForKey:@"smallclasstitleimage"],newXMLElement.text,self.title];
            sqlite3_exec(db, [insertSQL UTF8String], NULL, NULL, &errorMSG);
            
            [self.smallClassList addObject:newXMLElement.text];
        }
        [self.tableView reloadData];
        NSLog(@"error is %s",errorMSG);
        sqlite3_close(db);
    }
    
}
-(void)xmlDocumentDelegateParsingFailed:(XMLDocument *)paramSender withError:(NSError *)paramError{
    NSLog(@"Parse xml failed");
}
#pragma lifecycle
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
    NSString *xmlPath=[NSString stringWithFormat: @"http://teacher.sfls.cn/sflsapp/video/creatVideo_ipad_charge.asp?query=smallclass&bigclassname=%@",title];
    NSLog(@"%@",xmlPath);
    XMLDocument *newDocument=[[XMLDocument alloc]initWithDelegate:self];
    self.xmlDocument=newDocument;
    [newDocument release];

    
    //NSString *dataFilePath;
    dataFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"database.sqlite"];
    if (sqlite3_open([dataFilePath UTF8String], &db)!=SQLITE_OK) 
    {//打开数据库失败
        databaseExisted=NO;
        NSLog(@"database error");
        sqlite3_close(db);
    }
    else 
    {
                
        NSLog(@"database open ok");
        NSString * searchString=[NSString stringWithFormat: @"SELECT * FROM smallclass where bigclassname='%@'",title];
        sqlite3_stmt *statement;
        sqlite3_prepare_v2(db, [searchString UTF8String], -1, &statement, nil);
        if( sqlite3_step(statement)==SQLITE_ROW){
            databaseExisted=YES;
            NSLog(@"有数据smallclass");
            
        }else {
            databaseExisted=NO;
            NSString *creatTableSQL=@"CREATE TABLE IF NOT EXISTS 'smallclass' ('id' INTEGER,'bigclassname' TEXT,'smallclassname' TEXT primary key)"    ;
            char *errorMsg;
            sqlite3_exec(db,[creatTableSQL UTF8String], NULL, NULL, &errorMsg);
            NSLog(@"error is %s",errorMsg);

        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    if (databaseExisted) {//如果有数据则刷新列表从数据库
        sqlite3_open([dataFilePath UTF8String], &db);
        NSString * searchString=[NSString stringWithFormat: @"SELECT * FROM smallclass where bigclassname='%@'",title];
        sqlite3_stmt *statement;
        sqlite3_prepare_v2(db, [searchString UTF8String], -1, &statement, nil);
        NSMutableArray *newarray=[[NSMutableArray alloc]init];
        self.smallClassList=newarray;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            [self.smallClassList addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];
        }
    }
   
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

    // Return the number of rows in the section.
    
    return [self.smallClassList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.textLabel.text=[self.smallClassList objectAtIndex:[indexPath row] ];
       
        //[tempelement release];
        return cell;
    }
    
    // Configure the cell...
    
    return cell;
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
    //XMLelement *tempelement=[self.smallClassList objectAtIndex:[indexPath row]];
    videoList *newVideoList=[[videoList alloc]init];
    //newVideoList.mySmallClass=tempelement.text;
    newVideoList.title=[self.smallClassList objectAtIndex:[indexPath row]];
    newVideoList.bigClassName=self.bigClassName;
    newVideoList.smallClassName=[self.smallClassList objectAtIndex:[indexPath row]];
    [self.navigationController pushViewController:newVideoList animated:YES];
    
}


@end
