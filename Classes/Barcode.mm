//
//  Barcode.m
//  iOSKuapay
//
//  Created by Patrick Hogan on 12/5/11.
//  Copyright (c) 2011 Kuapay LLC. All rights reserved.
//

#import "Barcode.h"
#import "qr_draw_png.h"
#import "QR_Encode.h"


int mw = 2;
int mh = 140;


@interface Barcode ()

-(int)charToInt: (char) convert;
-(NSMutableData *) digitToBmpRenderer:(NSString *)digit;
-(NSString *) compute:(NSString *)code withType:(BarcodeType) type;
-(NSString *)getDigit:(NSString *)code withType:(BarcodeType) type;
-(NSString *) addQuietZone: (NSString *) barcode;
-(NSString *)getDigit128:(NSString *)code;

@end


@implementation Barcode
@synthesize oneDimBarcode, qRBarcode;
@synthesize oneDimCode;


#pragma mark - Barcode setup functions
-(void)setupBarcodes:(NSString *)code
{    
    [self setupQRCode:code];
    [self setupOneDimBarcode:code type:EAN_13];
}


-(void)setupOneDimBarcode:(NSString *)code type:(OneDimCodeType)type
{
//    [oneDimCode release];
    oneDimCode = [code copy];
    
    NSString *barcodeBits;
    if (type == EAN_13)
    {
        barcodeBits = [self getDigit:code withType:EAN13];
    }
    else 
    {
        barcodeBits = [self getDigit128:code];
    }
    
    barcodeBits = [self addQuietZone:barcodeBits];
    NSData *data = [self digitToBmpRenderer:barcodeBits];
    
    UIImage *image = [UIImage imageWithData:data];
    
    CGImageRef rawImageRef = image.CGImage;
    
    const float colorMasking[6] = {222, 255, 222, 255, 222, 255};
    
    UIGraphicsBeginImageContext(image.size);
    CGImageRef maskedImageRef = CGImageCreateWithMaskingColors(rawImageRef, colorMasking);
    {
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, image.size.height);
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0); 
    }
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height), maskedImageRef);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(maskedImageRef);
    UIGraphicsEndImageContext();  
    
//    [oneDimBarcode release];
//    oneDimBarcode = [result retain];
}


-(void)setupQRCode:(NSString *)code
{
    NSString *appSupport = [NSSearchPathForDirectoriesInDomains( NSApplicationSupportDirectory, NSUserDomainMask, YES ) objectAtIndex:0];
    NSString *dir = [NSString stringWithFormat:@"%@/iOSKuapay", appSupport];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:dir
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    
    NSString *qRFile = [dir stringByAppendingPathComponent:@"qR.png"];
    char filename [[qRFile length] + 1];
    [qRFile getCString:filename maxLength:[qRFile length] + 1 encoding:NSUTF8StringEncoding];
    //get char string
    int len = strlen([code UTF8String]);
    char *string = (char *)malloc(len+1);
    memset(string,0,len+1);
    memcpy(string,[code UTF8String],len);
    
    CQR_Encode encoder;
    encoder.EncodeData(1, 0, true, -1, string);
    
    QRDrawPNG qrDrawPNG;
    qrDrawPNG.draw(filename, 10, encoder.m_nSymbleSize, encoder.m_byModuleData, NULL);
    
    free(string);
    string = nil;
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:qRFile];
    UIImage *image = [UIImage imageWithData:data];
//    [data release];
    
    CGImageRef rawImageRef = image.CGImage;
    
    const float colorMasking[6] = {222, 255, 222, 255, 222, 255};
    
    UIGraphicsBeginImageContext(image.size);
    CGImageRef maskedImageRef = CGImageCreateWithMaskingColors(rawImageRef, colorMasking);
    {
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, image.size.height);
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0); 
    }
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height), maskedImageRef);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(maskedImageRef);
    UIGraphicsEndImageContext();  
    
    CGSize size = result.size;   
    CGImageRef imageRef = CGImageCreateWithImageInRect(result.CGImage, CGRectMake(20, 20, size.width - 40, size.height - 40));
    qRBarcode = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
}


-(int)charToInt: (char) convert
{
    return ([[NSNumber numberWithChar:convert] intValue] - '0');
}


