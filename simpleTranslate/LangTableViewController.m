//
//  LangTableViewController.m
//  simpleTranslate
//
//  Created by Aleksey Anisimov on 26.02.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

#import "LangTableViewController.h"
#import "RequestManager.h"


@interface LangTableViewController (){
    NSArray *_langsArray;
}

@end

@implementation LangTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _isFrom ? @"Язык оригинала" : @"Язык перевода";
    
    
    _langsArray = [[RequestManager sharedManager] getLanguageArray];
    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return _langsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"simpleCell" forIndexPath:indexPath];
    
    STLang *lang = _langsArray[indexPath.row];
    cell.textLabel.text = lang.langName;
    
    return cell;
}


- (IBAction)closeModalAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    STLang *lang = _langsArray[indexPath.row];
    
    if (_isFrom)
        [[RequestManager sharedManager] setFromLangKey:lang.langKey];
    else
        [[RequestManager sharedManager] setToLangKey:lang.langKey];
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self closeModalAction:nil];    
}

@end
