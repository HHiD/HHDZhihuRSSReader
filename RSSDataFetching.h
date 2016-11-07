//
//  RSSDataFetching.h
//  HHDRSSReader
//
//  Created by 黄红迪 on 6/16/15.
//  Copyright © 2015 HHDemond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSDataFetching : NSObject

+(void)fetchData:(void(^)(NSMutableArray *result))comple;


@end
