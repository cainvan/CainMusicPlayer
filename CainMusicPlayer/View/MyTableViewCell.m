//
//  MyTableViewCell.m
//  CainMusicPlayer
//
//  Created by Cain on 16/3/14.
//  Copyright © 2016年 Cain. All rights reserved.
//

#import "MyTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation MyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化
        [self createView];
    }
    return  self;
}
- (void)createView{
    self.myImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 20, 200, 30)];
    //self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:22];
    self.artLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 60, 200, 30)];
    self.artLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    
    [self.contentView addSubview:self.myImage];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.artLabel];
    
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
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
