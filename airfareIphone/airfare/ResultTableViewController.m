//
//  ResultTableViewController.m
//  airfare
//
//  Created by Jing Lin on 5/11/15.
//  Copyright (c) 2015 Jing Lin. All rights reserved.
//

#import "ResultTableViewController.h"
#import "ResultItem.h"
#import "QueryViewController.h"

@interface ResultTableViewController ()



@end

@implementation ResultTableViewController

- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"localhost", 5999, &readStream, &writeStream);
    self.inputStream = (__bridge NSInputStream *)readStream;
    self.outputStream = (__bridge NSOutputStream *)writeStream;
    
    [self.inputStream setDelegate:self];
    [self.outputStream setDelegate:self];
    
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [self.inputStream open];
    [self.outputStream open];
}

- (void)sentInfo {

    [self initNetworkCommunication];
    ResultItem* result=(ResultItem*)self.resultItems[0];
    NSString *combined = [NSString stringWithFormat:@"%@%@%@%@%@", result.from, @":", result.to, @":", result.fligtDate];
    NSData *data = [[NSData alloc] initWithData:[combined dataUsingEncoding:NSASCIIStringEncoding]];
    [self.outputStream write:[data bytes] maxLength:[data length]];
    [self.resultItems removeAllObjects];
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    
    enum {
        NSStreamEventNone = 0,
        NSStreamEventOpenCompleted = 1 << 0,
        NSStreamEventHasBytesAvailable = 1 << 1,
        NSStreamEventHasSpaceAvailable = 1 << 2,
        NSStreamEventErrorOccurred = 1 << 3,
        NSStreamEventEndEncountered = 1 << 4
    };
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
            
        case NSStreamEventHasBytesAvailable:
            
            if (theStream == self.inputStream) {
                
                uint8_t buffer[10240];
                int len;
                
                while ([self.inputStream hasBytesAvailable]) {
                    len = (int)[self.inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
//                        NSLog(output);
                        
                        
                        
                        NSData *data = [output dataUsingEncoding:NSUTF8StringEncoding];
                        NSError *e = nil;
                        NSArray *JSONarray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
                        for(int i=0;i<[JSONarray count];i++)
                        {
                            NSLog(@"%@%d",@"entry no. ",i);
                            NSString *total=[[JSONarray objectAtIndex:i]objectForKey:@"total"];
                            NSArray *flights=[[JSONarray objectAtIndex:i]objectForKey:@"flights"];
                            
                            ResultItem *received = [[ResultItem alloc] init];
                            received.title=total;
                            
                            for(int j=0;j<[flights count];j++){
                                NSString *arrival=[[flights objectAtIndex:j]objectForKey:@"arrival"];
                                NSLog(@"%@",arrival);
                                NSString *to=[[flights objectAtIndex:j]objectForKey:@"to"];
                                NSLog(@"%@",to);
                                NSString *from=[[flights objectAtIndex:j]objectForKey:@"fr"];
                                NSLog(@"%@",from);
                                NSString *depature=[[flights objectAtIndex:j]objectForKey:@"depature"];
                                NSLog(@"%@\n",depature);
                                
                                NSString *combined=nil;
                                NSString *line1 = [NSString stringWithFormat:@"%@%@%@", from, @"  ->  ", to];
                                NSString *line2 = [NSString stringWithFormat:@"%@%@%@",arrival,@"  ->  ",depature];
                                NSString *line3 = @"-------------";
                                if(j==0){
                                    received.detail =[NSString stringWithFormat:@"%@\n%@",line1, line2];
                                }else{
                                    combined =[NSString stringWithFormat:@"%@\n%@\n%@",line3, line1, line2];
                                    received.detail=[NSString stringWithFormat:@"%@\n%@", received.detail, combined];
                                }
                                
                                
                                //            received.detail=combined;
                            }
                            
                            
                            [self.resultItems addObject:received];
                            
                        }
                        
                        
                        
//                        NSArray *split_flight = [output componentsSeparatedByString:@"\t"];
//                        for (NSString* flightEntry in split_flight) {
//                            NSArray *split_item = [flightEntry componentsSeparatedByString:@" "];
//                            ResultItem *received = [[ResultItem alloc] init];
//                            received.from = split_item[0];
//                            received.to=split_item[1];
//                            received.fligtDate=split_item[2];
//                            [self.resultItems addObject:received];
//                        }
                        
                        
                        [self.tableView reloadData];
                        
                        if (nil != output) {
//                            NSLog(@"server said: %@", output);
                        }
                        [self.inputStream close];
                    }
                }
            }
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
            
        case NSStreamEventEndEncountered:
            NSLog(@"event ended");
            
            break;
            
        default:
            NSLog(@"Unknown event");
    }
    
}


