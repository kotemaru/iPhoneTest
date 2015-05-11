//
//  MyTableCell.h
//  test2
//
//  Created by Fujio Inou on 2015/05/08.
//  Copyright (c) 2015年 Fujio Inou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thubnail;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UILabel *name;

+ (CGFloat)rowHeight;
@end
