//
//  XMLDocument.m
//  SFLSNews
//
//  Created by 皓斌 朱 on 11-12-13.
//  Copyright 2011年 sfls. All rights reserved.
//

#import "XMLDocument.h"
#import "XMLelement.h"

@implementation XMLDocument
@synthesize documentPath,rootElement,xmlParser,currentElement,connection,connectionData,parsingErrorHasHappened,delegate;
- (id)init
{
    return [self initWithDelegate:nil];
}
-(id)initWithDelegate:(id<XMLDocumentDelegate>)paramDelegate{
    self=[super init];
    if (self!=nil) {
        delegate=paramDelegate;
    }
    return self;
}

/*下载远程文档*/
-(BOOL)parseRemoteXMLWithURL:(NSString *)paramRemoteXMLURL{
    BOOL result=NO;
    if ([paramRemoteXMLURL length]==0) {
        NSLog(@"The remote URL cannot be nil or empty");
        return NO;
    }
    paramRemoteXMLURL=[paramRemoteXMLURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.connection=nil;
    NSURL *url=[NSURL URLWithString:paramRemoteXMLURL];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    self.connectionData=nil;
    NSMutableData *newData=[[NSMutableData alloc]init];
    self.connectionData=newData;
    [newData release];
    NSURLConnection *newConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
    self.connection=newConnection;
    [newConnection release];
    return result;
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [self.connectionData setLength:0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.connectionData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"您所处的区域没有网络" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    //NSLog(@"A connection error has occurred.");
    //[alertView show];
    [self.delegate xmlDocumentDelegateParsingFailed:self withError:error];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (self.connectionData!=nil) {
        //显示一下xml文档
        NSString *theXML = [[NSString alloc] initWithBytes: [self.connectionData mutableBytes] length:[self.connectionData length] encoding:NSUTF8StringEncoding];
        NSLog(@"%@",theXML);
        //显示一下xml文档
        //NSLog(@"connectiondata is in progress%@",self.connectionData);
        NSXMLParser *newParser=[[NSXMLParser alloc]initWithData:self.connectionData];
        self.xmlParser=newParser;
        [newParser release];
        [self.xmlParser setShouldProcessNamespaces:NO];
        [self.xmlParser setShouldReportNamespacePrefixes:NO];
        [self.xmlParser setShouldResolveExternalEntities:NO];
        [self.xmlParser setDelegate:self];
        if ([self.xmlParser parse]==YES) {
            NSLog(@"Successfully parsed the remote file.");
        }else
        {
            NSLog(@"Failed to parse the remote file.");
        }
    }
}
/*下载完毕，接下来开始编译*/
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"Parsing error has occured.");
    self.parsingErrorHasHappened=YES;
    [parser abortParsing];
    [self.delegate xmlDocumentDelegateParsingFailed:self withError:parseError];
}
-(void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{
    NSLog(@"Parsing validationerror has occured.");
    self.parsingErrorHasHappened=YES;
    [parser abortParsing];
    [self.delegate xmlDocumentDelegateParsingFailed:self withError:validationError];
}
-(void)parserDidStartDocument:(NSXMLParser *)parser{
    self.parsingErrorHasHappened=NO;  
    
}
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    [self.delegate xmlDocumentDelegateParsingFinished:self];
   
}
/*
-(BOOL)parseLocalXMLWithPath:(NSString *)paramLocalXMLPath{
    BOOL result=YES;
    return result;
}*/
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if (self.rootElement==nil) {
        XMLelement *newElement=[[XMLelement alloc]init];
        self.rootElement=newElement;
        self.currentElement=self.rootElement;
        [newElement release];
        }
    else
    {   //NSLog(@"element text is%@",elementName);
        XMLelement *newElement=[[XMLelement alloc]init];
        newElement.parent=self.currentElement;
        [self.currentElement.children addObject:newElement];
        self.currentElement=newElement;
        [newElement release];
    }
    self.currentElement.name=elementName;
    if ([attributeDict count]>0) {
        [self.currentElement.attributes addEntriesFromDictionary:attributeDict];
    }
        //NSLog(@"self.rootelement.name=%@",self.rootElement.name);
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (self.currentElement!=nil) {
        if (self.currentElement.text==nil) {
            self.currentElement.text=string;
        }
        else
        {
            self.currentElement.text=[self.currentElement.text stringByAppendingString:string];
        }
    }

}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if (self.currentElement!=nil) {
        self.currentElement=self.currentElement.parent;
    }
}

-(void)dealloc{
    if (connection!=nil) {
        [connection cancel];
    }
    [connection release];
    [connectionData release];
    [xmlParser release];
    [rootElement release];
    [currentElement release];
    [documentPath release];
    [super dealloc];

}

@end














