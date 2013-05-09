//
//  FileManager.h
//  iPhoneKuapay
//
//  Created by Patrick Hogan on 5/4/11.
//  Copyright 2011 Patrick Hogan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject
{
 NSString *qRFile;
}
@property (nonatomic,copy) NSString *qRFile;

+(FileManager*)sharedFileManager;

@end
