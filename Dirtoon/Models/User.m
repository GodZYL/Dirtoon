//
//  User.m
//  Dirtoon
//
//  Created by godloong on 2019/1/8.
//  Copyright © 2019 godloong. All rights reserved.
//

#import "User.h"

@implementation User

MJCodingImplementation

- (User *)initWithDic:(NSDictionary *)dic {
    self = [super init];
    self.userId = [[dic objectForKey:@"Mid"] stringValue];
    self.userName = [dic objectForKey:@"Musername"];
    self.token = [dic objectForKey:@"Token"];
    self.price = [dic objectForKey:@"Mprice"];
    self.udid = [dic objectForKey:@"Udid"];
    return self;
}

+ (BOOL)supportsSecureCoding{
    return YES;
}

- (void)save {
    NSUserDefaults *userDetaults = [NSUserDefaults standardUserDefaults];
    if (@available(iOS 11.0, *)) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:NO error:nil];
        [userDetaults setObject:data forKey:@"User"];
    } else {
        // Fallback on earlier versions
        [userDetaults setObject:[self mj_keyValues] forKey:@"User"];
    }
    [userDetaults synchronize];
}

+ (User *)load {
    if (@available(iOS 11.0, *)) {
        NSError *error;
        NSData *Data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
        User *user = [NSKeyedUnarchiver unarchivedObjectOfClass:[User class] fromData:Data error:&error];
        if (user.userId == nil) {
            user = nil;
        }
        return user;
    } else {
        // Fallback on earlier versions
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
        User *user = [User mj_objectWithKeyValues:dic];
        if (user.userId == nil) {
            user = nil;
        }
        return user;
    }
}

- (void)logout {
    NSUserDefaults *userDetaults = [NSUserDefaults standardUserDefaults];
    [userDetaults removeObjectForKey:@"User"];
    [userDetaults synchronize];
}

@end
