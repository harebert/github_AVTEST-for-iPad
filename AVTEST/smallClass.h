//
//  smallClass.h
//  AVTEST
//
//  Created by 皓斌 朱 on 12-2-3.
//  Copyright 2012年 sfls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLelement.h"
#import "XMLDocument.h"
#import "sqlite3.h"
@interface smallClass : UITableViewController<XMLDocumentDelegate>{
    XMLDocument *xmlDocument;
    NSMutableArray *smallClassList;
    sqlite3 *db;
    BOOL databaseExisted;//bigclass数据库是否存在
    NSString *dataFilePath;
}
@property (nonatomic, retain)XMLDocument *xmlDocument;
@property (nonatomic, retain)NSMutableArray *smallClassList;
@property(nonatomic,assign)BOOL databaseExisted;
@property (nonatomic, retain)NSString *dataFilePath;
@end
