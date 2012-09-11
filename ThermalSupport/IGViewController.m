//
//  IGViewController.m
//  ThermalSupport
//
//  Created by Chris Chan on 12/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IGViewController.h"

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
    NSData *print_data = [IGThermalSupport imageToThermalData:logo];
    [sock writeData:print_data withTimeout:-1 tag:0];
    
    print_data = [IGThermalSupport feedLines:5];
    [sock writeData:print_data withTimeout:-1 tag:0];
    
    print_data = [IGThermalSupport cutLine];
    [sock writeData:print_data withTimeout:-1 tag:0];
    
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
