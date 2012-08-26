//
//  IGViewController.m
//  ThermalSupport
//
//  Created by Chris Chan on 12/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IGViewController.h"

@interface IGViewController ()

@end

@implementation IGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self connectPrinter];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)connectPrinter
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    
    NSError *error = nil;
    if (![asyncSocket connectToHost:@"192.168.1.200" onPort:9100 error:&error])
    {
        //DDLogError(@"Error connecting: %@", error);
        //self.viewController.label.text = @"Oops";
        NSLog(@"error connect to 192.168.0.200");
    }
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    UIImage *logo = [UIImage imageNamed:@"ticket_logo"];
    //[self printImage:logo withSocket:sock];
    NSMutableData *print_data = [IGThermalSupport imageToThermalData:logo];
    [sock writeData:print_data withTimeout:-1 tag:0];
    print_data = [IGThermalSupport cutLine];
    [sock writeData:print_data withTimeout:-1 tag:0];
    
    /*
     uint8_t *m_imageData = (uint8_t *) malloc(m_width * m_height);
     
     
     //DDLogInfo(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
     //    NSString *requestStr = [NSString stringWithFormat:@"\r\n\r\n堂食\r\n\r\n%@%@%@%@%@%@%@%@%@%@%@%@\r\n\r\n", 
     //                            @"菠蘿包         $5.5\r\n\r\n", 
     //                            @"菠蘿油         $8.5\r\n\r\n", 
     //                            @"火腿通粉         $18.0\r\n\r\n", 
     //                            @"腸仔通粉         $18.0\r\n\r\n", 
     //                            @"餐肉通粉         $18.0\r\n\r\n", 
     //                            @"火腿蛋三文治         $15.0\r\n\r\n", 
     //                            @"餐肉蛋三文治         $15.0\r\n\r\n", 
     //                            @"咸牛肉三文治         $18.0\r\n\r\n", 
     //                            @"火腿煎蛋         $15.0\r\n\r\n\r\n----------------------\r\n\r\n", 
     //                            @"合計 131.0\r\n",
     //                            @"加一 13.1\r\n\r\n",
     //                            @"總計 144.1\r\n"];
     //    
     //	NSData *requestData = [requestStr dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingBig5)];
     
     [sock writeData:requestData withTimeout:-1 tag:0];
     
     NSString *string2 = [NSString stringWithFormat:@"%c%c%c%c", 29,86,65,10]; 
     requestData = [string2 dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingBig5)];
     [sock writeData:requestData withTimeout:-1 tag:0];
     
     
     NSString *string = [NSString stringWithFormat:@"%c%c%c%c%c", 27,112,48,55,121]; 
     requestData = [string dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingBig5)];
     [sock writeData:requestData withTimeout:-1 tag:0];
     
     */ 
    
    [sock disconnectAfterWriting];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
