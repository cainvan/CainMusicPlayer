//
//  NetMusicTableViewCell.m
//  CainMusicPlayer
//
//  Created by Cain on 16/5/4.
//  Copyright © 2016年 Cain. All rights reserved.
//

#import "NetMusicTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AudioButton.h"

@implementation NetMusicTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化
        [self createView];
    }
    return  self;
}
// 在cell中重写setFrame方法，可以改变cell默认的320宽度。
- (void)setFrame:(CGRect)frame
{
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    [super setFrame:frame];
    
}

- (void)createView{
    self.myImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 20, 200, 30)];
    //self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:22];
    self.artLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 60, 200, 30)];
    self.artLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    self.audioButton = [[AudioButton alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width-80, 30, 60, 60)];
    // NSLog(@"%f",self.contentView.frame.size.width);
    self.likeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width-130, 45, 30, 30)];
    
    
    [self.contentView addSubview:self.myImage];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.artLabel];
    [self.contentView addSubview:self.audioButton];
    [self.contentView addSubview:self.likeButton];
    
}

- (void)configCellWithSongDic:(NSDictionary *)dic {
    if ([[dic objectForKey:@"flag"] integerValue] == 0) {
        self.myImage.image = [dic objectForKey:@"image"];
        self.titleLabel.text = [dic objectForKey:@"song"];
        self.artLabel.text = [dic objectForKey:@"art"];
        
    }else if ([[dic objectForKey:@"flag"] integerValue] == 1){
        // NSDictionary *dic = @{@"flag":@"1",@"name":name,@"art":art,@"imageUrl":imageUrl,@"songUrl":songUrl};
        //[self.myImage sd_setImageWithURL:[dic objectForKey:@"imageUrl"]];
        [self.myImage sd_setImageWithURL:[dic objectForKey:@"imageUrl"] placeholderImage:[UIImage imageNamed:@"player_albumcover_default@2x"]];
        self.titleLabel.text = [dic objectForKey:@"name"];
        self.artLabel.text = [dic objectForKey:@"art"];
        [self.likeButton setImage:[UIImage imageNamed:@"kg_btn_hasfavorite_default"] forState:UIControlStateNormal];
        
    }
}

@end
