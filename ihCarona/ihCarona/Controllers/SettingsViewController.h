//
//  SettingsViewController.h
//  ihCarona
//
//  Created by Vinicius Tonon on 11/8/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SettingsViewController : UIViewController
{
    MBProgressHUD *HUD;
}

-(IBAction)salvar:(id)sender;

@end
