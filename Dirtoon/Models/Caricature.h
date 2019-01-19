//
//  Caricature.h
//  Dirtoon
//
//  Created by godloong on 2019/1/7.
//  Copyright © 2019 godloong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Caricature : NSObject

- (Caricature*)initWithDic:(NSDictionary *)dic;

+ (NSArray*)caricaturesWithArray:(NSArray *)array;

@property (assign, nonatomic) int carId;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSURL *cover;

@property (assign, nonatomic) int chapterCount;

@property (strong, nonatomic) NSString *star;

@property (strong, nonatomic) NSString *end;

@end

NS_ASSUME_NONNULL_END
