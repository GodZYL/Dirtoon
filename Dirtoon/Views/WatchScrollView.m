//
//  WatchScrollView.m
//  Dirtoon
//
//  Created by godloong on 2019/1/7.
//  Copyright © 2019 godloong. All rights reserved.
//

#import "WatchScrollView.h"
#import "UIImageView+WebCache.h"

@implementation WatchScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageArray = [[NSMutableArray alloc] init];
        self.imageViewArray = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor blackColor];
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
        [self addSubview:self.activityIndicator];
        self.activityIndicator.frame = CGRectMake(0, 0, SCREEN_WIDTH/375*100, SCREEN_WIDTH/375*100);
        self.activityIndicator.center = CGPointMake(SCREEN_WIDTH/2, SCREENH_HEIGHT/2);
        [self.activityIndicator startAnimating];
    }
    return self;
}

- (void)removeAllImageviews {
    for (UIImageView *imageView in _imageViewArray) {
        imageView.image = nil;
    }
    [_imageArray removeAllObjects];
    self.activityIndicator.center = CGPointMake(SCREEN_WIDTH/2, SCREENH_HEIGHT/2);
    self.contentSize = CGSizeMake(SCREEN_WIDTH, SCREENH_HEIGHT);
}

- (void)loadImagesWithArray:(NSArray *)imageArray {
    if (imageArray == nil) {
        return;
    }
    [_imageArray removeAllObjects];
    [_imageArray addObjectsFromArray:imageArray];
    [self setContentOffset:CGPointMake(0, 0)];
    while (_imageViewArray.count < _imageArray.count) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        [_imageViewArray addObject:imageView];
    }
    
    for (UIImageView *imageView in _imageViewArray) {
        imageView.image = nil;
    }
    self.activityIndicator.center = CGPointMake(SCREEN_WIDTH/2, SCREENH_HEIGHT/2);
    
    dispatch_queue_t queue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_semaphore_t semaphore=dispatch_semaphore_create(1);
    
    for (int i = 0; i < _imageArray.count; i++) {
        dispatch_async(queue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"i == %d,imageviewArray == %lu,imageArray == %lu",i,(unsigned long)self.imageViewArray.count,(unsigned long)self.imageArray.count);
            if (i < self.imageViewArray.count && i < self.imageArray.count) {
                UIImageView *imageView = [self.imageViewArray objectAtIndex:i];
                NSLog(@"url == %@" ,self.imageArray[i]);
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[i]] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (error) {
                        NSLog(@"imageErr === %@",error);
                        dispatch_semaphore_signal(semaphore);
                        return ;
                    } else {
                        if (i == 0) {
                            imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, image.size.height/image.size.width*SCREEN_WIDTH);
                        } else {
                            UIImageView *lastImageView = [self.imageViewArray objectAtIndex:i-1];
                            imageView.frame = CGRectMake(0, lastImageView.frame.size.height+lastImageView.frame.origin.y, SCREEN_WIDTH, image.size.height/image.size.width*SCREEN_WIDTH);
                        }
                        self.activityIndicator.center = CGPointMake(SCREEN_WIDTH/2, imageView.frame.origin.y+imageView.frame.size.height+SCREEN_WIDTH/375*50);
                        if (i+1 >= self.imageArray.count) {
                            self.activityIndicator.center = CGPointMake(SCREEN_WIDTH/2, SCREENH_HEIGHT/2);
                            self.contentSize = CGSizeMake(SCREEN_WIDTH, imageView.frame.origin.y+imageView.frame.size.height);
                        } else {
                            self.contentSize = CGSizeMake(SCREEN_WIDTH, imageView.frame.origin.y+imageView.frame.size.height+SCREEN_WIDTH/375*100);
                        }
                        dispatch_semaphore_signal(semaphore);
                    }
                }];
            } else {
                dispatch_semaphore_signal(semaphore);
                return ;
            }
        });
    }
}

@end
