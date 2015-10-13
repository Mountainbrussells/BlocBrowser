//
//  BlocURL.h
//  BlocBrowser
//
//  Created by Ben Russell on 10/13/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface BlocURL : NSObject

@property (nonatomic, strong) NSString* rawString;



- (instancetype) initWithString:(NSString *)string;
- (NSString *) URLString;


@end
