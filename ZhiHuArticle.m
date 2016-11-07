//
//  ZhiHuArticle.m
//  HHDRSSReader
//
//  Created by 黄红迪 on 6/17/15.
//  Copyright © 2015 HHDemond. All rights reserved.
//

#import "ZhiHuArticle.h"
#import <CoreData/CoreData.h>
@interface ZhiHuArticle(){
    NSString *_title;
    NSString *_author;
    NSString *_publishDate;
    NSString *_content;
}
@end

@implementation ZhiHuArticle

-(instancetype)initWithTitle:(NSString*)title
                      Author:(NSString*)author
                        Date:(NSString*)date
                     Content:(NSString*)content{
    self = [super init];
    if (self) {
        _title=title;
        _author=author;
        _publishDate=date;
        _content=content;

    }
    return self;
}

+(instancetype)articleWithTitle:(NSString*)title
                         Author:(NSString*)author
                           Date:(NSString*)date
                        Content:(NSString*)content{
    
    return [[ZhiHuArticle alloc] initWithTitle:title Author:author Date:date Content:content];
}





-(NSString *)title{
    if (_title) {
        return _title;
    }
    return nil;
}
-(NSString *)content{
    if (_content) {
        return _content;
    }
    return nil;
}
-(NSString *)author{
    if (_author) {
        return _author;
    }
    return nil;
}
-(NSString *)publishDate{
    if (_publishDate) {
        return _publishDate;
    }
    return nil;
}

-(NSString *)description{
    
    return [NSString
            stringWithFormat:@"title:%@, author:%@, publishDate:%@, content:%@.",
            _title,_author,_publishDate,_content];
}

@end
