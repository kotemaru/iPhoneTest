//
//  DetailViewController.m
//  test2
//
//  Created by Fujio Inou on 2015/05/08.
//  Copyright (c) 2015年 Fujio Inou. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *vCompany;
@property (weak, nonatomic) IBOutlet UITextField *vName;
@property (strong, nonatomic) UIActivityIndicatorView *vProgress;
@end

@implementation DetailViewController
@synthesize entity = _entity;


- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem* doneBtn = [[UIBarButtonItem alloc]
                                initWithTitle:@"Done"
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneBtn;
    
    if (self.vProgress == nil) {
        self.vProgress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.vProgress.hidesWhenStopped = YES;
        CGSize indicatorSize = self.vProgress.frame.size;
        CGSize viewSize = self.view.frame.size;
        self.vProgress.frame = CGRectMake(
                                          (viewSize.width-indicatorSize.width) / 2,
                                          (viewSize.height-indicatorSize.height) / 2,
                                          indicatorSize.width,
                                          indicatorSize.height);
        [self.vProgress stopAnimating];
        [self.view addSubview:self.vProgress];
    }
    
    [self restoreEntity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)restoreEntity
{
    NSLog(@"restoreEntity:%@",self.entity);
    if (self.entity == nil) {
        self.vCompany.text = nil;
        self.vName.text = nil;
    } else {
        self.vCompany.text = self.entity.company;
        self.vName.text = self.entity.name;
    }
}

- (void)done
{
    [self.vProgress startAnimating];
    
    
    __block AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [app.worker addOperationWithBlock: ^{
        if (self.entity == nil ) {
            self.entity = [NSEntityDescription
                           insertNewObjectForEntityForName:NSStringFromClass([TestEntity class])
                           inManagedObjectContext:app.managedObjectContext];
        }
        self.entity.company = self.vCompany.text;
        [NSThread sleepForTimeInterval:5];
        self.entity.name = self.vName.text;
        
        NSError *error = nil;
        if (![app.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        [app.uiThread addOperationWithBlock: ^{
            [self.vProgress stopAnimating];
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
