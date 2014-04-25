//
//  SingleMessageViewController.m
//  Encrypted Messenger
//
//  Created by Ryan Van Fleet on 4/4/14.
//  Copyright (c) 2014 Ryan Van Fleet. All rights reserved.
//

#import "SingleMessageViewController.h"
#import "SingleMessageLeftTableViewCell.h"
#import "SingleMessageRightTableViewCell.h"
#import "MessagesGlobalVariablesAndFunctions.h"
#import "DataSource.h"
#import "MyDataManager.h"
#import "Message.h"

@interface SingleMessageViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UITextField *cipherTextField;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIView *messageInputView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) DataSource* dataSource;
@property (nonatomic, strong) MyDataManager *myDataManager;

@property (nonatomic, strong) UIPickerView* cipherPickerView;

@property (nonatomic, strong) MessagesGlobalVariablesAndFunctions* globalData;

@property CGRect messageInputViewOriginalFrame;
@property NSInteger tabBarHeight;

@end

@implementation SingleMessageViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        _myDataManager = [[MyDataManager alloc] init];
        
        _dataSource = [DataSource alloc];
        
        _dataSource.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.globalData = [[MessagesGlobalVariablesAndFunctions alloc] init];
    
    [self.globalData createAllGlobalVariables];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"contact.identifier == %@", self.contact.identifier];
    
    self.dataSource = [self.dataSource initForEntity:@"Message"              //Get all messages
                                            sortKeys:@[@"date"]
                                           ascending:YES
                                           predicate:predicate
                                  sectionNameKeyPath:nil
                                 dataManagerDelegate:_myDataManager];
    
    self.tableView.dataSource = self.dataSource;
    self.dataSource.tableView = self.tableView;
    
    self.navigationBar.title = [NSString stringWithFormat:@"%@ %@", self.contact.firstName, self.contact.lastName];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    self.cipherPickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    
    self.cipherPickerView.showsSelectionIndicator = YES;
    self.cipherPickerView.dataSource = self;
    self.cipherPickerView.delegate = self;
    
    [self.cipherTextField setInputView:self.cipherPickerView];
    
    self.messageInputViewOriginalFrame = self.messageInputView.frame;
    
    self.tabBarHeight = self.view.frame.size.height -
                        self.messageInputViewOriginalFrame.origin.y -
                        self.messageInputViewOriginalFrame.size.height;
}

-(void)viewDidAppear:(BOOL)animated
{
    //Set keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    if ([self.dataSource numberOfResultsInSection:0] != 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.dataSource numberOfResultsInSection:0] - 1
                                                    inSection:0];
        
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)send:(id)sender
{
    NSString* cipher = self.cipherTextField.text;
    NSString* message = self.messageTextField.text;
    
    if ([cipher isEqualToString:@""])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Send Unsuccessful" message:@"Please select a cipher." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    else
    {
        [self.globalData sendMessage:message withCipher:cipher toContact:self.contact];
    }
    
    [self.cipherTextField resignFirstResponder];
    [self.messageTextField resignFirstResponder];
    
    [self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
    
    self.cipherTextField.text = @"";
    self.messageTextField.text = @"";
}

#pragma mark - Data Source Cell Configurer

-(void)configureCell:(UITableViewCell *)cell withObject:(id)object
{
    Message* message = object;
    
    NSString* cipher = message.cipher;
    NSString* ciphertext = message.ciphertext;
    
    NSString* plaintext = [self.globalData getPlaintextWithCipher:cipher AndCiphertext:ciphertext];
    
    if ([message.sentFromThisDevice isEqualToString:@"yes"])
    {
        SingleMessageRightTableViewCell* tableViewCell = (SingleMessageRightTableViewCell*)cell;
        
        tableViewCell.textView.text = plaintext;
    }
    else
    {
        SingleMessageLeftTableViewCell* tableViewCell = (SingleMessageLeftTableViewCell*)cell;
        
        tableViewCell.textView.text = [NSString stringWithFormat:@"Plaintext: %@",
                                       plaintext];
    }
}

-(NSString*)cellIdentifierForObject:(id)object
{
    Message* message = object;
    
    if ([message.sentFromThisDevice isEqualToString:@"yes"])
    {
        return @"SingleMessageCellRight";
    }
    else
    {
        return @"SingleMessageCellLeft";
    }
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
    if (textField == self.cipherTextField)
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
    self.cipherTextField.text = [self.globalData.cipherPickerData objectAtIndex:row];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.globalData.cipherPickerData count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.globalData.cipherPickerData objectAtIndex:row];
}

#pragma mark - Notification Handlers

//Get the length of the animation for the keyboard showing or disappearing
-(NSTimeInterval)keyboardAnimationWithDurationForNotification:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    
    [value getValue:&duration];
    return duration;
}

-(void)keyboardWasShown:(NSNotification*)notification
{
    NSDictionary *info = notification.userInfo;
    CGRect frame = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGSize keyboardSize = frame.size;
    
    [UIImageView animateWithDuration:[self keyboardAnimationWithDurationForNotification:notification] animations:^
     {
         self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                           self.tableView.frame.origin.y,
                                           self.tableView.frame.size.width,
                                           self.view.frame.size.height -
                                           self.messageInputView.frame.size.height -
                                           keyboardSize.height);
         
         self.messageInputView.frame = CGRectMake(self.messageInputView.frame.origin.x,
                                                  self.view.frame.size.height -
                                                  keyboardSize.height -
                                                  self.messageInputView.frame.size.height,
                                                  self.messageInputView.frame.size.width,
                                                  self.messageInputView.frame.size.height);
     }];
    
    if ([self.dataSource numberOfResultsInSection:0] != 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.dataSource numberOfResultsInSection:0] - 1
                                                    inSection:0];
        
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:YES];
    }
}

-(void)keyboardWillBeHidden:(NSNotification*)notification
{
    [UIImageView animateWithDuration:[self keyboardAnimationWithDurationForNotification:notification] animations:^
     {
         self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                           self.tableView.frame.origin.y,
                                           self.tableView.frame.size.width,
                                           self.view.frame.size.height -
                                           self.messageInputViewOriginalFrame.size.height -
                                           self.tabBarHeight);
         
         self.messageInputView.frame = self.messageInputViewOriginalFrame;
     }];
    
}

@end
