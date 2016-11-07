//
//  HHDZhiHuDBHelper.h
//  HHDRSSReader
//
//  Created by 黄红迪 on 8/14/15.
//  Copyright © 2015 HHDemond. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZhiHuArticle;

@interface HHDZhiHuDBHelper : NSObject

-(void)saveArticle:(ZhiHuArticle*)article;
-(NSArray*)getEntity;
-(NSArray*)getArticle;
@end
