//
//  MenuTableViewController.m
//  WaveInteractive
//
//  Created by cheaterhu on 2017/4/12.
//  Copyright © 2017年 cheaterhu. All rights reserved.
//

#import "MenuTableViewController.h"
#import "ToViewControllerNeedsConform.h"
#import "FlowingMenuTransitionManager.h"

@interface MenuTableViewController ()<ToViewControllerNeedsConform>
@property(strong, nonatomic) FlowingMenuTransitionManager *manager;
@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [FlowingMenuTransitionManager manager];
    self.transitioningDelegate = self.manager;
    self.manager.toVCDelegate = self;
}

-(void)flowingMenuNeedsDismissMenu
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" ];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"this is %li row",indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"click at indexPath :%@",indexPath);
}

@end
