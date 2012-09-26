//  
//  IGThermalSupport.m
//  
//  This class is released in the MIT license.
//  Created by Chris Chan in 12 Aug 2012.
//  Copyright (c) 2012 IGPSD Ltd.
//  
//  https://github.com/moming2k/ThermalPrinterKit.git
//
//  Version 1.0.3

#import "IGThermalSupport.h"

@implementation IGThermalSupport

+ (NSData *) imageToThermalData:(UIImage*)image
{
	CGImageRef imageRef = image.CGImage;
    
	// Create a bitmap context to draw the uiimage into
	CGContextRef context = [self newBitmapRGBA8ContextFromImage:imageRef];
    
	if(!context) {
		return NULL;
	}
    
	size_t width = CGImageGetWidth(imageRef);
	size_t height = CGImageGetHeight(imageRef);
    
	CGRect rect = CGRectMake(0, 0, width, height);
    
	// Draw image into the context to get the raw image data
	CGContextDrawImage(context, rect, imageRef);
    
	// Get a pointer to the data	
	uint32_t *bitmapData = (uint32_t *)CGBitmapContextGetData(context);
    
	if(bitmapData) {
        
        uint8_t *m_imageData = (uint8_t *) malloc(width * height/8 + 8*height/8);
        memset(m_imageData, 0, width * height/8 + 8*height/8);
        int result_index = 0;
        
        for(int y = 0; (y + 24) < height; ) {
            m_imageData[result_index++] = 27;
            m_imageData[result_index++] = 51;
            m_imageData[result_index++] = 24; 
            m_imageData[result_index++] = 27; 
            m_imageData[result_index++] = 42; 
            m_imageData[result_index++] = 33; 
            m_imageData[result_index++] = width%256; 
            m_imageData[result_index++] = width/256;
            for(int x = 0; x < width; x++) {
                int value = 0;
                for (int temp_y = 0 ; temp_y < 8; ++temp_y)
                {
                    uint8_t *rgbaPixel = (uint8_t *) &bitmapData[(y+temp_y) * width + x];
                    uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
                    
                    if (gray < 127)
                    {
                        value += 1<<(7-temp_y)&255;
                    }
                    
                }
                m_imageData[result_index++] = value;
                
                value = 0;
                for (int temp_y = 8 ; temp_y < 16; ++temp_y)
                {
                    uint8_t *rgbaPixel = (uint8_t *) &bitmapData[(y+temp_y) * width + x];
                    uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
                    
                    if (gray < 127)
                    {
                        value += 1<<(7-temp_y%8)&255;
                    }
                    
                }
                m_imageData[result_index++] = value;
                
                value = 0;
                for (int temp_y = 16 ; temp_y < 24; ++temp_y)
                {
                    uint8_t *rgbaPixel = (uint8_t *) &bitmapData[(y+temp_y) * width + x];
                    uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
                    
                    if (gray < 127)
                    {
                        value += 1<<(7-temp_y%8)&255;
                    }
                    
                }
                m_imageData[result_index++] = value;
            }
            m_imageData[result_index++] = 13; 
            m_imageData[result_index++] = 10;
            y += 24;
        }
        
        NSMutableData *data = [[NSMutableData alloc] initWithCapacity:0];
        [data appendBytes:m_imageData length:result_index];
        
		free(bitmapData);
        return data;
        
	} else {
		NSLog(@"Error getting bitmap pixel data\n");
	}
    
	CGContextRelease(context);
    
	return nil ; 
}


