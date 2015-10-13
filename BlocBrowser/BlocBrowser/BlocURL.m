//
//  BlocURL.m
//  BlocBrowser
//
//  Created by Ben Russell on 10/13/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "BlocURL.h"

@implementation BlocURL

- (instancetype) initWithString:(NSString *)string {
    
    self = [super init];
    
    if (self) {
        self.rawString = string;
    }
    
    return self;
}

- (NSString *)URLString
{
    if ([self.rawString containsString:@" "]) {
        
        NSString *searchString = [self.rawString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        NSString *googleString = [NSString stringWithFormat:@"google.com/search?q=%@", searchString];
        
        return googleString;
        
    } else {
        
        return self.rawString;
        
    }
}

- (void)sendURLRequest:(NSString *)urlName forView:(WKWebView *)webView {
    
    NSURL *URL = [NSURL URLWithString:urlName];
    
    if (!URL.scheme){
        
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", urlName]];
        
    }
    
    if (URL) {
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        [webView loadRequest:request];
    }
    
    
}
@end

