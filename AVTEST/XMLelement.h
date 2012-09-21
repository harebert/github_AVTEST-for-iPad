//
//  XMLelement.h
//  SFLSNews
//
//  Created by 皓斌 朱 on 11-12-13.
//  Copyright 2011年 sfls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLelement : NSObject
{
    NSString *name;
    NSString *text;
    XMLelement *parent;
    NSMutableArray *children;
    NSMutableDictionary *attributes;
    
}
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain)NSString *text;
@property(nonatomic,retain)XMLelement *parent;
@property(nonatomic,retain)NSMutableArray *children;
@property(nonatomic,retain)NSMutableDictionary *attributes;
@end
