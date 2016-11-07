//
//  HHDHTMLParser.h
//  HHDRSSReader
//
//  Created by 黄红迪 on 6/16/15.
//  Copyright © 2015 HHDemond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHDHTMLParser : NSObject
//HTML Content String

-(instancetype)initWithString:(NSString*)string;

-(NSArray*)getaTaghref;

@end
