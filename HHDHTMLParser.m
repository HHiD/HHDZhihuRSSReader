//
//  HHDHTMLParser.m
//  HHDRSSReader
//
//  Created by 黄红迪 on 6/16/15.
//  Copyright © 2015 HHDemond. All rights reserved.
//

#import "HHDHTMLParser.h"

@interface HHDHTMLParser(){
    NSString*_contentString;
}

@end

@implementation HHDHTMLParser

-(instancetype)initWithString:(NSString *)string{
    
    self=[super init];
    if (self) {
        _contentString=string;
    }
    return self;
}

-(NSArray*)getaTaghref{
    
    NSError *error=nil;                               //<a.*?[^>]*\bhref=\"(.*?)\"[^>]*>(.*?)</a>
    NSRegularExpression *regex=                       //<a\\b[^>]*\\bhref=\"(.*?)\"[^>]*>(.*?)</a>
    [NSRegularExpression regularExpressionWithPattern:@"<a\\b[^>]*\\bhref=\"([^\"]*)\"[^>]*>(.*?)</a>"
                                              options:NSRegularExpressionCaseInsensitive
                                                error:&error];
    if (error) {
        NSLog(@"RegularError :%@",[error localizedDescription]);
    }
    NSArray *array=[self getMatches:regex];
    
    return array;
}


-(NSArray*)getMatches:(NSRegularExpression*)regex{
    
    NSRange range=NSMakeRange(0, _contentString.length);
    NSArray *matches=[regex matchesInString:_contentString
                                    options:0
                                      range:range];

    
    return matches;
}

@end
