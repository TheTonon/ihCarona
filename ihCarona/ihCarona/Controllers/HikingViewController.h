//
//  HikingViewController.h
//  ihCarona
//
//  Created by Pedro Freme on 10/31/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface HikingViewController : UIViewController <UIAlertViewDelegate, CLLocationManagerDelegate>
{
    MBProgressHUD *HUD;
}

@end
