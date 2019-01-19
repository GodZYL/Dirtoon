//
//  Caricature.m
//  Dirtoon
//
//  Created by godloong on 2019/1/7.
//  Copyright © 2019 godloong. All rights reserved.
//

#import "Caricature.h"

@implementation Caricature

- (Caricature *)initWithDic:(NSDictionary *)dic {
    self = [super init];
    self.carId = [[dic objectForKey:@"Carid"] intValue];
    self.name = [self base64DecodeString:[dic objectForKey:@"Name"]] ;
    self.cover = [NSURL URLWithString:[self base64DecodeString:[dic objectForKey:@"Cover"]]];
    self.chapterCount = [[dic objectForKey:@"ChapterCount"] intValue];
    self.star = [dic objectForKey:@"Star"];
    self.end = [dic objectForKey:@"End"];
    return self;
}

+ (NSArray *)caricaturesWithArray:(NSArray *)array {
    NSMutableArray *reArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        Caricature *car = [[Caricature alloc] initWithDic:dic];
        [reArr addObject:car];
    }
    return reArr;
}

-(NSString *)base64DecodeString:(NSString *)string{
    NSData *data=[[NSData alloc]initWithBase64EncodedString:string options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}


@end
