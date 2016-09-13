//
//  MyTableViewCell.h
//  CainMusicPlayer
//
//  Created by Cain on 16/3/14.
//  Copyright © 2016年 Cain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *myImage;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *artLabel;

- (void) configCellWithSongDic:(NSDictionary *)dic;

@end
