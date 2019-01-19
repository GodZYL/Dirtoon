//
//  Connect.m
//  Dirtoon
//
//  Created by godloong on 2019/1/6.
//  Copyright © 2019 godloong. All rights reserved.
//

#import "Connect.h"
#import "AFNetworking.h"
#import "User.h"
#import "TabBarViewController.h"
#import "AppDelegate.h"

@implementation Connect
const NSString *regist = @"index.php/v1/interface/regist";
const NSString *signin = @"index.php/v1/interface/signin";
const NSString *savempass = @"index.php/v1/interface/save-mpass";
const NSString *getCaricature = @"index.php/v1/interface/get-caricature";
const NSString *getChapter = @"index.php/v1/interface/get-chapter";
const NSString *payChapter = @"index.php/v1/interface/pay-chapter";
const NSString *payCaricature = @"index.php/v1/interface/pay-caricature";
const NSString *loadUser = @"index.php/v1/interface/loaduser";
static NSString *IP1 = @"";
static NSString *IP2 = @"";
static NSString *IP = @"";
static NSTimeInterval connectTime = 0;
+ (instancetype)sharedConnect {
    static Connect *_connect = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        _connect = [[super allocWithZone:NULL] init];
    });
    return _connect;
}

// 防止外部调用alloc 或者 new
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [Connect sharedConnect];
}

// 防止外部调用copy
- (id)copyWithZone:(nullable NSZone *)zone {
    return [Connect sharedConnect];
}

// 防止外部调用mutableCopy
- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [Connect sharedConnect];
}

+ (void)getIPsuccess:(void (^)(NSString * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer new];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session.requestSerializer setValue:@"I2F0AA4PLcWjN1t0p3PkXxvC-gzGzoHsz"forHTTPHeaderField:@"X-LC-Id"];
    [session.requestSerializer setValue:@"L0lv0Yt2d9k5Dmld9cx71yAB"forHTTPHeaderField:@"X-LC-Key"];
    [session GET:@"https://i2f0aa4p.api.lncld.net/1.1/statistics/apps/I2F0AA4PLcWjN1t0p3PkXxvC-gzGzoHsz/sendPolicy" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        IP = [[dict objectForKey:@"parameters"] objectForKey:@"IP"];
        IP1 = [[dict objectForKey:@"parameters"] objectForKey:@"IP"];
        IP2 = [[dict objectForKey:@"parameters"] objectForKey:@"IP2"];
        [Connect sharedConnect].rechargeURL = [[dict objectForKey:@"parameters"] objectForKey:@"RechargeURL"];
//        IP = @"http://localhost:8080/";
//        IP1 = @"http://localhost:8080/";
//        IP2 = @"http://localhost:8080/";
        success(IP);
        NSLog(@"%@",IP);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        failure(error);
    }];
}

- (void)checkVersion {
    __block NSString * minimumVersion = @"";
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer new];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session.requestSerializer setValue:@"I2F0AA4PLcWjN1t0p3PkXxvC-gzGzoHsz"forHTTPHeaderField:@"X-LC-Id"];
    [session.requestSerializer setValue:@"L0lv0Yt2d9k5Dmld9cx71yAB"forHTTPHeaderField:@"X-LC-Key"];
    [session GET:@"https://i2f0aa4p.api.lncld.net/1.1/statistics/apps/I2F0AA4PLcWjN1t0p3PkXxvC-gzGzoHsz/sendPolicy" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        minimumVersion = [[dict objectForKey:@"parameters"] objectForKey:@"MinimumVersion"];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // app版本
        NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        if ([appVersion floatValue] < [minimumVersion floatValue]) {
            NSString *message = @"版本低于推荐版本,建议更新";
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"有新版本" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://wwxxmm.tk:8011/static/index.html"]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    AppDelegate *app = [UIApplication sharedApplication].delegate;
                    UIWindow *window = app.window;
                    // 动画 1
                    [UIView animateWithDuration:1.0f animations:^{
                        window.alpha = 0;
                        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
                    } completion:^(BOOL finished) {
                        exit(0);
                    }];
                });
            }];
            
            [alertController addAction:okAction];
            dispatch_async(dispatch_get_main_queue(), ^{
                TabBarViewController * tabBarController = [TabBarViewController sharedTabBarViewController];
                [tabBarController presentViewController:alertController animated:YES completion:^{
                    
                }];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)getCaricaturesWithlimit:(int)limit offset:(int)offset success:(void (^)(NSArray * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    if ([IP isEqualToString:@""]) {
        [Connect getIPsuccess:^(NSString * _Nonnull IP) {
            [self getCaricaturesWithlimit:limit offset:offset success:^(NSArray * _Nonnull responseArray) {
                success(responseArray);
            } failure:^(NSError * _Nonnull error) {
                
            }];
        } failure:^(NSError * _Nonnull error) {
            
        }];
    } else {
        __block NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timingAction) userInfo:nil repeats:YES];
        NSString *url = [NSString stringWithFormat:@"%@%@",IP,getCaricature];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:[NSNumber numberWithInt:limit] forKey:@"limit"];
        [parameters setObject:[NSNumber numberWithInt:offset] forKey:@"offset"];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [timer invalidate];
            timer = nil;
            __block NSTimeInterval connectTime1 = connectTime - 0.05;
            connectTime = 0;
            success(responseObject);
            if (offset == 0) {
                __block NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timingAction) userInfo:nil repeats:YES];
                NSString *url = [NSString stringWithFormat:@"%@%@",IP,getCaricature];
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                [parameters setObject:[NSNumber numberWithInt:limit] forKey:@"limit"];
                [parameters setObject:[NSNumber numberWithInt:offset] forKey:@"offset"];
                AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
                [session GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [timer invalidate];
                    timer = nil;
                    if (connectTime1 < connectTime) {
                        IP = IP1;
                    } else {
                        IP = IP2;
                    }
                    NSLog(@"connectTime1 = %.2f,connectTime2 = %.2f,IP = %@",connectTime1,connectTime,IP);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    }
}

