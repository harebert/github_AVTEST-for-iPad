//
//  bigClass.m
//  AVTEST
//
//  Created by 皓斌 朱 on 12-2-3.
//  Copyright 2012年 sfls. All rights reserved.
//

#import "bigClass.h"
#import "smallClass.h"
@implementation bigClass
@synthesize scrowView;
@synthesize bigClassList,xmlDocument,databaseExisted,dataFilePath;
-(void)xmlDocumentDelegateParsingFinished:(XMLDocument *)paramSender{
    char *errorMsg;
    NSArray *temparray=self.xmlDocument.rootElement.children;
    XMLelement *tempelement=[temparray objectAtIndex:0];
    NSLog(@"Parser finish the first data is %@",tempelement.text); 
    self.bigClassList=self.xmlDocument.rootElement.children;
    //接下来是写入sqlite的操作
    //找到应用程序沙箱内的 数据库路径
    //NSString *dataFilePath;
    dataFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"database.sqlite"];
    
    
    
if (!databaseExisted) 
{
     //如果数据库不存在第一次进入则在这里绘制按钮   
        NSString *creatSQL=@"CREATE TABLE IF NOT EXISTS 'bigclass'('id' INTEGER primary key,'bigClassName' TEXT)";
        if (sqlite3_exec(db,[creatSQL UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK)
        {
            //打开表、创建表失败
            sqlite3_close(db);
        }
        else
        {//打开表成功，写入数据库；
            int insertRe;
            for (insertRe=0; insertRe<=[temparray count]-1; insertRe++) 
            {
                XMLelement *newSingleBigClass=[[XMLelement alloc]init];    
                newSingleBigClass=[self.bigClassList objectAtIndex:insertRe];
                NSString *insertRecord;
                insertRecord=[NSString stringWithFormat: @"INSERT OR REPLACE INTO 'bigclass' ('id','bigClassName') VALUES(%i,'%@')",insertRe,newSingleBigClass.text];
                sqlite3_exec(db, [insertRecord UTF8String], NULL, NULL, &errorMsg);
            }
            sqlite3_close(db);
        }

        
    int i;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    self.scrowView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"iphoneBak1.png"]];
            for (i=0; i<=[temparray count]-1; i++) {
        XMLelement *tempele=[self.bigClassList objectAtIndex:i];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"iphone_button.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"iphone_button_touched.png"] forState:UIControlEventTouchDown];
        button.frame=CGRectMake(40, i*(25+50)+50, 240, 50);
        NSMutableDictionary *tempid=tempele.attributes;
        button.titleLabel.text=tempele.text;
        button.titleLabel.font=[UIFont systemFontOfSize:20];
        [button setTitle:tempele.text forState:UIControlStateNormal];
        [button setTag:[[tempid objectForKey:@"id"] intValue]];
        [button addTarget:self action:@selector(toSmallClass:withTag:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrowView addSubview:button];
        
        NSString *a=[tempid objectForKey:@"id"];
        NSLog(@"%@,%@",a,[a floatValue]);
        NSLog(@"%@",a);
        //NSLog(@"the id is %@ ",[[tempid objectForKey:@"id"] intValue]);
        
            }
        }
            else{
    self.scrowView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipadBak1.png"]];
       for (i=0; i<=[temparray count]-1; i++) {
           XMLelement *tempele=[self.bigClassList objectAtIndex:i];
           UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
           [button setBackgroundImage:[UIImage imageNamed:@"ipad_button.png"] forState:UIControlStateNormal];
           button.frame=CGRectMake(150, i*(50+100)+100, 480, 100);
           NSMutableDictionary *tempid=tempele.attributes;
           button.titleLabel.text=tempele.text;
           button.titleLabel.font=[UIFont systemFontOfSize:30];
           button.showsTouchWhenHighlighted=YES;
           [button setBackgroundImage:[UIImage imageNamed:@"ipad_button_touched.png"] forState:UIControlEventTouchDown];
           
           [button setTitle:tempele.text forState:UIControlStateNormal];
           [button setTag:[[tempid objectForKey:@"id"] intValue]];
           [button addTarget:self action:@selector(toSmallClass:withTag:) forControlEvents:UIControlEventTouchUpInside];
           [self.scrowView addSubview:button];
           
           NSString *a=[tempid objectForKey:@"id"];
           NSLog(@"%@,%@",a,[a floatValue]);
           NSLog(@"%@",a);
           //NSLog(@"the id is %@ ",[[tempid objectForKey:@"id"] intValue]);
           
                }

            }
    sqlite3_close(db);
     [self.view addSubview:scrowView];
    }
