//
//  EditContactTableViewController.h
//  Encrypted Messenger
//
//  Created by Ryan Van Fleet on 3/30/14.
//  Copyright (c) 2014 Ryan Van Fleet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface EditContactTableViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, copy) CompletionBlock completionBlock;

@property (nonatomic, strong) Contact* contact;

@end
