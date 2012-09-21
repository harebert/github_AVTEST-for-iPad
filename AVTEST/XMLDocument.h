//
//  XMLDocument.h
//  SFLSNews
//
//  Created by 皓斌 朱 on 11-12-13.
//  Copyright 2011年 sfls. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XMLelement;
@class XMLDocument;
@protocol XMLDocumentDelegate <NSObject>
@required
-(void)xmlDocumentDelegateParsingFinished:(XMLDocument *)paramSender;
-(void)xmlDocumentDelegateParsingFailed:(XMLDocument *)paramSender withError:(NSError *)paramError;
//-(void)xmlDocumentDelegateConnectionHasError:(XMLDocument *)paramSender withError:(NSString *)paramError;
@end
@interface XMLDocument : NSObject<NSXMLParserDelegate>
{
    @public
    NSString *documentPath;
    XMLelement *rootElement;
    id<XMLDocumentDelegate>delegate;
    @private
    NSXMLParser *xmlParser;
    XMLelement *currentElement;
    NSURLConnection *connection;
    NSMutableData *connectionData;
    BOOL parsingErrorHasHappened;
}
@property(nonatomic ,retain) NSString *documentPath;
@property(nonatomic ,retain) XMLelement *rootElement;
@property(nonatomic,assign)id<XMLDocumentDelegate>delegate;
@property(nonatomic ,retain) NSXMLParser *xmlParser;
@property(nonatomic ,retain) XMLelement *currentElement;
@property(nonatomic,retain)NSURLConnection *connection;
@property(nonatomic,retain)NSMutableData *connectionData;
@property(nonatomic,assign)BOOL parsingErrorHasHappened;
-(id)initWithDelegate:(id<XMLDocumentDelegate>)paramDelegate;
//-(BOOL)parseLocalXMLWithPath:(NSString *)paramLocalXMLPath;
-(BOOL)parseRemoteXMLWithURL:(NSString *)paramRemoteXMLURL;

@end
