//
//  IGViewController.h
//  ThermalSupport
//
//  Created by Chris Chan on 12/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"
#import "IGThermalSupport.h"

@interface IGViewController : UIViewController
{
    GCDAsyncSocket *asyncSocket;
    IBOutlet UIImageView *receiptImage;
}

- (void)testPrintNumber;

@end