+ (CGContextRef) newBitmapRGBA8ContextFromImage:(CGImageRef) image {
	CGContextRef context = NULL;
	CGColorSpaceRef colorSpace;
	uint32_t *bitmapData;
    
	size_t bitsPerPixel = 32;
	size_t bitsPerComponent = 8;
	size_t bytesPerPixel = bitsPerPixel / bitsPerComponent;
    
	size_t width = CGImageGetWidth(image);
	size_t height = CGImageGetHeight(image);
    
	size_t bytesPerRow = width * bytesPerPixel;
	size_t bufferLength = bytesPerRow * height;
    
	colorSpace = CGColorSpaceCreateDeviceRGB();
    
	if(!colorSpace) {
		NSLog(@"Error allocating color space RGB\n");
		return NULL;
	}
    
	// Allocate memory for image data
	bitmapData = (uint32_t *)malloc(bufferLength);
    
	if(!bitmapData) {
		NSLog(@"Error allocating memory for bitmap\n");
		CGColorSpaceRelease(colorSpace);
		return NULL;
	}
    
	//Create bitmap context
    
	context = CGBitmapContextCreate(bitmapData, 
                                    width, 
                                    height, 
                                    bitsPerComponent, 
                                    bytesPerRow, 
                                    colorSpace, 
                                    kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);	// RGBA
	if(!context) {
		free(bitmapData);
		NSLog(@"Bitmap context not created");
	}
    
	CGColorSpaceRelease(colorSpace);
    
	return context;	
}

+ (UIImage*)mergeImage:(UIImage*)first withNumber:(int)number
{
    // get size of the first image
    
    CGImageRef firstImageRef = first.CGImage;
    CGFloat firstWidth = CGImageGetWidth(firstImageRef);
    CGFloat firstHeight = CGImageGetHeight(firstImageRef);
    
    // get size of the second image
    
    int first_num = number/100;
    int secord_num = (number - first_num*100)/10;
    int third_num = number - first_num*100 - secord_num*10;
    
    UIImage *first_number = [UIImage imageNamed:[NSString stringWithFormat:@"ticket_%i",first_num]];
    UIImage *secord_number = [UIImage imageNamed:[NSString stringWithFormat:@"ticket_%i",secord_num]];
    UIImage *third_number = [UIImage imageNamed:[NSString stringWithFormat:@"ticket_%i",third_num]];
    
    CGImageRef secondImageRef = first_number.CGImage ;
    CGFloat secondWidth = CGImageGetWidth(secondImageRef);
    CGFloat secondHeight = CGImageGetHeight(secondImageRef);
    
    // build merged size
    CGSize mergedSize = CGSizeMake(MAX(firstWidth, secondWidth), MAX(firstHeight, secondHeight));
    
    // capture image context ref
    UIGraphicsBeginImageContext(mergedSize);
    
    //Draw images onto the context
    [first drawInRect:CGRectMake(0, 0, firstWidth, firstHeight)];
    [first_number drawInRect:CGRectMake(270, 230, secondWidth, secondHeight)];
    [secord_number drawInRect:CGRectMake(340, 230, secondWidth, secondHeight)];
    [third_number drawInRect:CGRectMake(410, 230, secondWidth, secondHeight)];
    
    
    // assign context to new UIImage
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end context
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (NSData *)cutLine
{
    int index = 0;
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:0];
    uint8_t *m_imageData = (uint8_t *) malloc(4);
    m_imageData[index++] = 29;
    m_imageData[index++] = 86;
    m_imageData[index++] = 65;
    m_imageData[index++] = 10;
    [data appendBytes:m_imageData length:4];
    return data;
    
}

+ (NSData *)feedLines:(int)lines
{
    int index = 0;
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:0];
    uint8_t *m_imageData = (uint8_t *) malloc(3);
    m_imageData[index++] = 27;
    m_imageData[index++] = 100;
    m_imageData[index++] = lines;
    [data appendBytes:m_imageData length:3];
    return data;
    
}

+ (UIImage *) receiptImage:(UIImage*)image withNumber:(int)number
{
    UIImage *result = image;
    return result;
    
//    UIImage *bottomImage = [UIImage imageNamed:@"bottom.png"]; //background image
//    UIImage *image       = [UIImage imageNamed:@"top.png"]; //foreground image
//    
//    CGSize newSize = CGSizeMake(width, height);
//    UIGraphicsBeginImageContext( newSize );
//    
//    // Use existing opacity as is
//    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//    
//    // Apply supplied opacity if applicable
//    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:0.8];
//    
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
}


@end
