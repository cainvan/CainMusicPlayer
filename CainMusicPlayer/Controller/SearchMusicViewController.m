//
//  SearchMusicViewController.m
//  CainMusicPlayer
//
//  Created by Cain on 16/3/14.
//  Copyright © 2016年 Cain. All rights reserved.
//

#import "SearchMusicViewController.h"
#import "NetMusicTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking.h"
#import "AudioPlayer.h"
#import "AudioButton.h"
#import "MJRefresh.h"
#import "DBManager.h"

@interface SearchMusicViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    NSMutableArray *musicArray;
    AFHTTPRequestOperationManager * _requestManager;
    UITableView *_NativeMusicTableView;
    NSString *searchText;
}

@end

@implementation SearchMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *MyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    MyTitleLabel.text = @"搜索";
    MyTitleLabel.textAlignment = NSTextAlignmentCenter;
    MyTitleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = MyTitleLabel;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self createView];
}

- (void)createView {
    _NativeMusicTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _NativeMusicTableView.delegate = self;
    _NativeMusicTableView.dataSource = self;
    _NativeMusicTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_NativeMusicTableView];
    
    // 添加下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 1;
        [self requestDataWithPage:_currentPage-1 andKeyWord:searchText];
    }];
    _NativeMusicTableView.header = header;
    // 添加上拉刷新
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _currentPage++;
        [self requestDataWithPage:_currentPage-1 andKeyWord:searchText];
    }];
    _NativeMusicTableView.footer = footer;
    //关闭下拉刷新自动刷新功能
    footer.automaticallyRefresh = NO;
    
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

// 请求数据方法
- (void)requestDataWithPage:(NSUInteger)page andKeyWord:(NSString *)keyWord
{
    NSString *url = [NSString stringWithFormat:@"http://s.music.163.com/search/get/?src=&type=1&filterDj=true&s=%@&limit=10&offset=%ld&callback=",keyWord,page];
    // 使用get方法请求数据
    // text/html，Application/JSON，text/XML(NSXMLParser)
    
    // URL地址需要编码，当出现非ASCCI码，需要对其他字符集做编码处理
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (!musicArray) {
        musicArray = [[NSMutableArray alloc] init];
    }
    if (!_requestManager) {
        _requestManager = [AFHTTPRequestOperationManager manager];
    }
    // 如果是第一页，那么移除数组所有元素
   
    [_requestManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@", responseObject);
        //musicArray = [[responseObject objectForKey:@"result"] objectForKey:@"songs"];
        if (page == 0) {
            [musicArray removeAllObjects];
        }
        NSArray *arrTemp = [[responseObject objectForKey:@"result"] objectForKey:@"songs"];
        for (int i = 0; i<arrTemp.count ; i++) {
            [musicArray addObject:arrTemp[i]];
        }
//        for (int i = 0; i < arrTemp.count; i++) {
//            NSString *name = [arrTemp[i] objectForKey:@"name"];
//            NSString *art = [[[arrTemp[i] objectForKey:@"artists"] objectAtIndex:0] objectForKey:@"name"];
//            NSString *imageUrl = [[arrTemp[i] objectForKey:@"album"] objectForKey:@"picUrl"];
//            NSString *songUrl = [arrTemp[i] objectForKey:@"audio"];
//            NSMutableDictionary *dicTemp = [[NSMutableDictionary alloc] init];
//            
//        }
        //NSLog(@"%@",musicArray);
        NSLog(@"%ld",musicArray.count);
        [_NativeMusicTableView reloadData];
        [_NativeMusicTableView.header endRefreshing];
        [_NativeMusicTableView.footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 如果是上拉刷新请求数据失败
        if (_NativeMusicTableView.footer.state == MJRefreshStateRefreshing) {
            self.currentPage--;
            if (self.currentPage < 1) {
                self.currentPage = 1;
            }
            [_NativeMusicTableView.footer endRefreshing];
        }
        [_NativeMusicTableView.header endRefreshing];
        
    }];
}

#pragma - mark NativeMusicTableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return musicArray.count;
    //return 8;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //static NSString * ID = @"id";
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
    
    NSString *name = [musicArray[indexPath.row] objectForKey:@"name"];
    NSString *art = [[[musicArray[indexPath.row] objectForKey:@"artists"] objectAtIndex:0] objectForKey:@"name"];
    NSString *imageUrl = [[musicArray[indexPath.row] objectForKey:@"album"] objectForKey:@"picUrl"];
    NSString *songUrl = [musicArray[indexPath.row] objectForKey:@"audio"];

    NSDictionary *dic = @{@"flag":@"1",@"name":name,@"art":art,@"imageUrl":imageUrl,@"songUrl":songUrl};
    [cell configCellWithSongDic:dic];
    
    // 判断当前歌曲是否已收藏
    BOOL isCollection = [[DBManager sharedManager] isExsitsWithAppId:songUrl];
    if (isCollection) {
        [cell.likeButton setTitle:@"已收藏" forState:UIControlStateNormal];
        cell.likeButton.enabled = NO;
    }
    //cell.likeButton.enabled = NO;
    [cell.audioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];

    [cell.likeButton addTarget:self action:@selector(likeMusic:) forControlEvents:UIControlEventTouchUpInside];
    // 判断当前歌曲是否已收藏
//    BOOL isCollection = [[DBManager sharedManager] isExsitsWithAppId:songUrl];
//    if (isCollection) {
//        [cell.likeButton setTitle:@"已收藏" forState:UIControlStateNormal];
//        cell.likeButton.enabled = NO;
//    }
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
        _audioPlayer.url = [NSURL URLWithString:[musicArray[index] objectForKey:@"audio"]];
        [_audioPlayer play];
    }
}

- (void)likeMusic:(UIButton *)likeButton{
    
    NSInteger index = likeButton.tag - 1000;
    
    // 创建
    DBCollectionModel * model = [[DBCollectionModel alloc] init];
    model.musicUrl = [musicArray[index] objectForKey:@"audio"];
    model.songName = [musicArray[index] objectForKey:@"name"];
    model.musicImage = [[musicArray[index] objectForKey:@"album"] objectForKey:@"picUrl"];
    model.art = [[[musicArray[index] objectForKey:@"artists"] objectAtIndex:0] objectForKey:@"name"];
    
    // 将数据添加到数据库中
    [[DBManager sharedManager] addCollectionModel:model];
    
    [likeButton setTitle:@"已收藏" forState:UIControlStateNormal];
    
    likeButton.enabled = NO;
    
    NSLog(@"%@", NSHomeDirectory());

    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[self.delegate PlayMusic:(int)indexPath.row];
    //取消选择 并且有动画效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSInteger index = indexPath.row;
//    NSDictionary *item = [musicArray objectAtIndex:index];
//    
//    if (_audioPlayer == nil) {
//        _audioPlayer = [[AudioPlayer alloc] init];
//    }
//    
//    //if ([_audioPlayer.button isEqual:button]) {
//     //   [_audioPlayer play];
//    //} else {
//        [_audioPlayer stop];
//        
//        //_audioPlayer.button = button;
//        _audioPlayer.url = [NSURL URLWithString:[musicArray[indexPath.row] objectForKey:@"audio"]];
//        
//        [_audioPlayer play];
//   // }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UISearchBar *mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    mySearchBar.delegate = self;
    mySearchBar.showsCancelButton = YES;
    mySearchBar.tintColor = [UIColor blackColor];
    return mySearchBar;
}

#pragma - mark searchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
    searchText = searchBar.text;
    [self requestDataWithPage:0 andKeyWord:searchBar.text];
    //NSLog(@"...");
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
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
