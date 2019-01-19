//
//  User.h
//  Dirtoon
//
//  Created by godloong on 2019/1/8.
//  Copyright © 2019 godloong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject<NSSecureCoding>

+ (User*)load;

- (User*)initWithDic:(NSDictionary *)dic;

- (void)logout;

- (void)save;

@property (strong, nonatomic) NSString *userId;

@property (strong, nonatomic) NSString *userName;

@property (strong, nonatomic) NSString *token;

@property (strong, nonatomic) NSString *price;

@property (strong, nonatomic) NSString *udid;

@end

NS_ASSUME_NONNULL_END
