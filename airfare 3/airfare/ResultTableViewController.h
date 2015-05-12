//
//  ResultTableViewController.h
//  airfare
//
//  Created by Jing Lin on 5/11/15.
//  Copyright (c) 2015 Jing Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultTableViewController : UITableViewController<NSStreamDelegate>

@property NSMutableArray *resultItems;
@property NSInputStream *inputStream;
@property NSOutputStream *outputStream;

@end
