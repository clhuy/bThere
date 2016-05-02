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
    
    // fetch events everytime the app launches
   /* FBSDKGraphRequest *requestEvents = [[FBSDKGraphRequest alloc]
                                        initWithGraphPath:@"/me/events"
                                        parameters:nil
                                        HTTPMethod:@"GET"];
    [requestEvents startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                id result,
                                                NSError *error) {
        // Handle the result
        [self.model setUEvents:[result objectForKey:@"data"]];
    }];*/
    
    // fetch event pictures
    /*NSMutableArray *temp = [[NSMutableArray alloc]
                            init];
    for(id object in [self.model getUEvents]) {
        //NSLog(@"key=%@ value=%@", key, [myDict objectForKey:key]);
        NSString *gPath = [[NSString alloc] initWithFormat:@"/%@/picture", [object objectForKey:@"id"]];
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:gPath
                                      parameters:@{@"fields": @"url", @"type": @"small", @"redirect" : @false}
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            // Handle the result
            [temp addObject:[[result objectForKey:@"data"] objectForKey:@"url"]];
        }];
    }
    [self.model setEventPics:temp];*/
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
