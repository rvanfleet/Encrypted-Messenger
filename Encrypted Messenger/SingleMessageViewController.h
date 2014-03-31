//
//  SingleMessageViewController.h
//  Encrypted Messenger
//
//  Created by Ryan Van Fleet on 3/31/14.
//  Copyright (c) 2014 Ryan Van Fleet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface SingleMessageViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) Contact* contact;

@end
