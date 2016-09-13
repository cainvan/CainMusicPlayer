//
//  NativeMusicViewController.h
//  CainMusicPlayer
//
//  Created by Cain on 16/3/14.
//  Copyright © 2016年 Cain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayMusicDelegate <NSObject>

- (void)PlayMusic:(int)index2;

@end

@interface NativeMusicViewController : UIViewController

@property(nonatomic,strong)id<PlayMusicDelegate> delegate;

@end
