//  
//  IGThermalSupport.h
//  
//  This class is released in the MIT license.
//  Created by Chris Chan in 12 Aug 2012.
//  Copyright (c) 2012 IGPSD Ltd.
//  
//  https://github.com/moming2k/ThermalPrinterKit.git
//
//  Version 1.0.3

#import <Foundation/Foundation.h>

typedef enum {
    ALPHA = 0,
    BLUE = 1,
    GREEN = 2,
    RED = 3
} PIXELS;

@interface IGThermalSupport : NSObject

+ (NSData *) imageToThermalData:(UIImage*)image;
+ (CGContextRef) newBitmapRGBA8ContextFromImage:(CGImageRef) image;
+ (NSData *)cutLine;
+ (NSData *)feedLines:(int)lines;
+ (UIImage*)mergeImage:(UIImage*)first withShopLogo:(UIImage*)shopLogo withImageInfo:(UIImage*)imageInfo withQRCode:(NSString*)qrcode withColorType:(NSString*)colorType withNumber:(int)number;
+ (UIImage*)drawText:(NSString*)text inImage:(UIImage*)image atPoint:(CGPoint)point;
+ (UIImage*)mergeImage2:(UIImage*)first withQRCode:(NSString*)qrcode withNumber:(int)number;
+ (UIImage *) receiptImage:(UIImage*)image withNumber:(int)number;

@end
