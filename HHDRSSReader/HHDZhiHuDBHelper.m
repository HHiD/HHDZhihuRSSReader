//
//  HHDZhiHuDBHelper.m
//  HHDRSSReader
//
//  Created by 黄红迪 on 8/14/15.
//  Copyright © 2015 HHDemond. All rights reserved.
//

#import "HHDZhiHuDBHelper.h"
#import "ZhiHuArticle.h"

@implementation HHDZhiHuDBHelper

-(NSManagedObjectContext*)getManagedObjectContext{
    
    NSManagedObjectContext *context =nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(NSString*)EntityName{
    return @"Article";
}

-(void)saveArticle:(ZhiHuArticle*)article{
    
    NSManagedObjectContext *managedContext=[self getManagedObjectContext];
    
    NSManagedObject *newArticle = [NSEntityDescription insertNewObjectForEntityForName:[self EntityName] inManagedObjectContext:managedContext];
    [newArticle setValue:article.title forKey:@"title"];
    [newArticle setValue:article.author forKey:@"author"];
    [newArticle setValue:article.content forKey:@"content"];
    [newArticle setValue:article.publishDate forKey:@"publishDate"];
    
    NSError *error;
    if (![managedContext save:&error]) {
        NSLog(@"Can't save %@ : %@",error,[error localizedDescription]);
    }
}

-(NSArray*)getEntity{
    
    NSManagedObjectContext *managedContext=[self getManagedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] initWithEntityName:[self EntityName]];
    NSError *error;
    NSArray *array=[managedContext executeFetchRequest:fetchRequest error:&error];
    if (!error) {
        NSLog(@"Fetch Data Error :%@ %@",error,[error localizedDescription]);
    }
    return array;
}

-(NSArray*)getArticle{
    
    NSMutableArray *result=[[NSMutableArray alloc] init];
    NSArray *entities=[self getEntity];
    for (NSInteger i =entities.count-1; i>=0; i--) {
        NSManagedObject *managedObj=entities[i];
        NSString *title         =[managedObj valueForKey:@"title"];
        NSString *autor         =[managedObj valueForKey:@"author"];
        NSString *content       =[managedObj valueForKey:@"content"];
        NSString *publishDate   =[managedObj valueForKey:@"publishDate"];
        ZhiHuArticle *article=[ZhiHuArticle articleWithTitle:title Author:autor Date:publishDate Content:content];
        [result addObject:article];
    }
    
    return result;
}

@end
