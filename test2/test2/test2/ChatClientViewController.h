//
//  ChatClientViewController.h
//  test2
//
//  Created by wei wei on 5/9/15.
//  Copyright (c) 2015 wei wei. All rights reserved.
//

#import "ViewController.h"

@interface ChatClientViewController : ViewController<NSStreamDelegate>

//@interface ChatClientViewController : UIViewController <NSStreamDelegate, UITableViewDelegate, UITableViewDataSource> {
    
@property (strong, nonatomic) IBOutlet UIView *chatView;
@property (weak, nonatomic) IBOutlet UITableView *tView;
- (IBAction)sendMessage:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *inputMessageField;

@property NSMutableArray * messages;
@end
