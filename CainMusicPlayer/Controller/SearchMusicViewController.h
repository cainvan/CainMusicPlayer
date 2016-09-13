//
//  SearchMusicViewController.h
//  CainMusicPlayer
//
//  Created by Cain on 16/3/14.
//  Copyright © 2016年 Cain. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AudioPlayer;

@interface SearchMusicViewController : UIViewController
{
    AudioPlayer *_audioPlayer;
}

@property (nonatomic, assign) NSInteger currentPage; //当前页

@end
