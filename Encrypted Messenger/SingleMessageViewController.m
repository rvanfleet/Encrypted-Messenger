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
#import "DataSource.h"
#import "MyDataManager.h"
#import "Message.h"

#define kCaesarCipherKey 3

@interface SingleMessageViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UITextField *cipherTextField;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIView *messageInputView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) DataSource* dataSource;
@property (nonatomic, strong) MyDataManager *myDataManager;

@property (nonatomic, strong) UIPickerView* cipherPickerView;
@property (nonatomic, strong) NSArray* cipherPickerData;

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
    
    self.cipherPickerData = @[@"Caesar's Cipher",
                              @"Permutation",
                              @"Double Transposition"];
    
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
    
    if ([cipher isEqualToString:@""] || [message isEqualToString:@""])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Send Unsuccessful" message:@"Please enter both a cipher and a message to be able to send." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    else
    {
        NSString* ciphertext = [self getCiphertextWithCipher:cipher AndPlaintext:message];
        
        NSDictionary* dictionarySent = @{@"contact": self.contact,
                                     @"date": [NSDate date],
                                     @"ciphertext": message,
                                     @"cipher": @"",
                                     @"sentFromThisDevice": @"yes"};
        
        [self.myDataManager addMessage:dictionarySent];
        
        NSDictionary* dictionaryReceive = @{@"contact": self.contact,
                                     @"date": [NSDate date],
                                     @"ciphertext": ciphertext,
                                     @"cipher": cipher,
                                     @"sentFromThisDevice": @"no"};
        
        [self.myDataManager addMessage:dictionaryReceive];
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
    
    NSString* plaintext = [self getPlaintextWithCipher:cipher AndCiphertext:ciphertext];
    
    if ([message.sentFromThisDevice isEqualToString:@"yes"])
    {
        SingleMessageRightTableViewCell* tableViewCell = (SingleMessageRightTableViewCell*)cell;
        
        tableViewCell.textView.text = plaintext;
    }
    else
    {
        SingleMessageLeftTableViewCell* tableViewCell = (SingleMessageLeftTableViewCell*)cell;
        
        tableViewCell.textView.text = plaintext;
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
        textField.text = [self.cipherPickerData objectAtIndex:0];
        
        [self.cipherPickerView selectRow:0 inComponent:0 animated:NO];
    }
}

-(NSString*)getCiphertextWithCipher:(NSString*)cipher AndPlaintext:(NSString*)plaintext
{
    NSString* ciphertext;
    
    //First cipher was selected - Caesar's Cipher
    if ([cipher isEqualToString:[self.cipherPickerData objectAtIndex:0]])
    {
        NSMutableString* ciphertextMutable = [[NSMutableString alloc] init];
        
        for (NSInteger index = 0; index < [plaintext length]; index++)
        {
            char currentPlaintextChar = [plaintext characterAtIndex:index];
            
            char currentCiphertextChar = currentPlaintextChar + kCaesarCipherKey;
            
            [ciphertextMutable appendString:[NSString stringWithFormat:@"%c", currentCiphertextChar]];
        }
        
        ciphertext = ciphertextMutable;
    }
    //Second cipher selected - Permutation
    else if ([cipher isEqualToString:[self.cipherPickerData objectAtIndex:1]])
    {
        NSMutableString* ciphertextMutable = [plaintext mutableCopy];
        
        //Exchange every character with its following character starting from the beginning
        //   and continuing to the second to last character in the plaintext
        for (NSInteger index = 0; index < [plaintext length] - 1; index++)
        {
            char currentPlaintextChar = [ciphertextMutable characterAtIndex:index];
            char nextPlaintextChar = [ciphertextMutable characterAtIndex:index + 1];
            
            NSRange currentRange;
            currentRange.location = index;
            currentRange.length = 1;
            
            [ciphertextMutable replaceCharactersInRange:currentRange
                                             withString:[NSString stringWithFormat:@"%c",
                                                         nextPlaintextChar]];
            
            NSRange nextRange;
            nextRange.location = index + 1;
            nextRange.length = 1;
            
            [ciphertextMutable replaceCharactersInRange:nextRange
                                             withString:[NSString stringWithFormat:@"%c",
                                                         currentPlaintextChar]];
        }
        
        ciphertext = ciphertextMutable;
    }
    //No cipher was selected
    else
    {
        ciphertext = plaintext;
    }
    
    return ciphertext;
}

-(NSString*)getPlaintextWithCipher:(NSString*)cipher AndCiphertext:(NSString*)ciphertext
{
    NSString* plaintext;
    
    //First cipher was selected - Caesar's Cipher
    if ([cipher isEqualToString:[self.cipherPickerData objectAtIndex:0]])
    {
        NSMutableString* plaintextMutable = [[NSMutableString alloc] init];
        
        for (NSInteger index = 0; index < [ciphertext length]; index++)
        {
            char currentCiphertextChar = [ciphertext characterAtIndex:index];
            
            char currentPlaintextChar = currentCiphertextChar - kCaesarCipherKey;
            
            [plaintextMutable appendString:[NSString stringWithFormat:@"%c", currentPlaintextChar]];
        }
        
        plaintext = plaintextMutable;
    }
    //Second cipher selected - Permutation
    else if ([cipher isEqualToString:[self.cipherPickerData objectAtIndex:1]])
    {
        NSMutableString* plaintextMutable = [ciphertext mutableCopy];
        
        //Exchange every character with its previous character starting from the second to
        //   last character and continuing to the first character in the plaintext
        for (NSInteger index = [ciphertext length] - 1; index > 0; index--)
        {
            char currentCiphertextChar = [plaintextMutable characterAtIndex:index];
            char previousCiphertextChar = [plaintextMutable characterAtIndex:index - 1];
            
            NSRange currentRange;
            currentRange.location = index;
            currentRange.length = 1;
            
            [plaintextMutable replaceCharactersInRange:currentRange
                                            withString:[NSString stringWithFormat:@"%c",
                                                        previousCiphertextChar]];
            
            NSRange previousRange;
            previousRange.location = index - 1;
            previousRange.length = 1;
            
            [plaintextMutable replaceCharactersInRange:previousRange
                                            withString:[NSString stringWithFormat:@"%c",
                                                        currentCiphertextChar]];
        }
        
        plaintext = plaintextMutable;
    }
    //No cipher was selected
    else
    {
        plaintext = ciphertext;
    }
    
    return plaintext;
}

#pragma mark - Picker View Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.cipherTextField.text = [self.cipherPickerData objectAtIndex:row];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.cipherPickerData count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.cipherPickerData objectAtIndex:row];
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