- (void)loadInitialData {
    
    NSString *jsonString = @"[{\"flights\": [{\"arrival\": \"2015-07-11T09:50-07:00\", \"to\": \"LAX\", \"fr\": \"BOS\", \"depature\": \"2015-07-11T06:28-04:00\"}], \"total\": \"USD193.10\"}, {\"flights\": [{\"arrival\": \"2015-07-11T09:26-07:00\", \"to\": \"LAX\", \"fr\": \"BOS\", \"depature\": \"2015-07-11T06:00-04:00\"}], \"total\": \"USD223.10\"}, {\"flights\": [{\"arrival\": \"2015-07-11T11:40-07:00\", \"to\": \"LAX\", \"fr\": \"BOS\", \"depature\": \"2015-07-11T08:15-04:00\"}], \"total\": \"USD223.10\"}, {\"flights\": [{\"arrival\": \"2015-07-11T11:40-07:00\", \"to\": \"LAX\", \"fr\": \"BOS\", \"depature\": \"2015-07-11T08:15-04:00\"}], \"total\": \"USD231.45\"}, {\"flights\": [{\"arrival\": \"2015-07-11T09:26-07:00\", \"to\": \"LAX\", \"fr\": \"BOS\", \"depature\": \"2015-07-11T06:00-04:00\"}], \"total\": \"USD231.45\"}, {\"flights\": [{\"arrival\": \"2015-07-11T13:36-07:00\", \"to\": \"LAX\", \"fr\": \"BOS\", \"depature\": \"2015-07-11T10:15-04:00\"}], \"total\": \"USD258.10\"}, {\"flights\": [{\"arrival\": \"2015-07-11T08:18-04:00\", \"to\": \"CLT\", \"fr\": \"BOS\", \"depature\": \"2015-07-11T06:00-04:00\"}, {\"arrival\": \"2015-07-11T12:00-07:00\", \"to\": \"LAX\", \"fr\": \"CLT\", \"depature\": \"2015-07-11T09:45-04:00\"}], \"total\": \"USD265.10\"}, {\"flights\": [{\"arrival\": \"2015-07-11T09:04-07:00\", \"to\": \"PHX\", \"fr\": \"BOS\", \"depature\": \"2015-07-11T06:20-04:00\"}, {\"arrival\": \"2015-07-11T13:25-07:00\", \"to\": \"LAX\", \"fr\": \"PHX\", \"depature\": \"2015-07-11T12:00-07:00\"}], \"total\": \"USD266.60\"}, {\"flights\": [{\"arrival\": \"2015-07-11T13:29-04:00\", \"to\": \"DCA\", \"fr\": \"BOS\", \"depature\": \"2015-07-11T12:00-04:00\"}, {\"arrival\": \"2015-07-11T19:49-07:00\", \"to\": \"LAX\", \"fr\": \"DCA\", \"depature\": \"2015-07-11T17:05-04:00\"}], \"total\": \"USD266.60\"}, {\"flights\": [{\"arrival\": \"2015-07-11T07:57-04:00\", \"to\": \"PHL\", \"fr\": \"BOS\", \"depature\": \"2015-07-11T06:30-04:00\"}, {\"arrival\": \"2015-07-11T12:37-07:00\", \"to\": \"LAX\", \"fr\": \"PHL\", \"depature\": \"2015-07-11T09:45-04:00\"}], \"total\": \"USD266.60\"}]";
    
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e = nil;
    NSArray *JSONarray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    for(int i=0;i<[JSONarray count];i++)
    {
        NSLog(@"%@%d",@"entry no. ",i);
        NSString *total=[[JSONarray objectAtIndex:i]objectForKey:@"total"];
        NSArray *flights=[[JSONarray objectAtIndex:i]objectForKey:@"flights"];
        NSLog(@"%@",total);
        NSLog(@"%@",flights);
        
        ResultItem *received = [[ResultItem alloc] init];
        received.title=total;
        
        for(int j=0;j<[flights count];j++){
            NSLog(@"%@%d",@"flight at ",j);
            NSString *arrival=[[flights objectAtIndex:j]objectForKey:@"arrival"];
            NSLog(@"%@",arrival);
            NSString *to=[[flights objectAtIndex:j]objectForKey:@"to"];
            NSLog(@"%@",to);
            NSString *from=[[flights objectAtIndex:j]objectForKey:@"fr"];
            NSLog(@"%@",from);
            NSString *depature=[[flights objectAtIndex:j]objectForKey:@"depature"];
            NSLog(@"%@",depature);
            
            NSString *combined=nil;
            NSString *line1 = [NSString stringWithFormat:@"%@%@%@", from, @"  ->  ", to];
            NSString *line2 = [NSString stringWithFormat:@"%@%@%@",arrival,@"  ->  ",depature];
            NSString *line3 = @"-------------";
            if(j==0){
                received.detail =[NSString stringWithFormat:@"%@\n%@",line1, line2];
            }else{
                combined =[NSString stringWithFormat:@"%@\n%@\n%@",line3, line1, line2];
                received.detail=[NSString stringWithFormat:@"%@\n%@", received.detail, combined];
            }
            
            
//            received.detail=combined;
        }
        
        
        [self.resultItems addObject:received];
        
    }

}


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadInitialData];
    [self sentInfo];
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.resultItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tableview called");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    ResultItem *resultItem = [self.resultItems objectAtIndex:indexPath.row];
    
    cell.textLabel.text = resultItem.title;
    
    cell.detailTextLabel.text = resultItem.detail;
    
    
    return cell;
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    QueryViewController *source = [segue sourceViewController];
    ResultItem *item = source.resultItem;
    if (item != nil) {
        [self.resultItems addObject:item];
        [self.tableView reloadData];
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"prepareForSegue: %@", segue.identifier);
    
//    QueryViewController *controller = (QueryViewController *)segue.destinationViewController;
//    ResultItem *item=controller.resultItem;
    QueryViewController *source = [segue sourceViewController];
    ResultItem *item = source.resultItem;
    if (item != nil) {
        [self.resultItems addObject:item];
        [self.tableView reloadData];
    }
    
}


@end
