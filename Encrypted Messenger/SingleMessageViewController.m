//
//  SingleMessageViewController.m
//  Encrypted Messenger
//
//  Created by Ryan Van Fleet on 3/31/14.
//  Copyright (c) 2014 Ryan Van Fleet. All rights reserved.
//

#import "SingleMessageViewController.h"

@interface SingleMessageViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UIScrollView *messagesScrollView;

@end

@implementation SingleMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.title = [NSString stringWithFormat:@"%@ %@", self.contact.firstName, self.contact.lastName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)send:(id)sender
{
}

#pragma mark - Text Field Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

@end
