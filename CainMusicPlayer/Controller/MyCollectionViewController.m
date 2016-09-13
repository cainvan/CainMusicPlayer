//
//  MyCollectionViewController.m
//  CainMusicPlayer
//
//  Created by Cain on 16/5/11.
//  Copyright © 2016年 Cain. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "DBManager.h"
#import "NetMusicTableViewCell.h"
#import "AudioPlayer.h"
#import "AudioButton.h"

@interface MyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray * _dataArray;
}

@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [[DBManager sharedManager] fetchAllData];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *MyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    MyTitleLabel.text = @"我喜欢的";
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

#pragma - mark NativeMusicTableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NetMusicTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    
    if (cell == nil ) {
        cell = [[NetMusicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    
    //默认点击时的效果
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    //cell的背景色 （tableView 和cell同时设置为clearColro后才能无色）
    cell.backgroundColor = [UIColor clearColor];
    cell.audioButton.tag = indexPath.row;
    cell.likeButton.tag = indexPath.row+1000;
    // cell.backgroundView = nil; //设置cell的背景图
    //cell.contentView.frame = cell.bounds;
    DBCollectionModel *model = _dataArray[indexPath.row];
    NSString *name = model.songName;
    NSString *art = model.art;
    NSString *imageUrl = model.musicImage;
    NSString *songUrl = model.musicUrl;
    
    NSDictionary *dic = @{@"flag":@"1",@"name":name,@"art":art,@"imageUrl":imageUrl,@"songUrl":songUrl};
    [cell configCellWithSongDic:dic];
    
    [cell.audioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
    cell.likeButton.hidden = YES;
    //[cell.likeButton addTarget:self action:@selector(likeMusic:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)playAudio:(AudioButton *)button {
    
    NSInteger index = button.tag;
    //NSDictionary *item = [musicArray objectAtIndex:index];
    
    if (_audioPlayer == nil) {
        _audioPlayer = [[AudioPlayer alloc] init];
    }
    
    if ([_audioPlayer.button isEqual:button]) {
        [_audioPlayer play];
    } else {
        [_audioPlayer stop];
        
        _audioPlayer.button = button;
        DBCollectionModel *model = _dataArray[index];
        _audioPlayer.url = [NSURL URLWithString:model.musicUrl];
        [_audioPlayer play];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选择 并且有动画效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

// 视图即将出现代理

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

// 视图即将消失代理

- (void)viewWillDisappear:(BOOL)animated {
    // 结束编辑
    [self.view endEditing:YES];
    // 停掉音乐
    [_audioPlayer stop];
    _audioPlayer = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
