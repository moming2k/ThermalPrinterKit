//
//  FileManager.m
//
//  Created by Patrick Hogan on 5/4/11.
//  Copyright 2011 Patrick Hogan. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager
@synthesize qRFile;
static FileManager* _sharedFileManager = nil;

+(FileManager*)sharedFileManager
{
	@synchronized([FileManager class])
	{
//		if (!_sharedFileManager)
//			[[[self alloc] init] autorelease];
  
		return _sharedFileManager;
	}
	return nil;
}



+(id)alloc
{
	@synchronized([FileManager class])
	{
		NSAssert(_sharedFileManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedFileManager = [super alloc];
		return _sharedFileManager;
	}
 
	return nil;
}



-(id)init
{
 if ((self = [super init]))
 {
  NSString *appSupport = [NSSearchPathForDirectoriesInDomains( NSApplicationSupportDirectory, NSUserDomainMask, YES ) objectAtIndex:0];
  NSString *dir = [NSString stringWithFormat:@"%@/iPhoneKuapay", appSupport];
  
  NSLog(@"\nDirectory: %@\n\n",dir);
  
  [[NSFileManager defaultManager] createDirectoryAtPath:dir 
         withIntermediateDirectories:YES 
                          attributes:nil
                               error:nil];
  
  self.qRFile = [dir stringByAppendingPathComponent:@"qR.png"];
 }
 return self;
}



-(void)dealloc
{
 //[super dealloc];
 //[qRFile release];
}

@end
