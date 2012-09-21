//
//  XMLelement.m
//  SFLSNews
//
//  Created by 皓斌 朱 on 11-12-13.
//  Copyright 2011年 sfls. All rights reserved.
//

#import "XMLelement.h"

@implementation XMLelement
@synthesize name,text,parent,children,attributes;
- (id)init
{
    self = [super init];
    if (self!=nil  ) {
        // Initialization code here.
        NSMutableArray *childrenArray=[[NSMutableArray alloc]init];
        children=[childrenArray mutableCopy];
        [childrenArray release];
        NSMutableDictionary *newAttributes=[[NSMutableDictionary alloc]init];
        attributes=[newAttributes mutableCopy];
        [newAttributes release];
        
    }
    
    return self;
}
-(void) dealloc{
    NSLog(@"Dealocated Element");
    [name release];
    [text release];
    [children release];
    [attributes release];
    [super dealloc];
}
@end
