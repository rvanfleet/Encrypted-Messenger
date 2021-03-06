//
//  ComposeMessageTableViewController.m
//  Encrypted Messenger
//
//  Created by Ryan Van Fleet on 4/21/14.
//  Copyright (c) 2014 Ryan Van Fleet. All rights reserved.
//

#import "ComposeMessageTableViewController.h"
#import "MessagesGlobalVariablesAndFunctions.h"
#import "DataSource.h"
#import "MyDataManager.h"

@interface ComposeMessageTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UITextField *cipherTextField;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;

@property (strong, nonatomic) DataSource* dataSource;
@property (nonatomic, strong) MyDataManager *myDataManager;

@property (nonatomic, strong) UIPickerView* contactPickerView;

@property (nonatomic, strong) UIPickerView* cipherPickerView;

@property (nonatomic, strong) MessagesGlobalVariablesAndFunctions* globalData;

@end

@implementation ComposeMessageTableViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        _myDataManager = [[MyDataManager alloc] init];
        
        _dataSource = [[DataSource alloc] initForEntity:@"Contact"
                                               sortKeys:@[@"lastName"]
                                              ascending:YES
                                              predicate:nil
                                     sectionNameKeyPath:nil
                                    dataManagerDelegate:_myDataManager];
        
        _dataSource.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.globalData = [[MessagesGlobalVariablesAndFunctions alloc] init];
    
    [self.globalData createAllGlobalVariables];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    self.contactPickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    
    self.contactPickerView.showsSelectionIndicator = YES;
    self.contactPickerView.dataSource = self;
    self.contactPickerView.delegate = self;
    
    [self.contactTextField setInputView:self.contactPickerView];
    
    self.cipherPickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    
    self.cipherPickerView.showsSelectionIndicator = YES;
    self.cipherPickerView.dataSource = self;
    self.cipherPickerView.delegate = self;
    
    [self.cipherTextField setInputView:self.cipherPickerView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.contactTextField resignFirstResponder];
    [self.cipherTextField resignFirstResponder];
    [self.messageTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)sendPressed:(id)sender
{
    if ([self.contactTextField.text isEqualToString:@""] ||
        [self.cipherTextField.text isEqualToString:@""])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Send Unsuccessful" message:@"Please select both a contact to send this message to and a cipher to be used." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    else
    {
        NSIndexPath* selectedIndexPath = [NSIndexPath indexPathForRow:
                                          [self.contactPickerView selectedRowInComponent:0]
                                                            inSection:0];
        
        Contact* contact = [self.dataSource objectAtIndexPath:selectedIndexPath];
        
        [self.globalData sendMessage:self.messageTextField.text withCipher:self.cipherTextField.text toContact:contact];
        
        self.completionBlock(contact);
    }
}

- (IBAction)cancelPressed:(id)sender
{
    self.completionBlock(nil);
}

#pragma mark - Data Source Cell Configurer

-(void)configureCell:(UITableViewCell *)cell withObject:(id)object
{
}

-(NSString*)cellIdentifierForObject:(id)object
{
    return @"";
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Text Field Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.contactTextField)
    {
        Contact* contact = [self.dataSource objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        textField.text = [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
        
        [self.contactPickerView selectRow:0 inComponent:0 animated:NO];
    }
    else if (textField == self.cipherTextField)
    {
        textField.text = [self.globalData.cipherPickerData objectAtIndex:0];
        
        [self.cipherPickerView selectRow:0 inComponent:0 animated:NO];
    }
}

#pragma mark - Picker View Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.contactPickerView)
    {
        Contact* contact = [self.dataSource objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        
        self.contactTextField.text = [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
    }
    else if (pickerView == self.cipherPickerView)
    {
        self.cipherTextField.text = [self.globalData.cipherPickerData objectAtIndex:row];
    }
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.contactPickerView)
    {
        return [self.dataSource numberOfResultsInSection:0];
    }
    else
    {
        return [self.globalData.cipherPickerData count];
    }
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.contactPickerView)
    {
        Contact* contact = [self.dataSource objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        
        return [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
    }
    else
    {
        return [self.globalData.cipherPickerData objectAtIndex:row];
    }
}

@end
