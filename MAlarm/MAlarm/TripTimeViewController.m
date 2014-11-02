//
//  FirstViewController.m
//  MAlarm
//
//  Created by Chen on 5/4/13.
//
//

#import "TripTimeViewController.h"
#import "Webservice.h"
#import "LineSelectionViewController.h"
#import "ArrivalAlarmTableCell.h"

@interface TripTimeViewController ()

@end

@implementation TripTimeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Time", @"Time");
        self.tabBarItem.image = [UIImage imageNamed:@"arrivalicon.png"];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil] ;

    
    UIButton *settingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"addnew"] forState:UIControlStateNormal];
    [settingBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [settingBtn addTarget:self
                   action:@selector(gotoLinSelection:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* Menu_Right=[[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    self.navigationItem.rightBarButtonItem=Menu_Right;
    
    
    UIImageView *bgImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TABLEHEIGHT)];
    bgImage.image = [UIImage imageNamed:@"stationbg"];
    [self.view addSubview:bgImage];
    


    
    
    tripTimeTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TABLEHEIGHT) style:UITableViewStylePlain];
    [tripTimeTable setDelegate:self];
    [tripTimeTable setDataSource:self];
    [tripTimeTable setBackgroundColor:[UIColor clearColor]];
    //[tripTimeTable setSeparatorColor:[UIColor blackColor]];
    tripTimeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    //finishGameTable=[[UITableView alloc] initWithFrame:CGRectMake(20, 240, self.view.bounds.size.width-20, 100.0) style:UITableViewStyleGrouped];
    [self.view addSubview:tripTimeTable];
    timeResultList = [[NSMutableArray alloc] init];
    NSLog(@"%d",[dataManager.tripTImeSaveList count]);
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    //Use GCD for asyn , retrive save data.
    dataManager = [ShareDataManager shareDataManager];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [timeResultList removeAllObjects];
        for (StationData* station in [dataManager.tripTImeSaveList copy]) {
            NSDictionary *result = [Webservice getIncomingTrains:station.FromLine StopName:station.StopName];
            if(result == nil) {
                result = [[NSDictionary alloc] init];
                
            }else{
                [timeResultList addObject:result];
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [tripTimeTable reloadData];
        });
    });
    [tripTimeTable reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  137.0f/2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [dataManager.tripTImeSaveList count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"Load txt!");
    static NSString *cellIdentifier = @"ArrivalAlarmTableCell";
    ArrivalAlarmTableCell *cell = (ArrivalAlarmTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil){
        cell= [[ArrivalAlarmTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
	}
    
    cell.stationNameLabel.text=[[dataManager.tripTImeSaveList objectAtIndex:indexPath.row] StopName];
    cell.hasLines=[[dataManager.tripTImeSaveList objectAtIndex:indexPath.row] HasLines];
    cell.lineIcon.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@iconlarge",[[dataManager.tripTImeSaveList objectAtIndex:indexPath.row] FromLine]]];
    [cell.contentView addSubview:cell.lineIcon];
     cell.northTimeLabel.text = @"";
    cell.southTimeLabel.text = @"";
    if([timeResultList count] > [indexPath row]) {
        NSDictionary *timeResult = timeResultList[[indexPath row]];
        if([timeResult[@"N"] count] > 0) {
            NSString *timeStr = timeResult[@"N"][0];
            NSString *northTime = [NSString stringWithFormat:@"N %@", [timeStr substringFromIndex:11]];
            cell.northTimeLabel.text = northTime;
        }
        
        if([timeResult[@"S"] count] > 0) {
            NSString *timeStr = timeResult[@"S"][0];
            NSString *southTime = [NSString stringWithFormat:@"S %@", [timeStr substringFromIndex:11]];
            cell.southTimeLabel.text = southTime;
        }
        if ([timeResult[@"N"] count] == 0 && [timeResult[@"S"] count] == 0) {
            cell.northTimeLabel.text=@"Unavailable";
        }
    }
    else{
        cell.northTimeLabel.text = @"Loading...";
    }
    
    NSString * colorCase = [[dataManager.tripTImeSaveList objectAtIndex:indexPath.row] FromLine];
    
    if ([colorCase isEqualToString:@"1"]||[colorCase isEqualToString:@"2"]||[colorCase isEqualToString:@"3"]) {
        [cell.trainColorImageView setBackgroundColor:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
    }
    
    if ([colorCase isEqualToString:@"4"]||[colorCase isEqualToString:@"5"]||[colorCase isEqualToString:@"6"]) {
        [cell.trainColorImageView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:147/255.0 blue:60/255.0 alpha:1]];
    }
    
    
    if ([colorCase isEqualToString:@"7"]) {
        [cell.trainColorImageView setBackgroundColor:[UIColor colorWithRed:185/255.0 green:51/255.0 blue:173/255.0 alpha:1]];
    }
    
    
    if ([colorCase isEqualToString:@"A"]||[colorCase isEqualToString:@"C"]||[colorCase isEqualToString:@"E"]) {
        [cell.trainColorImageView setBackgroundColor:[UIColor colorWithRed:40/255.0 green:80/255.0 blue:173/255.0 alpha:1]];
    }
    
    
    if ([colorCase isEqualToString:@"B"]||[colorCase isEqualToString:@"D"]||[colorCase isEqualToString:@"F"]||[colorCase isEqualToString:@"M"]) {
        [cell.trainColorImageView setBackgroundColor:[UIColor colorWithRed:246/255.0 green:99/255.0 blue:25/255.0 alpha:1]];
    }
    
    if ([colorCase isEqualToString:@"G"]) {
        [cell.trainColorImageView setBackgroundColor:[UIColor colorWithRed:108/255.0 green:190/255.0 blue:69/255.0 alpha:1]];
    }
    
    if ([colorCase isEqualToString:@"J"]||[colorCase isEqualToString:@"Z"]) {
        [cell.trainColorImageView setBackgroundColor:[UIColor colorWithRed:153/255.0 green:102/255.0 blue:51/255.0 alpha:1]];
    }
    
    if ([colorCase isEqualToString:@"L"]) {
        [cell.trainColorImageView setBackgroundColor:[UIColor colorWithRed:167/255.0 green:169/255.0 blue:172/255.0 alpha:1]];
    }
    
    if ([colorCase isEqualToString:@"S"]) {
        [cell.trainColorImageView setBackgroundColor:[UIColor colorWithRed:128/255.0 green:129/255.0 blue:131/255.0 alpha:1]];
    }
    
    if ([colorCase isEqualToString:@"N"]||[colorCase isEqualToString:@"Q"]||[colorCase isEqualToString:@"R"]) {
        [cell.trainColorImageView setBackgroundColor:[UIColor colorWithRed:255/255.0 green:204/255.0 blue:0/255.0 alpha:1]];
    }

    
    for (int i=0; i < [cell.hasLines length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [cell.hasLines characterAtIndex:i]];
        UIImageView * smallIcon=[[UIImageView alloc] initWithFrame:CGRectMake(80+20*(i),50,35/2,35/2)];
        smallIcon.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@iconlarge",ichar]];
        [cell.contentView addSubview:smallIcon];
    }
    
    //cell.friendPhoto.image = [[friendList objectAtIndex:indexPath.row] userPhoto] ;
    
    return cell;
}



 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     // Return NO if you do not want the specified item to be editable.
     return YES;
 }



 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [dataManager.tripTImeSaveList removeObjectAtIndex:[indexPath row]];
        [dataManager saveData:tStateTripTime];
        [tripTimeTable reloadData];
    }
 }


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}



#pragma Button Method
-(void)gotoLinSelection:(id)sender{
    dataManager.tState = tStateTripTime;
    LineSelectionViewController* lineSelectionViewController =[[LineSelectionViewController alloc] init];
    [self.navigationController pushViewController:lineSelectionViewController animated:YES];
    
}
-(void)deleteItems:(id)sender{
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
