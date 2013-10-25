//
//  LoginViewController.m
//  ihCarona
//
//  Created by Pedro Freme on 10/24/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "LoginViewController.h"
#import "LandPageViewController.h"

@interface LoginViewController() <FbUserDelegate>
@property (nonatomic, strong) IBOutlet UIButton *btnLogin;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityLogin;
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [PFUser logOut];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Outlet for FBLogin button
- (IBAction) loginPressed:(id)sender
{
    // desabilita botao de login para evitar multiplos clicks
    [_btnLogin setEnabled:NO];
    
    // mostra o activity indicator
    [_activityLogin startAnimating];
    
    //faz o login
    [Comms login:self];
}

- (void) userDidLogin:(BOOL)loggedIn{
	// habilita o botao de login
	[_btnLogin setEnabled:YES];
    
	// para a animacao do indicator
	[_activityLogin stopAnimating];

	if (loggedIn) {
        [self openLandPage];
	} else {
		// Mostra mensagem de erro
		[[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                    message:@"Facebook Login failed. Please try again"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
	}
}

-(void) openLandPage{
    
    LandPageViewController *landPage = [self.storyboard instantiateViewControllerWithIdentifier:@"LandPageViewController"];
    [self presentViewController:landPage animated:YES completion:nil];
}


@end
