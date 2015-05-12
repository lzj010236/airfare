//
//  ViewController.h
//  test2
//
//  Created by wei wei on 5/9/15.
//  Copyright (c) 2015 wei wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSStreamDelegate>
@property (strong, nonatomic) IBOutlet UIView *joinView;
@property (weak, nonatomic) IBOutlet UITextField *inputNameField;
- (IBAction)joinChat:(id)sender;


@property NSInputStream *inputStream;
@property NSOutputStream *outputStream;

@end

