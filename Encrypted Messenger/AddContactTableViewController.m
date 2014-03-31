//
//  AddContactTableViewController.m
//  Encrypted Messenger
//
//  Created by Ryan Van Fleet on 3/30/14.
//  Copyright (c) 2014 Ryan Van Fleet. All rights reserved.
//

#import "AddContactTableViewController.h"

@interface AddContactTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;

@end

@implementation AddContactTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)save:(id)sender
{
    //New contact does not have a last name
    if ([self.lastNameTextField.text isEqualToString:@""])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Last Name Required" message:@"A new contact requires a last name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    //New contact has no contact method
    else if ([self.phoneNumberTextField.text isEqualToString:@""] &&
             [self.emailAddressTextField.text isEqualToString:@""])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Contact Method Required" message:@"A new contact requires at least a phone number or email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    //New contact is valid
    else
    {
        NSDictionary* dictionary = @{@"firstName": self.firstNameTextField.text,
                                     @"lastName": self.lastNameTextField.text,
                                     @"phoneNumber": self.phoneNumberTextField.text,
                                     @"emailAddress": self.emailAddressTextField.text};
        
        self.completionBlock(dictionary);
                                     
    }
}

- (IBAction)cancel:(id)sender
{
    self.completionBlock(nil);
}

#pragma mark - Text Field Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

@end
