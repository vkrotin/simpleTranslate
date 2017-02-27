//
//  DictionaryTableViewController.m
//  simpleTranslate
//
//  Created by Aleksey Anisimov on 27.02.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

#import "DictionaryTableViewController.h"
#import "RequestManager.h"
#import "DictionaryTableViewCell.h"

@interface DictionaryTableViewController (){
    NSMutableArray *_translatesArray;
}

@end

@implementation DictionaryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _translatesArray = [[RequestManager sharedManager] getAllTranslates];
    [self.tableView reloadData];
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
    return _translatesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DictionaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dictionaryViewCell" forIndexPath:indexPath];
    cell.translateObject = _translatesArray[indexPath.row];
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if ([self.parentViewController.parentViewController isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabController = (UITabBarController *)self.parentViewController.parentViewController;
        STTranslate *tr = _translatesArray[indexPath.row];
        [[RequestManager sharedManager] setFromLangKey:tr.fromLangKey];
        [[RequestManager sharedManager] setToLangKey:tr.toLangKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationSelectTranslate" object:tr];
        [tabController setSelectedIndex:0];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        STTranslate *tr = _translatesArray[indexPath.row];
        
        [_translatesArray removeObject:tr];
        [tr MR_deleteEntity];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
