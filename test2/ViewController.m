//
//  ViewController.m
//  test2
//
//  Created by Fujio Inou on 2015/05/08.
//  Copyright (c) 2015年 Fujio Inou. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "DetailViewController.h"
#import "MyTableCell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
    @property (strong, nonatomic) IBOutlet UITableView *myTable;
    @property (strong, nonatomic) NSArray *data;
    @property (strong, nonatomic) NSIndexPath *currentEntityIndexPath;
@end

@implementation ViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem* newBtn = [[UIBarButtonItem alloc]
                                initWithTitle:@"New"
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(newItem)];
    self.navigationItem.rightBarButtonItem = newBtn;

    
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    //self.myTable.editing = YES;
    self.myTable.allowsMultipleSelectionDuringEditing = NO;
    self.myTable.allowsSelectionDuringEditing = YES;
    
    self.data = @[@"aaaaa",@"bbbbb",@"ccccc"];
    
    UINib *nib = [UINib nibWithNibName:@"MyTableCell" bundle:nil];
    [self.myTable registerNib:nib forCellReuseIdentifier:@"Cell"];
 
    self.navigationItem.title = @"Test";

    [self.navigationItem.rightBarButtonItem setEnabled:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    MyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self restoreCell:cell indexPath:indexPath];
    return cell;
}

- (void)restoreCell:(MyTableCell*)cell indexPath:(NSIndexPath*)indexPath {
    TestEntity *entity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.thubnail.image = [UIImage imageNamed:@"test"];
    cell.company.text = entity.company;
    cell.name.text = entity.name;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MyTableCell rowHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"didSelectRowAtIndexPath:%ld",(long)indexPath.row);
    [self performSegueWithIdentifier:@"pushDetail" sender:self];
}

- (void)newItem
{
    [self performSegueWithIdentifier:@"pushNewItem" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushDetail"]) {
        DetailViewController *vc = segue.destinationViewController;
        vc.navigationItem.title = @"Detail";
        NSIndexPath *indexPath = [self.myTable indexPathForSelectedRow];
        vc.entity = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
    } else  if ([segue.identifier isEqualToString:@"pushNewItem"]) {
        DetailViewController *vc = segue.destinationViewController;
        vc.navigationItem.title = @"New";
        vc.entity = nil;
    }
}


- (NSFetchedResultsController *)fetchedResultsController
{
    @synchronized(self) {
        if (_fetchedResultsController != nil) {
            return _fetchedResultsController;
        }
        
        AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        
        NSEntityDescription *entityDesc = [NSEntityDescription
                                           entityForName:@"TestEntity"
                                           inManagedObjectContext:app.managedObjectContext];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                            initWithKey:@"name"
                                            ascending:NO];
        NSArray *sortDescriptors = @[sortDescriptor];
        
        NSFetchRequest *fetchRequest = [NSFetchRequest new];
        fetchRequest.entity = entityDesc;
        fetchRequest.fetchBatchSize = 20;
        fetchRequest.sortDescriptors = sortDescriptors;
        
        _fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fetchRequest
                                     managedObjectContext:app.managedObjectContext
                                     sectionNameKeyPath:nil
                                     cacheName:@"List"];
        _fetchedResultsController.delegate = self;
        
        NSError *error = nil;
        if (![_fetchedResultsController performFetch:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        return _fetchedResultsController;
    }
}


// ほぼテンプレ
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.myTable beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.myTable;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self restoreCell:(MyTableCell*)[tableView cellForRowAtIndexPath:indexPath]
                    indexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.myTable endUpdates];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
   return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.currentEntityIndexPath = indexPath;
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"削除します"
                              message:@"削除します"
                              delegate:self
                              cancelButtonTitle:@"確認"
                              otherButtonTitles:nil];
        [alert show];
    }
}
- (void)deleteEntity:(NSIndexPath *)indexPath {
        AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        TestEntity *entity = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [app.managedObjectContext deleteObject:entity];
        NSError *error = nil;
        if (![app.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
}
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self deleteEntity:self.currentEntityIndexPath];
            break;
        case 1:
            break;
    }
}

@end
