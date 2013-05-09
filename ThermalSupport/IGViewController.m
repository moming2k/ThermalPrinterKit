//
//  IGViewController.m
//  ThermalSupport
//
//  Created by Chris Chan on 12/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IGViewController.h"
#import "FileManager.h"
#import "Barcode.h"

@implementation IGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self connectPrinter];
    
    [self testPrintNumber];
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

- (void)testPrintNumber
{
    UIImage *bigImage = [UIImage imageNamed:@"ticket_logo_red"];
    
    UIImage *bigImage_0 = [UIImage imageNamed:@"ticket_0"];
    
    NSString *code = @"http://igpsd.com";
    
    Barcode *barcode = [[Barcode alloc] init];
    
    [barcode setupQRCode:code];
    UIImage *bigImage_qrcode = barcode.qRBarcode;
    
//    receiptImage.image = [self mergeImage:bigImage withNumber:213];
    receiptImage.image = [IGThermalSupport mergeImage:bigImage qrcode:bigImage_qrcode withNumber:107];
//    
//    CGRect myImageRect = CGRectMake(0.0, 0.0, bigImage.size.width, bigImage.size.height);
//    
//    CGRect myImageRect_0 = CGRectMake(0.0, 0.0, bigImage_0.size.width, bigImage_0.size.height);
//    
//    
//    CGImageRef imageRef = bigImage.CGImage;
//    CGImageRef imageRef_0 = bigImage_0.CGImage;
//    
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
//    
//    CGImageRef subImageRef_0 = CGImageCreateWithImageInRect(imageRef_0, myImageRect_0);
//    
//    
//    CGSize size;
//    
//    size.width = bigImage.size.width;
//    
//    size.height = bigImage.size.height;
//    
//    UIGraphicsBeginImageContext(size);
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
////    CGContextDrawImage(context, myImageRect, subImageRef);
//    
//    CGContextDrawImage(context, myImageRect_0, subImageRef_0);
//    
//    
//    
//    
//    
//    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
//    
//    UIGraphicsEndImageContext();
//    
//
    //receiptImage.image = smallImage ; //[IGThermalSupport receiptImage:logo withNumber:100];
}

- (UIImage*)mergeImage:(UIImage*)first withNumber:(int)number
{
    
    // get size of the first image
    CGImageRef firstImageRef = first.CGImage;
    CGFloat firstWidth = CGImageGetWidth(firstImageRef);
    CGFloat firstHeight = CGImageGetHeight(firstImageRef);
    
    // get size of the second image
    
    UIImage *first_number = [UIImage imageNamed:[NSString stringWithFormat:@"ticket_%i",number/100]];
    UIImage *secord_number = [UIImage imageNamed:[NSString stringWithFormat:@"ticket_%i",1]];
    UIImage *third_number = [UIImage imageNamed:[NSString stringWithFormat:@"ticket_%i",3]];
    
    
    
    CGImageRef secondImageRef = first_number.CGImage ;
    CGFloat secondWidth = CGImageGetWidth(secondImageRef);
    CGFloat secondHeight = CGImageGetHeight(secondImageRef);
    
    // build merged size
    CGSize mergedSize = CGSizeMake(MAX(firstWidth, secondWidth), MAX(firstHeight, secondHeight));
    
    // capture image context ref
    UIGraphicsBeginImageContext(mergedSize);
    
    //Draw images onto the context
    [first drawInRect:CGRectMake(0, 0, firstWidth, firstHeight)];
    [first_number drawInRect:CGRectMake(100, 200, secondWidth, secondHeight)];
    [secord_number drawInRect:CGRectMake(200, 200, secondWidth, secondHeight)];
    [third_number drawInRect:CGRectMake(300, 200, secondWidth, secondHeight)];
    
    
    // assign context to new UIImage
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end context
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    
//    UIImage *bigImage = [UIImage imageNamed:@"ticket_logo_red"];
    
//    UIImage *logo = [UIImage imageNamed:@"ticket_logo"];
//    //[self printImage:logo withSocket:sock];
//    NSData *print_data = [IGThermalSupport imageToThermalData:logo];
//    [sock writeData:print_data withTimeout:-1 tag:0];
    
//    NSData *print_data = [IGThermalSupport imageToThermalData:[IGThermalSupport mergeImage:bigImage qrcode:NULL withNumber:102]];
//    [sock writeData:print_data withTimeout:-1 tag:0];
//    
//    
//    print_data = [IGThermalSupport feedLines:5];
//    [sock writeData:print_data withTimeout:-1 tag:0];
//    
//    print_data = [IGThermalSupport cutLine];
//    [sock writeData:print_data withTimeout:-1 tag:0];
//    
//    [sock disconnectAfterWriting];
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
