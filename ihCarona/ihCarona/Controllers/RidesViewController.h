//
//  RidesViewController.h
//  ihCarona
//
//  Created by Pedro Freme on 10/24/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapsViewController.h"

@interface RidesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray *ridersList;

@end
