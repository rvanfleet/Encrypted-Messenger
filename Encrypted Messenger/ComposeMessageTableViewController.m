//
//  ComposeMessageTableViewController.m
//  Encrypted Messenger
//
//  Created by Ryan Van Fleet on 4/21/14.
//  Copyright (c) 2014 Ryan Van Fleet. All rights reserved.
//

#import "ComposeMessageTableViewController.h"

@interface ComposeMessageTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UITextField *cipherTextField;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;

@end

@implementation ComposeMessageTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)sendPressed:(id)sender
{
}

- (IBAction)cancelPressed:(id)sender
{
    self.completionBlock(nil);
}

#pragma mark - Text Field Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

@end
