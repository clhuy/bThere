//
//  EventsTableViewController.m
//  bThere
//
//  Created by Le Huy Cu on 4/29/16.
//  Copyright © 2016 Le Huy Cu. All rights reserved.
//

#import "EventsTableViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "UserModel.h"
#import "DateParser.h"
#import "DetailViewController.h"

@interface EventsTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong,nonatomic) UserModel *model;

@end

@implementation EventsTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.model = [UserModel sharedModel];

    // set navbar color
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:141.0/255.0 blue:215.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.refreshButton.tintColor = [UIColor whiteColor];
    
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
#else
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"Documents Directory: %@",[paths firstObject]);
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([[self.model getUEvents] count] != 0){
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.model getUEvents] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"forIndexPath:indexPath];
    
    NSDictionary *event = [self.model eventAtIndex:indexPath.row];
    
    // fetch and set event picture
    NSURL *url = [NSURL URLWithString:[[event objectForKey:@"cover"] objectForKey:@"source"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    cell.imageView.image = image;
    
    // set event title
    cell.textLabel.text = [event objectForKey:@"name"];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:13]];
    
    // parse and set event date
    NSString* date = [DateParser parseDate:[event objectForKey:@"start_time"]];
    cell.detailTextLabel.text = date;
    
    return cell;
}

- (IBAction)refreshTable:(id)sender {
    [self.tableView reloadData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"detailView"]) {
        NSArray<NSIndexPath*> *indexPath = [self.tableView indexPathsForSelectedRows];
        NSUInteger index = [[indexPath objectAtIndex:0] row];
        
        DetailViewController *detailVC = segue.destinationViewController;
        detailVC.event = [self.model eventAtIndex:index];
    }
}


@end
