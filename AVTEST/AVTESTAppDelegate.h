//
//  AVTESTAppDelegate.h
//  AVTEST
//
//  Created by 皓斌 朱 on 12-1-31.
//  Copyright 2012年 sfls. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVTESTViewController;

@interface AVTESTAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet AVTESTViewController *viewController;

@end
