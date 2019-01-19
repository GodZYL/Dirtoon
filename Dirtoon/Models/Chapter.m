//
//  Chapter.m
//  Dirtoon
//
//  Created by godloong on 2019/1/7.
//  Copyright © 2019 godloong. All rights reserved.
//

#import "Chapter.h"

@implementation Chapter

- (Chapter *)initWithDic:(NSDictionary *)dic {
    self = [super init];
    self.chaid = [[dic objectForKey:@"Chaid"] intValue];
    self.sort = [[dic objectForKey:@"Sort"] intValue];
    self.cover = [NSURL URLWithString:[self base64DecodeString:[dic objectForKey:@"Cover"]]];
    self.price = [[dic objectForKey:@"Price"] intValue];
    
    NSString * pics = [[self base64DecodeString:[dic objectForKey:@"Pics"]] stringByReplacingOccurrencesOfString:@"[" withString:@""];
    pics = [pics stringByReplacingOccurrencesOfString:@"]" withString:@""];
    pics = [pics stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    self.pics = [pics componentsSeparatedByString:@","];
    self.title = [self base64DecodeString:[dic objectForKey:@"Title"]];
    self.payed = [dic objectForKey:@"Payed"];
    return self;
}

+ (NSArray *)chaptersWithArray:(NSArray *)array {
    NSMutableArray *reArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        Chapter *chapter = [[Chapter alloc] initWithDic:dic];
        [reArr addObject:chapter];
    }
    return reArr;
}

-(NSString *)base64DecodeString:(NSString *)string{
    NSData *data=[[NSData alloc]initWithBase64EncodedString:string options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

@end