-(NSString *)getDigit:(NSString *)code withType:(BarcodeType) type
{
    NSInteger length = type;
    code = [code substringToIndex:length];
    if([code length] != length)
    {
        return @"";
    }
    
    char check;
    for (int i =0; i < [code length]; i++) 
    {
        check = [code characterAtIndex:i];
        if ( check < '0' || check > '9') return @"";
    }
    
    code = [self compute:code withType:type];
    
    NSMutableString *result = [NSMutableString stringWithString:@"101"];
    if( type == EAN8)
    {
        for (int i = 0; i < 4; i++)  // process left part
        {
            [result appendString:[[encoding objectAtIndex:[self charToInt:[code characterAtIndex:i]]] objectAtIndex:0]]; 
        }
        
        // center guard bars
        [result appendString:@"01010"];
        
        for (int i = 4; i < 8; i++) // process right part
        {
            [result appendString:[[encoding objectAtIndex:[self charToInt:[code characterAtIndex:i]]] objectAtIndex:2]]; 
        }
    }
    else //EAN13 
    {
        // extract first digit and get sequence
        NSString *sequence = [first objectAtIndex:[self charToInt:[code characterAtIndex:0]]];
        for (int i = 1; i < 7; i++) // process left part
        {
            [result appendString:[[encoding objectAtIndex:[self charToInt:[code characterAtIndex:i]]] objectAtIndex: [self charToInt:[sequence characterAtIndex:i-1]]]]; 
        }
        
        [result appendString:@"01010"];
        
        for (int i = 7; i <13; i++) 
        {
            [result appendString:[[encoding objectAtIndex:[self charToInt:[code characterAtIndex:i]]] objectAtIndex: 2]];;
        }
    } 
    
    [result appendString:@"101"];
    
    return [NSString stringWithString:result];    
}


-(NSString *)getDigit128:(NSString *)code
{    
    NSCharacterSet* letters = [NSCharacterSet characterSetWithCharactersInString:@" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"];
    NSCharacterSet* notLetters = [letters invertedSet];
    NSRange badCharacterRange = [code rangeOfCharacterFromSet:notLetters];
    
    if (badCharacterRange.location != NSNotFound)
    {
        return  @""; // found bad characters
    }
    
    char check;
    BOOL tableCActivated = [code length] > 1;
    for (int i =0; i<3 && i < [code length]; i++) 
    {
        check = [code characterAtIndex:i];
        tableCActivated &= check >= '0' && check <= '9';
    }
    
    NSInteger sum = (tableCActivated )? 105 : 104;
    NSMutableString *result = [[code128Encoding objectAtIndex:sum] mutableCopy];
    
    int i = 0;
    int j = 0;  
    int isum = 0;
    int value = 0;
    while (i < [code length]) 
    {
        if (!tableCActivated) 
        {
            j = 0;
            while ( (i + j < [code length]) && ([code characterAtIndex:(i+j)] >= '0') && ([code characterAtIndex:(i+j)] <= '9') ) 
            {
                j++;
            }
            
            tableCActivated = (j > 5) || ((i + j - 1 == [code length]) && (j > 3));
            if (tableCActivated)
            {
                [result appendString:[code128Encoding objectAtIndex:99]];
                sum += ++isum *99;
            }
        }
        else if ( (i == [code length])  || ([code characterAtIndex:(i)] < '0')   || ([code characterAtIndex:(i)] > '9') 
                 || ((i+1) == [code length])              || ([code characterAtIndex:(i+1)] < '0') 
                 || ([code characterAtIndex:(i+1)] > '9') ) //Old code depended on code.charaAt(i+1) <'0' returning true on last character
        {
            tableCActivated = false;
            [result appendString:[code128Encoding objectAtIndex: 100]];// B table
            sum += ++isum * 100;
        }
        
        if (tableCActivated)
        {
            
            
            NSString *twoChar = [NSString stringWithFormat:@"%c%c", [code characterAtIndex:i], [code characterAtIndex:i+1]];
            value = [twoChar intValue];// Add two characters (numeric)
            i += 2;
        }
        else 
        {
            int oneChar = ([[NSNumber numberWithChar:[code characterAtIndex:i]] intValue] - ' ');
            value = oneChar; // Add one character
            i += 1;
        }
        [result appendString:[code128Encoding objectAtIndex:value]];
        sum += ++isum * value;               
    }
    
    [result appendString:[code128Encoding objectAtIndex:( sum % 103 )]];
    [result appendString:[code128Encoding objectAtIndex:106]];
    [result appendString:@"11"];
    
    return [NSString stringWithString:result];
} 