else
{//如果存在数据库
    //char *errorMsg;
    //sqlite3_open( [dataFilePath UTF8String],&db);
    XMLelement *newElement=[[XMLelement alloc]init];
    int i=0;
    for(i=0;i<[self.bigClassList count];i++)
    {
        newElement=[self.bigClassList objectAtIndex:i];
        NSString * searchString=[NSString stringWithFormat:@"update bigclass set bigclassname='%@' where id=%i", newElement.text,i];
        
        if (sqlite3_exec(db,[searchString UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK)
        {
            NSLog(@"已经更新了%@",newElement.text);
        }
        else {
            NSLog(@"失败了,%s",errorMsg);
        }

    }   
        

    sqlite3_close(db);
}
    
}
-(void)xmlDocumentDelegateParsingFailed:(XMLDocument *)paramSender withError:(NSError *)paramError{
    NSLog(@"Parse xml failed");
}


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
    //sleep(5);
//获取数据库内部数据，如果获取不成功则parse xml
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
        NSString * searchString=@"SELECT * FROM bigclass";
        sqlite3_stmt *statement;
        sqlite3_prepare_v2(db, [searchString UTF8String], -1, &statement, nil);
        if( sqlite3_step(statement)==SQLITE_ROW){
            databaseExisted=YES;
            
        }else {
            databaseExisted=NO;
        }
        sqlite3_finalize(statement);
        if (databaseExisted) {//如果数据库有数据则在这建按钮
            sqlite3_stmt *statment2;
            sqlite3_prepare_v2(db,[searchString UTF8String], -1, &statment2, nil);
            int i=0;
            while (sqlite3_step(statment2)==SQLITE_ROW) 
            {
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    self.scrowView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"iphoneBak1.png"]];
                    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                    [button setBackgroundImage:[UIImage imageNamed:@"iphone_button.png"] forState:UIControlStateNormal];
                    [button setBackgroundImage:[UIImage imageNamed:@"iphone_button_touched.png"] forState:UIControlEventTouchDown];
                    button.frame=CGRectMake(40, i*(25+50)+50, 240, 50);
                    
                    button.titleLabel.text=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statment2, 1)];
                    button.titleLabel.font=[UIFont systemFontOfSize:20];
                    [button setTitle:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statment2, 1)] forState:UIControlStateNormal];
                   // [button setTag:[[tempid objectForKey:@"id"] intValue]];
                    [button addTarget:self action:@selector(toSmallClass:withTag:) forControlEvents:UIControlEventTouchUpInside];
                    [self.scrowView addSubview:button];
                }
                else {
                    NSLog(@"its ipad");
                    self.scrowView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipadBak1.png"]];
                    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                    [button setBackgroundImage:[UIImage imageNamed:@"ipad_button.png"] forState:UIControlStateNormal];
                    [button setBackgroundImage:[UIImage imageNamed:@"ipad_button_touched.png"] forState:UIControlEventTouchDown];
                    button.frame=CGRectMake(150, i*(50+100)+100, 480, 100);
                    
                    button.titleLabel.text=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statment2, 1)];
                    button.titleLabel.font=[UIFont systemFontOfSize:30];
                    [button setTitle:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statment2, 1)] forState:UIControlStateNormal];
                    // [button setTag:[[tempid objectForKey:@"id"] intValue]];
                    [button addTarget:self action:@selector(toSmallClass:withTag:) forControlEvents:UIControlEventTouchUpInside];
                    [self.scrowView addSubview:button];
                    [self.view addSubview:scrowView];
                }
                
                
                i++;
                  
            }
            sqlite3_finalize(statment2);
        }

    }
    //sqlite3_close(db);
//获取结束
    
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    NSString *xmlPath=@"http://teacher.sfls.cn/sflsapp/video/creatVideo_ipad_charge.asp?query=bigclass";
  
    XMLDocument *newDocument=[[XMLDocument alloc]initWithDelegate:self];
    self.xmlDocument=newDocument;
    [newDocument release];
    [self.xmlDocument parseRemoteXMLWithURL:xmlPath];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setScrowView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [scrowView release];
    [super dealloc];
}
- (IBAction)toSmallClass:(id)sender withTag:(int)tag{
    //NSLog(@"%@",[sender tag]);
    smallClass *smallclass=[[smallClass alloc]init];
    smallclass.title=[sender titleForState:UIControlStateNormal];
    [self.navigationController pushViewController:smallclass animated:YES];
}
@end
