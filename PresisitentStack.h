//
//  PresisitentStack.h
//  HHDRSSReader
//
//  Created by 黄红迪 on 8/12/15.
//  Copyright © 2015 HHDemond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface PresisitentStack : NSObject



- (id)initWithStoreURL:(NSURL*)storeURL modelURL:(NSURL*)modelURL;
@property (nonatomic,strong,readonly) NSManagedObjectContext* managedObjectContext;

@end
