//
//  FbFriendsViewController.h
//  ihCarona
//
//  Created by Pedro Freme on 10/24/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FbFriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

/**
 *  lista de amigos para selecionar o carona
 */
@property (nonatomic, strong)NSMutableArray *friendsList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
