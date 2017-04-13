//
//  MainTableViewController.m
//  WaveInteractive
//
//  Created by cheaterhu on 2017/4/12.
//  Copyright © 2017年 cheaterhu. All rights reserved.
//

#import "MainTableViewController.h"
#import "FlowingMenuTransitionManager.h"
#import "FromViewControllerNeedsConform.h"

@interface MainTableViewController ()<FromViewControllerNeedsConform>
@property(strong, nonatomic) FlowingMenuTransitionManager *manager;
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [FlowingMenuTransitionManager manager];
    [self.manager setInteractivePresentationView:self.view];
    self.manager.fromVCDelegate = self;
}

-(UIColor *)colorOfElasticShapeInFlowingMenu:(UIView *)menuView
{
    return [UIColor cyanColor];
}
- (void)flowingMenuNeedsPresentMenu
{
    [self presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"menu"] animated:YES completion:nil];
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
    cell.textLabel.text = [NSString stringWithFormat:@"main view  this is %li row",indexPath.row];
  
    return cell;
}

@end
