//
//  MainPageViewController.m
//  CainMusicPlayer
//
//  Created by Cain on 16/3/12.
//  Copyright © 2016年 Cain. All rights reserved.
//

#import "MainPageViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "lyjControl.h"
#import "NativeMusicViewController.h"
#import "SearchMusicViewController.h"
#import "MyCollectionViewController.h"
#import "UMSocial.h"

#define WIDTH  [UIScreen mainScreen].applicationFrame.size.width
#define HEIGHT [UIScreen mainScreen].applicationFrame.size.height

@interface MainPageViewController ()<AVAudioPlayerDelegate,PlayMusicDelegate>
{
    UILabel * _titleLabel;
    UILabel * _artistLabel;
    UIImageView * _photoImage;
    UISlider * _slider;
    UIButton * _preBt;
    UIButton * _nextBt;
    UIButton * _playBt;
    AVAudioPlayer * audioPlayer;
    NSArray * musicArray;
    int index;
    
    NSTimer * _timer;
    
    UILabel * _nowTimeLabel;
    UILabel * _allTimeLabel;
    //旋转角度
    float rad ;
    
}

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    musicArray = @[@"玉置浩二 - Friend",@"马頔 - 南山南",@"马潇与灰杜鹃 - 唤醒披头士",@"Lia - 鳥の詩"];
    index = 0;
    [self descripSelf];
    [self createView];
    
    
}

- (void)descripSelf {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.08 green:0.16 blue:0.22 alpha:1];

}

- (void)createAudioPlayer{
    NSError *err = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:musicArray[index] ofType:@"mp3"];
    [self getMetaInfoWithAudioFilename:filePath];
    
    if (!audioPlayer) {
        [audioPlayer stop];
    }
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&err];
    
    if (!err) {
        audioPlayer.delegate = self;
        // 音量
        audioPlayer.volume = 1;
        // 循环播放的次数(负数表示无限循环，0表示不循环，正数表示循环次数)
        audioPlayer.numberOfLoops = 0;
        
        // 缓冲音频文件
        [audioPlayer prepareToPlay];
        // 开始播放
        [audioPlayer play];
    }
    else {
        NSLog(@"创建音频播放器失败!!!");
    }
    
    //
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeSlider) userInfo:nil repeats:YES];
        [_timer fire];
        
    }
    
}
- (void)changeSlider{
    //＝＝１表示有手指操控
    if (_slider.touchInside ==1) {
        //当手指操控slider时停止计算播放时间的位置
        return;
    }
    
    _allTimeLabel.text = [self changeShowTimeStyle:audioPlayer.duration];
    
    _nowTimeLabel.text = [self changeShowTimeStyle:audioPlayer.currentTime];
    
    _slider.value = audioPlayer.currentTime/audioPlayer.duration;
    
    ////旋转
    [self rotationView];
}

////旋转
- (void)rotationView{
    
    if ([audioPlayer isPlaying]) {
        if (rad == M_PI * 2) {
            rad = 0;
        }
        rad +=  M_PI_2/90.0/6.0;
    }
    
    CGAffineTransform rotation = CGAffineTransformMakeRotation(rad);
    [_photoImage setTransform:rotation];
    
}

