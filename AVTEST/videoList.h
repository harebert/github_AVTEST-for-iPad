//
//  videoList.h
//  AVTEST
//
//  Created by 皓斌 朱 on 12-2-3.
//  Copyright 2012年 sfls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLDocument.h"
#import "XMLelement.h"
#import "sqlite3.h"
@interface videoList : UITableViewController<XMLDocumentDelegate>{
    XMLDocument *xmlDocument;
    NSMutableArray *listOfVideo;
    NSMutableArray *videoContentList;//包含一个个video的实例
    NSString *mySmallClass;
    sqlite3 *db;
    BOOL databaseExisted;//bigclass数据库是否存在
    NSString *dataFilePath;
    NSString *bigClassName;
    NSString *smallClassName;
}
@property(nonatomic,retain)XMLDocument *xmlDocument;
@property(nonatomic,retain)NSMutableArray *listOfVideo;
@property(nonatomic,retain)NSMutableArray *videoContentList;
@property(nonatomic,retain)NSString *mySmallClass;
@property(nonatomic,assign)BOOL databaseExisted;//bigclass数据库是否存在
@property(nonatomic,retain)NSString *dataFilePath;
@property(nonatomic,retain)NSString *bigClassName;
@property(nonatomic,retain)NSString *smallClassName;
@end
