//
//  NativeMusicViewController.m
//  CainMusicPlayer
//
//  Created by Cain on 16/3/14.
//  Copyright © 2016年 Cain. All rights reserved.
//

#import "NativeMusicViewController.h"
#import "MyTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "MainPageViewController.h"

@interface NativeMusicViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray * musicArray;

}

@end

@implementation NativeMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    musicArray = @[@"玉置浩二 - Friend",@"马頔 - 南山南",@"马潇与灰杜鹃 - 唤醒披头士",@"Lia - 鳥の詩"];
    UILabel *MyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    MyTitleLabel.text = @"本地音乐";
    MyTitleLabel.textAlignment = NSTextAlignmentCenter;
    MyTitleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = MyTitleLabel;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self createView];
}

- (void)createView {
    UITableView *NativeMusicTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    NativeMusicTableView.delegate = self;
    NativeMusicTableView.dataSource = self;
    NativeMusicTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:NativeMusicTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark NativeMusicTableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return musicArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * ID = @"ID";
    MyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil ) {
        cell = [[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    //默认点击时的效果
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    //cell的背景色 （tableView 和cell同时设置为clearColro后才能无色）
    cell.backgroundColor = [UIColor clearColor];
    // cell.backgroundView = nil; //设置cell的背景图
    NSString *filename = [[NSBundle mainBundle] pathForResource:musicArray[indexPath.row] ofType:@"mp3"];
    // 创建一个音频文件元数据信息持有者对象
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:filename] options:nil];
    // 获得音频文件所有可用的格式中的第一个格式
    NSString *format = [[asset availableMetadataFormats] firstObject];
    UIImage *myImage;
    NSString *art;
    NSString *songName;
    for (AVMetadataItem *item in [asset metadataForFormat:format]) {
        // 每个AVMetadataItem都代表一项元数据
        if ([item.commonKey isEqualToString:@"artist"]) {
            art = [NSString stringWithFormat:@"%@",(id)item.value];
           // cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",(id)item.value];
            //_artistLabel.text = [NSString stringWithFormat:@"━━ %@ ━━",(id)item.value];
        }
        else if([item.commonKey isEqualToString:@"artwork"]) {
            myImage = [UIImage imageWithData:(id)item.value];
            //cell.imageView.image = [UIImage imageWithData:(id)item.value];
            //cell.imageView.frame = CGRectMake(10, 10, 80, 80);
            //_photoImage.image = [UIImage imageWithData:(id)item.value];
        }
        else if([item.commonKey isEqualToString:@"title"]) {
            songName = (id)item.value;
           // cell.textLabel.text = (id)item.value;
            //_titleLabel.text = (id)item.value;
        }
    }
//    self.myImage.image = [dic objectForKey:@"image"];
//    self.titleLabel.text = [dic objectForKey:@"song"];
//    self.artLabel.text = [dic objectForKey:@"art"];
    NSDictionary *dic = @{@"flag":@"0",@"image":myImage,@"song":songName,@"art":art};
    [cell configCellWithSongDic:dic];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate PlayMusic:(int)indexPath.row];
    //取消选择 并且有动画效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
