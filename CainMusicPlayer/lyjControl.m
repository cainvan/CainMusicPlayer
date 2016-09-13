//
//  lyjControl.m
//  工厂类
//
//  Created by Cain on 15/9/6.
//  Copyright (c) 2015年 Cain. All rights reserved.
//

#import "lyjControl.h"

@implementation lyjControl
//创建Label
+(UILabel *)createLabelWithText:(NSString *)text TextColor:(UIColor*)color Frame:(CGRect)frame FontSize:(int)fontsize BackgroundColor:(UIColor*)color1 TextAlignment:(NSTextAlignment)textAlignment IfFitWidth:(BOOL)fitwidth{
    
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.textColor = color;
    label.backgroundColor = color1;
    label.font = [UIFont systemFontOfSize:fontsize];
    label.textAlignment = textAlignment;
    label.userInteractionEnabled = YES;
    label.adjustsFontSizeToFitWidth = fitwidth;
    return label;
}
//创建ImageView
+(UIImageView*)createImageViewWithImageName:(NSString *)imagename Frame:(CGRect)frame{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imagename];
    imageView.userInteractionEnabled = YES;
    return imageView;
}

//创建Button
+(UIButton*)createButtonWithTitle:(NSString *)title TitleColor:(UIColor*)titlecolor Target:(id)target Sel:(SEL)sel Event:(UIControlEvents)event BackGroundImage:(NSString *)imageName Image:(NSString*)imageName1 BackgroundColor:(UIColor*)color FontSize:(int)fontsize Frame:(CGRect)frame{
    UIButton * bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = frame;
    [bt setTitle:title forState:UIControlStateNormal];
    [bt setTitleColor:titlecolor forState:UIControlStateNormal];
    bt.backgroundColor = color;
    bt.titleLabel.font = [UIFont systemFontOfSize:fontsize];
    [bt setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [bt setImage:[UIImage imageNamed:imageName1] forState:UIControlStateNormal];
    [bt addTarget:target action:sel forControlEvents:event];
    bt.userInteractionEnabled = YES;
     bt.layer.cornerRadius =5;
    
    return bt;
}

//创建TextField
+ (UITextField*)createTextFieldWithFrame:(CGRect)frame PlaceHolder:(NSString*)placeholder FontSize:(float)fontsize TextColor:(UIColor*)color BackGroundColor:(UIColor*)color1{
//    textField.borderStyle = UITextBorderStyleRoundedRect;
    //输入框的格式
    UITextField * textField = [[UITextField alloc]initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:fontsize];
    textField.textColor = color;
    textField.userInteractionEnabled = YES;
    textField.backgroundColor = color1;
    return textField;
}
//创建广告视图 imageArr图片数组   time每张图切换间隔时间  frame图片放在页面的位置
//UIScrollView pageControl
//+ (void)createAdvertisementWithImageArr:(NSArray*)arr andIntervalTime:(NSString*)time andCGRectFrame:(CGRect)frame{
//    
//    UIScrollView * sc = [[UIScrollView alloc]initWithFrame:frame];
//    //总大小
//    sc.contentSize = CGSizeMake(frame.size.width * (arr.count +2),frame.size.height);
//    //设置不显示滑动的条
//    sc.showsHorizontalScrollIndicator = NO;
//    sc.showsVerticalScrollIndicator = NO;
//    //设置翻页属性
//    sc.pagingEnabled = YES;
//    //设置反弹属性
//    sc.bounces = NO;
//    sc.delegate = self;
//    for (int i=0; i < (arr.count +2); i++) {
//        UIImageView * imageView = [lyjControl createImageViewWithImageName:arr[i-1] Frame:CGRectMake(frame.origin.x * i, frame.origin.y, frame.size.width, frame.size.height)];
//        if (i == arr.count+1) {
//            imageView.image = [UIImage imageNamed:arr[0]];
//        }
//        if (i == 0) {
//            imageView.image = [UIImage imageNamed:arr[arr.count-1]];
//        }
//        [sc addSubview:imageView];
//        
//    }
//    
//    //最开始因为前面放的是最后一张图  所以要显示第一张图直接偏移
//    sc.contentOffset = CGPointMake(frame.origin.x+frame.size.width, frame.origin.y);
//    
//    
//    
//    
//    
//}
//判断是否是电话号
+(BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    // NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    //
    NSString * WL =@"^17\\d{9}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestwl = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", WL];
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestwl evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(void)baojing{
    
    NSString * path = [[NSBundle mainBundle]pathForResource:@"叮咚" ofType:@"mp3"];
    //创建一个系统id
    SystemSoundID soundID;
    //需要关闭ARC
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:path]), &soundID);
    //进行播放音效
    AudioServicesPlaySystemSound(soundID);
    //短期震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}

//  短音频
+ (void)createPlaySoundEffect:(NSString *)filename{
    //从应用程序文件中获得文件的完整路径（绝对路径）
    NSString * filePath = [[NSBundle mainBundle]pathForResource:filename ofType:nil];
    //将绝对路径转换成统一资源定位符（URL）
    NSURL * url = [NSURL fileURLWithPath:filePath];
    //如果要播放音效需要通过系统提供的服务注册一个ID
    unsigned int sysSoundId;
    //通过系统音频服务的函数为音效文件注册一个ID
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &sysSoundId);
    //    AudioServicesPlayAlertSound(SystemSoundID inSystemSoundID)//震动效果+声音
    //通过系统音频服务播放指定ID的声音
    AudioServicesPlaySystemSound(sysSoundId);
}


@end
