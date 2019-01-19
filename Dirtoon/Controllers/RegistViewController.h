//
//  SignViewController.h
//  Dirtoon
//
//  Created by godloong on 2019/1/8.
//  Copyright © 2019 godloong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginRegistField.h"


NS_ASSUME_NONNULL_BEGIN

@interface RegistViewController : UIViewController

@property (strong, nonatomic) LoginRegistField *usernameField;

@property (strong, nonatomic) LoginRegistField *passwordField;

@property (strong, nonatomic) LoginRegistField *QQField;

@end

NS_ASSUME_NONNULL_END
