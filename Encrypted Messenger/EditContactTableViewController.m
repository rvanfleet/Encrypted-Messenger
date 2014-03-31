//
//  EditContactTableViewController.m
//  Encrypted Messenger
//
//  Created by Ryan Van Fleet on 3/30/14.
//  Copyright (c) 2014 Ryan Van Fleet. All rights reserved.
//

#import "EditContactTableViewController.h"

@interface EditContactTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;

@end

@implementation EditContactTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.firstNameTextField.text = self.contact.firstName;
    self.lastNameTextField.text = self.contact.lastName;
    self.phoneNumberTextField.text = self.contact.phoneNumber;
    self.emailAddressTextField.text = self.contact.emailAddress;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)save:(id)sender
{
    //Contact does not have a last name
    if ([self.lastNameTextField.text isEqualToString:@""])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Last Name Required" message:@"A new contact requires a last name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    //Contact has no contact method
    else if ([self.phoneNumberTextField.text isEqualToString:@""] &&
             [self.emailAddressTextField.text isEqualToString:@""])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Contact Method Required" message:@"A new contact requires at least a phone number or email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    //Contact is valid
    else
    {
        self.contact.firstName = self.firstNameTextField.text;
        self.contact.lastName = self.lastNameTextField.text;
        self.contact.phoneNumber = self.phoneNumberTextField.text;
        self.contact.emailAddress = self.emailAddressTextField.text;
        
        self.completionBlock(self.contact);
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