- (void)timingAction {
    connectTime += 0.05;
}

- (void)getChaptersWithCarid:(int)carid success:(void (^)(NSArray * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    User *user = [User load];
    NSString *url = [NSString stringWithFormat:@"%@%@",IP,getChapter];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:carid],@"carid", nil];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer new];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    [session.requestSerializer setValue:user.token forHTTPHeaderField:@"token"];
    [session GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)getChapterWithCarid:(int)carid sort:(int)sort success:(void (^)(NSDictionary * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    User *user = [User load];
    NSString *url = [NSString stringWithFormat:@"%@%@",IP,getChapter];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:carid],@"carid",[NSNumber numberWithInt:sort],@"sort", nil];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer new];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    [session.requestSerializer setValue:user.token forHTTPHeaderField:@"token"];
    [session GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)registWithUsername:(NSString *)username password:(NSString *)password udid:(nonnull NSString *)udid qq:(nonnull NSString *)qq success:(nonnull void (^)(id _Nullable))success failure:(nonnull void (^)(NSError * _Nonnull))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",IP,regist];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:username,@"musername",password,@"mpass",udid,@"udid",qq,@"mqq", nil];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer new];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session.requestSerializer setValue:@"application/json;charset=UTF-8"forHTTPHeaderField:@"Content-Type"];
    [session POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password udid:(nonnull NSString *)udid success:(nonnull void (^)(id _Nullable))success failure:(nonnull void (^)(NSError * _Nonnull))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",IP,signin];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:username,@"musername",password,@"mpass",udid,@"udid", nil];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer new];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session.requestSerializer setValue:@"application/json;charset=UTF-8"forHTTPHeaderField:@"Content-Type"];
    [session POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)payChapterWithChaid:(int)chaid success:(void (^)(id _Nullable))success failure:(void (^)(NSError * _Nonnull))failure {
    User *user = [User load];
    NSString *url = [NSString stringWithFormat:@"%@%@",IP,payChapter];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:chaid],@"chaid", nil];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer new];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session.requestSerializer setValue:@"application/json;charset=UTF-8"forHTTPHeaderField:@"Content-Type"];
    [session.requestSerializer setValue:user.token forHTTPHeaderField:@"token"];
    [session POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)payChaptersWithCarid:(int)carid success:(void (^)(id _Nullable))success failure:(void (^)(NSError * _Nonnull))failure {
    User *user = [User load];
    NSString *url = [NSString stringWithFormat:@"%@%@",IP,payCaricature];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:carid],@"carid", nil];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer new];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session.requestSerializer setValue:@"application/json;charset=UTF-8"forHTTPHeaderField:@"Content-Type"];
    [session.requestSerializer setValue:user.token forHTTPHeaderField:@"token"];
    [session POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)loadUserWithSuccess:(void (^)(id _Nullable))success failure:(void (^)(NSError * _Nonnull))failure {
    User *user = [User load];
    NSString *url = [NSString stringWithFormat:@"%@%@",IP,loadUser];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer new];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    [session.requestSerializer setValue:@"application/json;charset=UTF-8"forHTTPHeaderField:@"Content-Type"];
    [session.requestSerializer setValue:user.token forHTTPHeaderField:@"token"];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