-(NSString *) compute:(NSString *)code withType:(BarcodeType) type 
{
    NSInteger length = type;
    code = [code substringToIndex:length];
    NSInteger sum = 0;
    BOOL odd = true;
    
    for (int i = [code length]-1; i>-1; i--)
    {
        sum += (odd ? 3: 1) * ([code characterAtIndex:i] - '0');
        odd = !odd;
    }
    
    return [NSString stringWithFormat:@"%@%i", code , ((10-sum) % 10)]; 
}

-(NSString *) addQuietZone: (NSString *) barcode
{
    return [NSString stringWithFormat:@"0000000000%@0000000000", barcode];
}

-(NSMutableData *) digitToBmpRenderer:(NSString *)digit
{
    NSInteger columns = [digit length];
    int lines = 1;
    
    int padding = (4 - ((mw * columns * 3) % 4)) % 4; // Padding for 4 byte alignment ("* 3" come from "3 byte to color R, G and B")
    int dataLen = (mw * columns + padding) * mh * lines;
    
    NSMutableString *bitmap = [NSMutableString stringWithFormat:@"BM"];
    [bitmap appendString:@""];
    CFSwapInt32HostToLittle(54);
    
    NSMutableData *bitmaps = [NSMutableData data];
    // Bitmap Header
    [bitmaps appendBytes:(void *)"BM" length:2];// Magic Number
    uint32_t temp = 54+dataLen;
    [bitmaps appendBytes:&temp length:4];       // Size of Bitmap size (header size + data len)
    
    temp = 0;
    [bitmaps appendBytes:&temp length:4];       // Unused
    
    temp = 54;
    [bitmaps appendBytes:&temp length:4];       // The offset where the bitmap data (pixels) can be found
    
    temp = 40;
    [bitmaps appendBytes:&temp length:4];       // The number of bytes in the header (from this point).
    
    temp = mw * columns;
    [bitmaps appendBytes:&temp length:4];       //width
    
    temp = mh * lines;
    [bitmaps appendBytes:&temp length:4];       //height
    
    temp = 1;
    [bitmaps appendBytes:&temp length:2];       // Number of color planes being used
    
    temp = 24;
    [bitmaps appendBytes:&temp length:2];       // The number of bits/pixel
    
    temp = 0;
    [bitmaps appendBytes:&temp length:4];       // BI_RGB, No compression used
    
    temp = dataLen;
    [bitmaps appendBytes:&temp length:4];       // The size of the raw BMP data (after this header)
    
    temp = 2835;
    [bitmaps appendBytes:&temp length:4];       // The horizontal resolution of the image (pixels/meter)
    
    temp = 2835;
    [bitmaps appendBytes:&temp length:4];       // The vertical resolution of the image (pixels/meter)
    
    temp = 0;
    [bitmaps appendBytes:&temp length:4];       // Number of colors in the palette
    
    temp = 0;
    [bitmaps appendBytes:&temp length:4];       // Means all colors are important
    
    //Bitmap Data    
    uint32_t c0 = 0xFFFFFF; //Make the color for bar 0
    uint32_t c1 = 0x0;      //Make the color for bar 1
    uint32_t pad = 0x0;
    
    NSMutableData *line; 
    for (int y = lines-1 ; y>=0; y--) 
    {
        line = [NSMutableData data];
        for (int x = 0; x < columns; x++)
        {
            [line appendBytes:([digit characterAtIndex:x] == '0') ? &c0 : &c1 length:3];
            [line appendBytes:([digit characterAtIndex:x] == '0') ? &c0 : &c1 length:3]; 
        }
        
        [line appendBytes:&pad length:padding];
        for (int k = 0; k < mh; k++) 
        {
            [bitmaps appendData:line];
        }
        
    }
    
    return bitmaps;
}


