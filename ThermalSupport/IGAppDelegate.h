//
//  IGAppDelegate.h
//  ThermalSupport
//
//  Created by Chris Chan on 12/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IGViewController;

@interface IGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) IGViewController *viewController;

@end
