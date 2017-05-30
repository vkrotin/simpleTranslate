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

static NSString *const cellIdentifier = @"dictionaryViewCell";
static NSNotificationName const notificationSelectTranslate = @"notificationSelectTranslate";


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
    DictionaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationSelectTranslate object:tr];
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

@end
