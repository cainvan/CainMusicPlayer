//
//  AudioButton.h
//  CainMusicPlayer
//
//  Created by Cain on 16/3/14.
//  Copyright © 2016年 Cain. All rights reserved.
//
#import <UIKit/UIKit.h>

extern NSString *playImage, *stopImage;

@interface AudioButton : UIButton {

	CGFloat _r;
	CGFloat _g;
	CGFloat _b;
	CGFloat _a;
	
	CGFloat _progress;
	
	CGRect _outerCircleRect;
	CGRect _innerCircleRect;
    
    UIImage *image;
    UIImageView *loadingView;
}

@property (nonatomic, retain) UIImage *image;

- (id)initWithFrame:(CGRect)frame;
- (void)startSpin;
- (void)stopSpin;
- (CGFloat)progress;
- (void)setProgress:(CGFloat)newProgress;		
- (void)setColourR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a;	

@end
