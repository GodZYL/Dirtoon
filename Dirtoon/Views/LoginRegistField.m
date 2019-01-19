//
//  LoginSignField.m
//  Dirtoon
//
//  Created by godloong on 2019/1/8.
//  Copyright © 2019 godloong. All rights reserved.
//

#import "LoginRegistField.h"

@implementation LoginRegistField

- (instancetype)init {
    if (self = [super init]) {
        self.layer.cornerRadius = SCREEN_WIDTH/375*15;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = UIColorWithRGBA(43, 125, 188, 1).CGColor;
        self.layer.borderWidth = SCREEN_WIDTH/375*1;
        self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/375*65, SCREEN_WIDTH/375*50)];
        _leftLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*18];
        _leftLabel.textColor = UIColorWithRGBA(43, 125, 188, 1);
        self.leftView = _leftLabel;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*18];
        [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [self setAutocorrectionType:UITextAutocorrectionTypeNo];
        
    }
    return self;
}
@end
