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
#import "LoadingTableViewEmpty.h"

static NSString *const cellIdentifier = @"dictionaryViewCell";
static NSNotificationName const notificationSelectTranslate = @"notificationSelectTranslate";


@interface DictionaryTableViewController (){
    NSMutableArray *_translatesArray;
    LoadingTableViewEmpty *_emptyView;
}

@end

@implementation DictionaryTableViewController


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.tableFooterView = [UIView new];
    _translatesArray = [[RequestManager sharedManager] getAllTranslates];
    [self.tableView reloadData];
}

-(void) awakeFromNib{
    [super awakeFromNib];
    _emptyView = [[LoadingTableViewEmpty alloc] initWithFrame:self.tableView.frame];
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
    if (_translatesArray.count > 0) {
        tableView.backgroundView = [UIView new];
        return _translatesArray.count;
    }else{
        tableView.backgroundView = _emptyView;
        return 0;
    }
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        STTranslate *tr = _translatesArray[indexPath.row];
        [_translatesArray removeObject:tr];
        [[RequestManager sharedManager] deleteTranslate:tr];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
    }
}

@end
