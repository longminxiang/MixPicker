//
//  MixPickerCell.m
//  RSB
//
//  Created by Eric Lung on 2017/4/10.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

#import "MixPickerCell.h"

@implementation MixPickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.textLabel.textColor = [UIColor lightGrayColor];
}

- (void)setIsCurrent:(BOOL)isCurrent
{
    _isCurrent = isCurrent;
    self.textLabel.font = isCurrent ? [UIFont boldSystemFontOfSize:14] : [UIFont systemFontOfSize:14];
    self.textLabel.textColor = isCurrent ? [UIColor orangeColor] : [UIColor lightGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
