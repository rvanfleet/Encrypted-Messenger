//
//  SingleMessageLeftTableViewCell.m
//  Encrypted Messenger
//
//  Created by Ryan Van Fleet on 4/7/14.
//  Copyright (c) 2014 Ryan Van Fleet. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SingleMessageLeftTableViewCell.h"

@implementation SingleMessageLeftTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
    }
    return self;
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
