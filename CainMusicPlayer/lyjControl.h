//
//  lyjControl.h
//  工厂类
//
//  Created by Cain on 15/9/6.
//  Copyright (c) 2015年 Cain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
@interface lyjControl : NSObject <UIScrollViewDelegate>
/*!  
 @brief 播放音效(30s内的短音频文件)
 @param filename 音效文件的名字
 @return nil 返回值为空
 */
+ (void)playSoundEffect:(NSString *)filename;

//创建Label
+(UILabel *)createLabelWithText:(NSString *)text TextColor:(UIColor*)color Frame:(CGRect)frame FontSize:(int)fontsize BackgroundColor:(UIColor*)color1 TextAlignment:(NSTextAlignment)textAlignment  IfFitWidth:(BOOL)fitwidth;




//创建ImageView
+(UIImageView*)createImageViewWithImageName:(NSString *)imagename Frame:(CGRect)frame;
//创建Button
+(UIButton*)createButtonWithTitle:(NSString *)title TitleColor:(UIColor*)titlecolor Target:(id)target Sel:(SEL)sel Event:(UIControlEvents)event BackGroundImage:(NSString *)imageName Image:(NSString*)imageName1 BackgroundColor:(UIColor*)color FontSize:(int)fontsize Frame:(CGRect)frame;
//创建TextField
+ (UITextField*)createTextFieldWithFrame:(CGRect)frame PlaceHolder:(NSString*)placeholder FontSize:(float)fontsize TextColor:(UIColor*)color BackGroundColor:(UIColor*)color1;
//创建广告视图 arr图片数组   time每张图切换间隔时间  frame图片放在页面的位置
//UIScrollView pageControl
//+ (void)createAdvertisementWithImageArr:(NSArray*)arr andIntervalTime:(NSString*)time andCGRectFrame:(CGRect)frame;
//判断是否是电话号
+(BOOL)isMobileNumber:(NSString *)mobileNum;
+(void)baojing;
@end
