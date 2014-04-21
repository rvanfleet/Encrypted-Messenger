//
//  ComposeMessageTableViewController.h
//  Encrypted Messenger
//
//  Created by Ryan Van Fleet on 4/21/14.
//  Copyright (c) 2014 Ryan Van Fleet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposeMessageTableViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, copy) CompletionBlock completionBlock;

@end
