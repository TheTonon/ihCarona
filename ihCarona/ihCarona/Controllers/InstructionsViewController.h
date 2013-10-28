//
//  InstructionsViewController.h
//  ihCarona
//
//  Created by Pedro Freme on 10/28/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstructionsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *instructions;

@end