-(id)init
{
    if(self = [super init])
    {
        encoding = [NSArray arrayWithObjects:[NSArray arrayWithObjects: @"0001101", @"0100111",@"1110010",nil],
                    //                                      [["0001101",  "0100111", "1110010"]
                    [NSArray arrayWithObjects: @"0011001", @"0110011",@"1100110",nil],     
                    //                                              ["0011001",  "0110011", "1100110"], 
                    [NSArray arrayWithObjects: @"0010011", @"0011011",@"1101100",nil], 
                    //                                              ["0010011",  "0011011", "1101100"],
                    [NSArray arrayWithObjects: @"0111101", @"0100001",@"1000010",nil], 
                    //                                              ["0111101",  "0100001", "1000010"], 
                    [NSArray arrayWithObjects: @"0100011", @"0011101",@"1011100",nil],
                    //                                              ["0100011",  "0011101", "1011100"],
                    [NSArray arrayWithObjects: @"0110001", @"0111001",@"1001110",nil],
                    //                                              ["0110001",  "0111001", "1001110"],
                    [NSArray arrayWithObjects: @"0101111", @"0000101",@"1010000",nil],
                    //                                              ["0101111",  "0000101", "1010000"],
                    [NSArray arrayWithObjects: @"0111011", @"0010001",@"1000100",nil],
                    //                                              ["0111011",  "0010001", "1000100"],
                    [NSArray arrayWithObjects: @"0110111", @"0001001",@"1001000",nil],
                    //                                              ["0110111",  "0001001", "1001000"],
                    [NSArray arrayWithObjects: @"0001011", @"0010111",@"1110100",nil],
                    //                                              ["0001011",  "0010111", "1110100"] ]
                    nil];
        
        
        first = [NSArray arrayWithObjects:@"000000",@"001011",@"001101",@"001110",@"010011",@"011001",@"011100",@"010101",@"010110",@"011010",nil];
        //                        first:  ["000000", "001011", "001101", "001110", "010011", "011001", "011100", "010101", "010110", "011010"]
        
        code128Encoding = [NSArray arrayWithObjects: @"11011001100", @"11001101100", @"11001100110", @"10010011000",
                           @"10010001100", @"10001001100", @"10011001000", @"10011000100",
                           @"10001100100", @"11001001000", @"11001000100", @"11000100100",
                           @"10110011100", @"10011011100", @"10011001110", @"10111001100",
                           @"10011101100", @"10011100110", @"11001110010", @"11001011100",
                           @"11001001110", @"11011100100", @"11001110100", @"11101101110",
                           @"11101001100", @"11100101100", @"11100100110", @"11101100100",
                           @"11100110100", @"11100110010", @"11011011000", @"11011000110",
                           @"11000110110", @"10100011000", @"10001011000", @"10001000110",
                           @"10110001000", @"10001101000", @"10001100010", @"11010001000",
                           @"11000101000", @"11000100010", @"10110111000", @"10110001110",
                           @"10001101110", @"10111011000", @"10111000110", @"10001110110",
                           @"11101110110", @"11010001110", @"11000101110", @"11011101000",
                           @"11011100010", @"11011101110", @"11101011000", @"11101000110",
                           @"11100010110", @"11101101000", @"11101100010", @"11100011010",
                           @"11101111010", @"11001000010", @"11110001010", @"10100110000",
                           @"10100001100", @"10010110000", @"10010000110", @"10000101100",
                           @"10000100110", @"10110010000", @"10110000100", @"10011010000",
                           @"10011000010", @"10000110100", @"10000110010", @"11000010010",
                           @"11001010000", @"11110111010", @"11000010100", @"10001111010",
                           @"10100111100", @"10010111100", @"10010011110", @"10111100100",
                           @"10011110100", @"10011110010", @"11110100100", @"11110010100",
                           @"11110010010", @"11011011110", @"11011110110", @"11110110110",
                           @"10101111000", @"10100011110", @"10001011110", @"10111101000",
                           @"10111100010", @"11110101000", @"11110100010", @"10111011110",
                           @"10111101110", @"11101011110", @"11110101110", @"11010000100",
                           @"11010010000", @"11010011100", @"11000111010", nil];
        
    }
    return  self;
}


#pragma mark - Initialization/cleanup methods
-(void)dealloc
{
//    [oneDimBarcode release];
//    [qRBarcode release]; 
//    
//    [oneDimCode release]; 
//    
//    [super dealloc];
}


@end