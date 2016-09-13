//
//  NetMusicTableViewCell.h
//  CainMusicPlayer
//
//  Created by Cain on 16/5/4.
//  Copyright © 2016年 Cain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetMusicTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *myImage;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *artLabel;
@property (nonatomic,strong) UIButton *audioButton;
@property (nonatomic,strong) UIButton *likeButton;

- (void) configCellWithSongDic:(NSDictionary *)dic;

@end
