//
//  RSSDataFetching.m
//  HHDRSSReader
//
//  Created by 黄红迪 on 6/16/15.
//  Copyright © 2015 HHDemond. All rights reserved.
//

#import "RSSDataFetching.h"
#import "SMXMLDocument.h"
#import "ZhiHuArticle.h"
#import "HHDZhiHuDBHelper.h"
@interface RSSDataFetching()<NSURLSessionDelegate>
{
    
}
@end
static NSString *url=@"http://www.zhihu.com/rss";

@implementation RSSDataFetching



+(void)fetchData:(void(^)(NSMutableArray *result))comple{
    
   

    
    NSURLSessionConfiguration *sessionConfig=[NSURLSessionConfiguration defaultSessionConfiguration];;
    
    NSURLSession *session=[NSURLSession sessionWithConfiguration:sessionConfig
                                                        delegate:self
                                                   delegateQueue:nil];
    

    
    NSURLSessionDataTask *dataTask=[session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        
        NSMutableArray *result=[[NSMutableArray alloc] init];
        
        SMXMLDocument *XMLDocument=[SMXMLDocument documentWithData:data error:nil];
        SMXMLElement *channelElement=[XMLDocument childNamed:@"channel"];
        
        NSString *title=[channelElement valueWithPath:@"title"];
        NSString *copyright=[channelElement valueWithPath:@"copyright"];
        NSLog(@"Title :%@,Copyright:%@",title,copyright);
        
        /*Database Process*/
        HHDZhiHuDBHelper *dbHelper=[[HHDZhiHuDBHelper alloc] init];
        NSArray *exsistingArticle=[dbHelper getEntity];
        /*New Data*/
        NSMutableArray *newData=[[NSMutableArray alloc] init];
        for (SMXMLElement *item in [channelElement childrenNamed:@"item"]) {

            
            
            NSString *discriptionItemContent    =[item valueWithPath:@"description"];
            NSString *discriptionTitle          =[item valueWithPath:@"title"];
            NSString *discriptionAutor          =[item valueWithPath:@"creator"];
            NSString *discriptionPulishDate     =[item valueWithPath:@"pubDate"];
            /*NSString *discriptionGuid         =[item valueWithPath:@"guid"];
            NSLog(@"%@",discriptionGuid);*/
            ZhiHuArticle *article=[ZhiHuArticle articleWithTitle:discriptionTitle
                                                          Author:discriptionAutor
                                                            Date:discriptionPulishDate
                                                         Content:discriptionItemContent];
            
            
            /*Process DataBase*/
            /*if (exsistingArticle.count>0) {
                NSManagedObject *object=exsistingArticle[exsistingArticle.count-1];
                NSString *exsistingTitle=[object valueForKey:@"title"];
                NSString *newTitle=article.title;
                NSLog(@"exsisting title :%@",exsistingTitle);
                NSLog(@"newTitle :%@",newTitle);
                if (![exsistingTitle isEqualToString:newTitle]) {
                    //For return New Data
                    [newData addObject:article];
                    [dbHelper saveArticle:article];
                }
            }*/
            
            [result addObject:article];
        }
        
        /*if (exsistingArticle.count==0) {
            newData=result;
            for (NSInteger i=(result.count-1); i>=0; i--) {
                
                ZhiHuArticle *article=result[i];
                [dbHelper saveArticle:article];
            }
        }*/
        comple(result);
    }];
    [dataTask resume];
}



/*------------------------------Regular Expression Parser------------------------------*/
/*HHDHTMLParser *htmlParser=[[HHDHTMLParser alloc] initWithString:discriptionItem];
 NSArray *result=[htmlParser getaTaghref];
 for (NSTextCheckingResult *match in result)
 {
 NSRange matchRange = match.range;
 NSString *result=[discriptionItem substringWithRange:matchRange];
 NSLog(@"%@",result);
 }*/
/*----------------------------------------- End ---------------------------------------*/
@end
