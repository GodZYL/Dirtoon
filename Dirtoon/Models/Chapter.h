//
//  Chapter.h
//  Dirtoon
//
//  Created by godloong on 2019/1/7.
//  Copyright © 2019 godloong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Chapter : NSObject

- (Chapter*)initWithDic:(NSDictionary *)dic;

+ (NSArray*)chaptersWithArray:(NSArray *)array;

@property (assign, nonatomic) int chaid;

@property (assign, nonatomic) int sort;

@property (strong, nonatomic) NSURL *cover;

@property (assign, nonatomic) int price;

@property (strong, nonatomic) NSArray *pics;

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *payed;

@end

NS_ASSUME_NONNULL_END
