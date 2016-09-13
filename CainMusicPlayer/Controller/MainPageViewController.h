//
//  MainPageViewController.h
//  CainMusicPlayer
//
//  Created by Cain on 16/3/12.
//  Copyright © 2016年 Cain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDSideBarController.h"

@interface MainPageViewController : UIViewController <CDSideBarControllerDelegate> {
    CDSideBarController *sideBar;
}

@end
