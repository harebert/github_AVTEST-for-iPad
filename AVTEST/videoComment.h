//
//  videoComment.h
//  附中视频推送
//
//  Created by 朱 皓斌 on 12-10-18.
//  Copyright (c) 2012年 sfls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "videoContent.h"
#import "XMLelement.h"
#import "XMLDocument.h"
@interface videoComment : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,XMLDocumentDelegate,UIScrollViewDelegate,UIAlertViewDelegate>{
    XMLDocument *xmlDocument;
    UIView *commentTextBack;
    UITextField *commentText;
    videoContent *thenewVideoContent;
    NSMutableArray *commentArray;
    UITableViewController *commentTableView;
    NSString *username;
    
}
@property(nonatomic,retain)videoContent *thenewVideoContent;
@property(nonatomic,retain)XMLDocument *xmlDocument;
@property(nonatomic,retain)NSMutableArray *commentArray;
@property(nonatomic,retain)NSString *username;
@end
