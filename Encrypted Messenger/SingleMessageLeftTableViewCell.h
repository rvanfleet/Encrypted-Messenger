//
//  SingleMessageLeftTableViewCell.h
//  Encrypted Messenger
//
//  Created by Ryan Van Fleet on 4/7/14.
//  Copyright (c) 2014 Ryan Van Fleet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleMessageLeftTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *tableCellView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
