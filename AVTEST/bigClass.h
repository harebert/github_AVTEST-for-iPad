//
//  bigClass.h
//  AVTEST
//
//  Created by 皓斌 朱 on 12-2-3.
//  Copyright 2012年 sfls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLelement.h"
#import "XMLDocument.h"
#import "sqlite3.h"
@interface bigClass : UIViewController<XMLDocumentDelegate>{
    XMLDocument *xmlDocument;
    NSArray *bigClassList;
    UIScrollView *scrowView;
    sqlite3 *db;
    NSString *dataFilePath;
    float mainHeight;
    BOOL databaseExisted;//bigclass数据库是否存在
}
- (IBAction)toSmallClass:(id)sender withTag:(int)tag;
@property (nonatomic, retain) IBOutlet UIScrollView *scrowView;
@property(nonatomic,retain)XMLDocument *xmlDocument;
@property(nonatomic,retain)NSArray *bigClassList;
@property(nonatomic,assign)BOOL databaseExisted;
@property(nonatomic,retain)NSString *dataFilePath;
@end
