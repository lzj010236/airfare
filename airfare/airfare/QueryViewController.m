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
//@property (weak, nonatomic) IBOutlet UITextField *from;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextField *from;

@end

@implementation QueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSString *jsonString = @"[{\"flights\": [{\"arrival\": \"2015-07-11T09:50-07:00\", \"to\": \"LAX\", \"fr\": \"BOS\", \"depature\": \"2015-07-11T06:28-04:00\"}], \"total\": \"USD193.10\"}, {\"flights\": [{\"arrival\": \"2015-07-11T09:26-07:00\", \"to\": \"LAX\", \"fr\": \"BOS\", \"depature\": \"2015-07-11T06:00-04:00\"}], \"total\": \"USD223.10\"}, {\"flights\": [{\"arrival\": \"2015-07-11T11:40-07:00\", \"to\": \"LAX\", \"fr\": \"BOS\", \"depature\": \"2015-07-11T08:15-04:00\"}], \"total\": \"USD223.10\"}, {\"flights\": [{\"arrival\": \"2015-07-11T11:40-07:00\", \"to\": \"LAX\", \"fr\": \"BOS\", \"depature\": \"2015-07-11T08:15-04:00\"}], \"total\": \"USD231.45\"}, {\"flights\": [{\"arrival\": \"2015-07-11T09:26-07:00\", \"to\": \"LAX\", \"fr\": \"BOS\", \"depature\": \"2015-07-11T06:00-04:00\"}], \"total\": \"USD231.45\"}, {\"flights\": [{\"arrival\": \"2015-07-11T13:36-07:00\", \"to\": \"LAX\", \"fr\": \"BOS\", \"depature\": \"2015-07-11T10:15-04:00\"}], \"total\": \"USD258.10\"}, {\"flights\": [{\"arrival\": \"2015-07-11T08:18-04:00\", \"to\": \"CLT\", \"fr\": \"BOS\", \"depature\": \"2015-07-11T06:00-04:00\"}, {\"arrival\": \"2015-07-11T12:00-07:00\", \"to\": \"LAX\", \"fr\": \"CLT\", \"depature\": \"2015-07-11T09:45-04:00\"}], \"total\": \"USD265.10\"}, {\"flights\": [{\"arrival\": \"2015-07-11T09:04-07:00\", \"to\": \"PHX\", \"fr\": \"BOS\", \"depature\": \"2015-07-11T06:20-04:00\"}, {\"arrival\": \"2015-07-11T13:25-07:00\", \"to\": \"LAX\", \"fr\": \"PHX\", \"depature\": \"2015-07-11T12:00-07:00\"}], \"total\": \"USD266.60\"}, {\"flights\": [{\"arrival\": \"2015-07-11T13:29-04:00\", \"to\": \"DCA\", \"fr\": \"BOS\", \"depature\": \"2015-07-11T12:00-04:00\"}, {\"arrival\": \"2015-07-11T19:49-07:00\", \"to\": \"LAX\", \"fr\": \"DCA\", \"depature\": \"2015-07-11T17:05-04:00\"}], \"total\": \"USD266.60\"}, {\"flights\": [{\"arrival\": \"2015-07-11T07:57-04:00\", \"to\": \"PHL\", \"fr\": \"BOS\", \"depature\": \"2015-07-11T06:30-04:00\"}, {\"arrival\": \"2015-07-11T12:37-07:00\", \"to\": \"LAX\", \"fr\": \"PHL\", \"depature\": \"2015-07-11T09:45-04:00\"}], \"total\": \"USD266.60\"}]";
//    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *e = nil;
//    NSArray *JSONarray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
//    for(int i=0;i<[JSONarray count];i++)
//    {
//        NSLog(@"%@%d",@"entry no. ",i);
//        NSString *total=[[JSONarray objectAtIndex:i]objectForKey:@"total"];
//        NSArray *flights=[[JSONarray objectAtIndex:i]objectForKey:@"flights"];
//        NSLog(@"%@",total);
//        NSLog(@"%@",flights);
//        
//        for(int j=0;j<[flights count];j++){
//            NSLog(@"%@%d",@"flight at ",j);
//            NSString *arrival=[[flights objectAtIndex:j]objectForKey:@"arrival"];
//            NSLog(@"%@",arrival);
//            NSString *to=[[flights objectAtIndex:j]objectForKey:@"to"];
//            NSLog(@"%@",to);
//            NSString *fr=[[flights objectAtIndex:j]objectForKey:@"fr"];
//            NSLog(@"%@",fr);
//            NSString *depature=[[flights objectAtIndex:j]objectForKey:@"depature"];
//            NSLog(@"%@",depature);
//        }
//        
//    }
    
    
    
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
    
}


@end
