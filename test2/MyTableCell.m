//
//  MyTableCell.m
//  test2
//
//  Created by Fujio Inou on 2015/05/08.
//  Copyright (c) 2015年 Fujio Inou. All rights reserved.
//

#import "MyTableCell.h"

@implementation MyTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)rowHeight {
    return 100.0;
}

@end
