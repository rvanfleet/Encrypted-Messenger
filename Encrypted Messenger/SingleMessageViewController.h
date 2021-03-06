//
//  SingleMessageViewController.h
//  Encrypted Messenger
//
//  Created by Ryan Van Fleet on 4/4/14.
//  Copyright (c) 2014 Ryan Van Fleet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSourceCellConfigurer.h"
#import "Contact.h"

@interface SingleMessageViewController : UIViewController <UITextFieldDelegate, DataSourceCellConfigurer, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) Contact* contact;

@end
