//
//  DetailViewController.h
//  test2
//
//  Created by Fujio Inou on 2015/05/08.
//  Copyright (c) 2015年 Fujio Inou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestEntity.h"

@interface DetailViewController : UIViewController
@property (strong, nonatomic) TestEntity *entity;
- (void)done;
@end
