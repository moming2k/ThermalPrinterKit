//
//  IGThermalSupport.h
//  ThermalSupportDemo
//
//  Created by Chris Chan on 12/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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

@end
