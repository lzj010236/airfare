//
//  QueryViewController.m
//  airfare
//
//  Created by Jing Lin on 5/9/15.
//  Copyright (c) 2015 Jing Lin. All rights reserved.
//

#import "QueryViewController.h"
#import "ResultTableViewController.h"

@interface QueryViewController ()
@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UITextField *to;
@property (weak, nonatomic) IBOutlet UITextField *from;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation QueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
//    if (sender != self.submitButton) return;
//    if (self.from.text.length > 0) {
    ResultTableViewController *controller = (ResultTableViewController *)segue.destinationViewController;
        NSLog(@"executed");
        self.resultItem = [[ResultItem alloc] init];
        self.resultItem.from = self.from.text;
        self.resultItem.to=self.to.text;
        self.resultItem.fligtDate=self.date.text;
    controller.resultItems = [[NSMutableArray alloc] init];
    [controller.resultItems addObject:self.resultItem];
//    }
//    [[ResultTableViewController resultItems] addObject:self.resultItem];
//    ResultTableViewController *viewControllerB = [[ResultTableViewController alloc] initWithNib:@"ResultTableViewController" bundle:nil];
}


@end