- (NSString *)changeShowTimeStyle:(int)a{
    NSString * b;
    int m1 = (int)a/60;
    int s1 = (int)a%60;
    NSString * mStr1;
    NSString * sStr1;
    
    if (m1/10<1) {
        mStr1 = [NSString stringWithFormat:@"0%d",m1];
    }else{
        mStr1 = [NSString stringWithFormat:@"%d",m1];
    }
    if (s1/10<1) {
        sStr1 = [NSString stringWithFormat:@"0%d",s1];
    }else{
        sStr1 = [NSString stringWithFormat:@"%d",s1];
    }
    b = [NSString stringWithFormat:@"%@:%@",mStr1,sStr1];
    return b;
    
}
// 根据指定的音频文件的路径获取该文件的元数据信息
- (void) getMetaInfoWithAudioFilename:(NSString *) filename {
    // 创建一个音频文件元数据信息持有者对象
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:filename] options:nil];
    // 获得音频文件所有可用的格式中的第一个格式
    NSString *format = [[asset availableMetadataFormats] firstObject];
    for (AVMetadataItem *item in [asset metadataForFormat:format]) {
        // 每个AVMetadataItem都代表一项元数据
        if ([item.commonKey isEqualToString:@"artist"]) {
            _artistLabel.text = [NSString stringWithFormat:@"━━ %@ ━━",(id)item.value];
        }
        else if([item.commonKey isEqualToString:@"artwork"]) {
            _photoImage.image = [UIImage imageWithData:(id)item.value];
        }
        else if([item.commonKey isEqualToString:@"title"]) {
            _titleLabel.text = (id)item.value;
        }
    }
    
}
//建立视图界面
- (void)createView{
    
    UIImageView * background = [lyjControl createImageViewWithImageName:@"player_albumblur_default@2x" Frame:[UIScreen mainScreen].bounds];
    [self.view addSubview:background];
    _titleLabel = [lyjControl createLabelWithText:@"頂之座正凯的播放器" TextColor:[UIColor colorWithRed:0.85 green:0.87 blue:0.89 alpha:0.9] Frame:CGRectMake(WIDTH/5, HEIGHT/6, WIDTH-2*WIDTH/5, 30) FontSize:20 BackgroundColor:[UIColor clearColor] TextAlignment:NSTextAlignmentCenter IfFitWidth:NO];
    [self.view addSubview:_titleLabel];
    
    _artistLabel = [lyjControl createLabelWithText:@"━━ by CainZK ━━" TextColor:[UIColor colorWithRed:0.85 green:0.87 blue:0.89 alpha:0.7] Frame:CGRectMake(WIDTH/4, HEIGHT/6+30, WIDTH-2*WIDTH/4, 30) FontSize:15 BackgroundColor:[UIColor clearColor] TextAlignment:NSTextAlignmentCenter IfFitWidth:NO];
    [self.view addSubview:_artistLabel];
    
    
    UIImageView * backPhotoImage = [lyjControl createImageViewWithImageName:@"player_albumcover_default@2x" Frame:CGRectMake(WIDTH/2-WIDTH/2/2-10, HEIGHT/6+50+30-10, WIDTH/2+20,WIDTH/2+20)];
    backPhotoImage.backgroundColor = [UIColor colorWithRed:0.07 green:0.07 blue:0.07 alpha:0.5];
    backPhotoImage.layer.masksToBounds = YES;
    backPhotoImage.layer.cornerRadius = (WIDTH/2+20)/2;
    [self.view addSubview:backPhotoImage];
    
    
    _photoImage = [lyjControl createImageViewWithImageName:nil Frame:CGRectMake(WIDTH/2-WIDTH/2/2, HEIGHT/6+50+30, WIDTH/2,WIDTH/2)];
    _photoImage.layer.masksToBounds = YES;
    _photoImage.layer.cornerRadius = WIDTH/2/2;
    [self.view addSubview:_photoImage];
    
    _slider = [[UISlider alloc]initWithFrame:CGRectMake(WIDTH/5,  HEIGHT/6+50+30+WIDTH/2+50+30,WIDTH-2*WIDTH/5,10)];
    _slider.minimumValue =0;
    _slider.maximumValue = 1;
    _slider.continuous = NO;
    _slider.minimumTrackTintColor = [UIColor colorWithRed:0.14 green:0.75 blue:0.49 alpha:1];
    [_slider setMinimumTrackImage:[UIImage imageNamed:@"player_slider_playback_left@2x"] forState:UIControlStateNormal];
    [_slider setMaximumTrackImage:[UIImage imageNamed:@"player_slider_playback_right@2x"] forState:UIControlStateNormal];
    [_slider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb@2x"] forState:UIControlStateNormal];
    [_slider addTarget:self action:@selector(changeTime) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_slider];
    
    _preBt = [lyjControl createButtonWithTitle:nil TitleColor:nil Target:self Sel:@selector(goPre) Event:UIControlEventTouchUpInside BackGroundImage:@"player_btn_pre_normal@2x" Image:nil BackgroundColor:[UIColor clearColor] FontSize:20 Frame:CGRectMake(WIDTH/3- 128/2/2-30, HEIGHT/6+50+30+WIDTH/2+50+20+50, 128/2, 128/2)];
    [_preBt setImage:[UIImage imageNamed:@"player_btn_pre_highlight@2x"] forState:UIControlStateHighlighted];
    _playBt = [lyjControl createButtonWithTitle:nil TitleColor:nil Target:self Sel:@selector(goPlay) Event:UIControlEventTouchUpInside BackGroundImage:@"player_btn_play_normal@2x" Image:nil BackgroundColor:[UIColor clearColor] FontSize:20 Frame:CGRectMake(WIDTH/2-128/2/2, HEIGHT/6+50+30+WIDTH/2+50+20+50, 128/2, 128/2)];
    [_playBt setBackgroundImage:[UIImage imageNamed:@"player_btn_play_highlight@2x"] forState:UIControlStateHighlighted];
    _nextBt = [lyjControl createButtonWithTitle:nil TitleColor:nil Target:self Sel:@selector(goNext) Event:UIControlEventTouchUpInside BackGroundImage:@"player_btn_next_normal@2x" Image:nil BackgroundColor:[UIColor clearColor] FontSize:20 Frame:CGRectMake(2*WIDTH/3+30- 128/2/2, HEIGHT/6+50+30+WIDTH/2+50+20+50, 128/2, 128/2)];
    [_nextBt setBackgroundImage:[UIImage imageNamed:@"player_btn_next_highlight@2x"]  forState:UIControlStateHighlighted];
    
    [self.view addSubview:_preBt];
    [self.view addSubview:_playBt];
    [self.view addSubview:_nextBt];
    
    
    _nowTimeLabel = [lyjControl createLabelWithText:@"00:00" TextColor:[UIColor colorWithRed:0.85 green:0.87 blue:0.89 alpha:0.6] Frame:CGRectMake(WIDTH/5-50,  HEIGHT/6+50+30+WIDTH/2+50-5+30,40,20) FontSize:13 BackgroundColor:[UIColor clearColor] TextAlignment:NSTextAlignmentCenter IfFitWidth:NO];
    [self.view addSubview:_nowTimeLabel];
    
    _allTimeLabel = [lyjControl createLabelWithText:@"00:00" TextColor:[UIColor colorWithRed:0.85 green:0.87 blue:0.89 alpha:0.6] Frame:CGRectMake(WIDTH/5+WIDTH-2*WIDTH/5+10,  HEIGHT/6+50+30+WIDTH/2+50-5+30,40,20) FontSize:13 BackgroundColor:[UIColor clearColor] TextAlignment:NSTextAlignmentCenter IfFitWidth:NO];
    [self.view addSubview:_allTimeLabel];
    
    // 侧边栏图片设置以及代理设置
    NSArray *imageList = @[[UIImage imageNamed:@"音乐图标1(1).png"], [UIImage imageNamed:@"音乐图标(1).png"],[UIImage imageNamed:@"attention.png"],[UIImage imageNamed:@"myimage.png"]];
    sideBar = [[CDSideBarController alloc] initWithImages:imageList];
    sideBar.delegate = self;
}

- (void)changeTime{
    
    if (audioPlayer) {
        NSTimeInterval time1 = audioPlayer.duration*_slider.value;
        audioPlayer.currentTime=time1;
        
    }
}
- (void)goPre{
    
    if(![audioPlayer isPlaying] || (_slider.value== 0))
    {
        [_playBt setBackgroundImage:[UIImage imageNamed:@"player_btn_pause_normal@2x"] forState:UIControlStateNormal];
        [_playBt setBackgroundImage:[UIImage imageNamed:@"player_btn_pause_highlight@2x"] forState:UIControlStateHighlighted];
    }
    if (index == 0) {
        index = (int)(musicArray.count-1);
    }else{
        index -= 1;
    }
    [self createAudioPlayer];
    
}
- (void)goPlay{
    
    if (audioPlayer) {
        
        if (audioPlayer.isPlaying == YES) {
            [audioPlayer pause];
            [_playBt setBackgroundImage:[UIImage imageNamed:@"player_btn_play_normal@2x"] forState:UIControlStateNormal];
            [_playBt setBackgroundImage:[UIImage imageNamed:@"player_btn_play_highlight@2x"] forState:UIControlStateHighlighted];
            
        }else{
            [audioPlayer play];
            [_playBt setBackgroundImage:[UIImage imageNamed:@"player_btn_pause_normal@2x"] forState:UIControlStateNormal];
            [_playBt setBackgroundImage:[UIImage imageNamed:@"player_btn_pause_highlight@2x"] forState:UIControlStateHighlighted];
        }
        
    }else{
        [_playBt setBackgroundImage:[UIImage imageNamed:@"player_btn_pause_normal@2x"] forState:UIControlStateNormal];
        [_playBt setBackgroundImage:[UIImage imageNamed:@"player_btn_pause_highlight@2x"] forState:UIControlStateHighlighted];
        
        [self createAudioPlayer];
    }
}

- (void)goNext{
    if(![audioPlayer isPlaying] || (_slider.value== 0))
    {
        [_playBt setBackgroundImage:[UIImage imageNamed:@"player_btn_pause_normal@2x"] forState:UIControlStateNormal];
        [_playBt setBackgroundImage:[UIImage imageNamed:@"player_btn_pause_highlight@2x"] forState:UIControlStateHighlighted];
    }
    
    if (index == musicArray.count-1) {
        index = 0;
    }else{
        index += 1;
    }
    [self createAudioPlayer];
}
// 音频播放完成后的回调方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    index = (index + 1) % musicArray.count;
    
    [self createAudioPlayer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [sideBar insertMenuButtonOnView:self.view atPosition:CGPointMake(self.view.frame.size.width - 70, 50)];
    //self.navigationController.navigationBar.hidden = YES;
   // [sideBar insertMenuButtonOnView:[UIApplication sharedApplication].delegate.window atPosition:CGPointMake(self.view.frame.size.width - 70, 50)];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - CDSideBarController delegate
// 按钮跳转页面
- (void)menuButtonClicked:(int)index1 {
    if (index1 == 0) {
        NativeMusicViewController *nativeVc = [[NativeMusicViewController alloc] init];
        nativeVc.delegate = self;
        [self.navigationController pushViewController:nativeVc animated:YES];
    }else if(index1 == 1){
        SearchMusicViewController *searchVc = [[SearchMusicViewController alloc] init];
        [self.navigationController pushViewController:searchVc animated:YES];
    }else if(index1 == 2){
        MyCollectionViewController *collectVc = [[MyCollectionViewController alloc] init];
        [self.navigationController pushViewController:collectVc animated:YES];
    }else {
        [self shareBtClick];
    }
}

// 分享
- (void)shareBtClick {
    //[UMSocialSnsServicepresentSnsIconSheetView:selfappKey:APPKEYshareText:@"好开心啊，今天又没有吃药！" shareImage:[UIImage imageNamed:@"001.gif"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToQzone,UMShareToSina,UMShareToTencent,UMShareToRenren,nil] delegate:nil];
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"57355f3e67e58ed0a50030a1" shareText:@"正凯的毕业设计。  http://my.oschina.net/u/2517891/blog" shareImage:[UIImage imageNamed:@"Iconlll.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToQzone,UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQQ,nil] delegate:nil];
}

#pragma - mark 音乐播放代理方法实现
- (void)PlayMusic:(int)index2 {
    index = index2;
    if (audioPlayer) {
        
        audioPlayer = nil;
        [_playBt setBackgroundImage:[UIImage imageNamed:@"player_btn_pause_normal@2x"] forState:UIControlStateNormal];
        [_playBt setBackgroundImage:[UIImage imageNamed:@"player_btn_pause_highlight@2x"] forState:UIControlStateHighlighted];
        
        [self createAudioPlayer];
        
    }else{
        [_playBt setBackgroundImage:[UIImage imageNamed:@"player_btn_pause_normal@2x"] forState:UIControlStateNormal];
        [_playBt setBackgroundImage:[UIImage imageNamed:@"player_btn_pause_highlight@2x"] forState:UIControlStateHighlighted];
        
        [self createAudioPlayer];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
   // UIButton *bt = (UIView *)
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
