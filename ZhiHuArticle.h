//
//  ZhiHuArticle.h
//  HHDRSSReader
//
//  Created by 黄红迪 on 6/17/15.
//  Copyright © 2015 HHDemond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhiHuArticle : NSObject

-(instancetype)initWithTitle:(NSString*)title
                      Author:(NSString*)author
                        Date:(NSString*)date
                     Content:(NSString*)content;

+(instancetype)articleWithTitle:(NSString*)title
                         Author:(NSString*)author
                           Date:(NSString*)date
                        Content:(NSString*)content;

-(NSString*)title;
-(NSString*)content;
-(NSString*)author;
-(NSString*)publishDate;

@end
