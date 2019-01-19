//
//  Connect.h
//  Dirtoon
//
//  Created by godloong on 2019/1/6.
//  Copyright © 2019 godloong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Connect : NSObject

@property (strong, nonatomic) NSString *rechargeURL;

+ (instancetype)sharedConnect;

+ (void)getIPsuccess:(void (^)(NSString *IP))success failure:(void (^)(NSError *error))failure;

- (void)checkVersion;

- (void)getCaricaturesWithlimit:(int)limit
                        offset:(int)offset
                       success:(void (^)(NSArray *responseArray))success
                       failure:(void (^)(NSError *error))failure;

- (void)getChaptersWithCarid:(int)carid
                     success:(void (^)(NSArray *responseArray))success
                     failure:(void (^)(NSError *error))failure;

- (void)getChapterWithCarid:(int)carid
                       sort:(int)sort
                     success:(void (^)(NSDictionary *responseDic))success
                     failure:(void (^)(NSError *error))failure;

- (void)registWithUsername:(NSString *)username
                  password:(NSString *)password
                      udid:(NSString *)udid
                        qq:(NSString *)qq
                   success:(void (^)(id  _Nullable responseObj))success
                   failure:(void (^)(NSError *error))failure;

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                     udid:(NSString *)udid
                  success:(void (^)(id  _Nullable responseObj))success
                  failure:(void (^)(NSError *error))failure;

- (void)payChapterWithChaid:(int)chaid
                    success:(void (^)(id _Nullable))success
                    failure:(void (^)(NSError * _Nonnull))failure;

- (void)payChaptersWithCarid:(int)carid
                    success:(void (^)(id  _Nullable responseObj))success
                    failure:(void (^)(NSError *error))failure;

- (void)loadUserWithSuccess:(void (^)(id  _Nullable responseObj))success
                    failure:(void (^)(NSError *error))failure;


@end

NS_ASSUME_NONNULL_END
