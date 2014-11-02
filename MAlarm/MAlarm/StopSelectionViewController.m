//
//  StopSelectionViewController.m
//  MAlarm
//
//  Created by Chen on 5/4/13.
//
//

#import "StopSelectionViewController.h"
#import "TripTimeViewController.h"
#import "ScheduleChangeViewController.h"
#import "ArrivalAlarmViewController.h"
#import "ArrivalAlarmTableCell.h"

@interface StopSelectionViewController ()

@end

@implementation StopSelectionViewController
@synthesize selectedLine;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    dataManager =[ShareDataManager shareDataManager];
    self.title = NSLocalizedString(@"Station Selection", @"Station Selection");
    //selectedLine =@"";
    
    [self LoadStopData:selectedLine];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    

    UIImageView *bgImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TABLEHEIGHT)];
    bgImage.image = [UIImage imageNamed:@"selectstationbg"];
    [self.view addSubview:bgImage];
    
    
    StopTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TABLEHEIGHT) style:UITableViewStylePlain];
    [StopTableView setDelegate:self];
    [StopTableView setDataSource:self];
    [StopTableView setBackgroundColor:[UIColor clearColor]];
    StopTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:StopTableView];
    
    // Do any additional setup after loading the view from its nib.
}

// get station data for specific line
-(void)LoadStopData:(NSString*)line{
    stopList = [NSMutableArray array];
    
    NSString * dataPath=[[NSBundle mainBundle] pathForResource:line ofType:@"json"];
    NSData * data =[NSData dataWithContentsOfFile:dataPath];
    //NSString * dataContent = [NSString stringWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:&fileError];
    NSError *jsonError = nil;
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    NSLog(@"%@",dataDic);
    
    if (!jsonError) {
        
   
     for (NSDictionary * result in dataDic) {
        StationData * stopData = [[StationData alloc] init];
        stopData.StopName = result[@"sta"];
        stopData.LocLat = [result[@"lat"] floatValue];
        stopData.LocLon = [result[@"lon"] floatValue];
        stopData.HasLines=result[@"l"];
        
        [stopList addObject:stopData];
        
    
     }

    }
    else{
        NSLog(@"Json Error=%@",jsonError);
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [stopList count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  137.0f/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"Load txt!");
    static NSString *cellIdentifier = @"ArrivalAlarmTableCell";
    ArrivalAlarmTableCell *cell = (ArrivalAlarmTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil){
        cell= [[ArrivalAlarmTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
	}
    
    cell.contentView.backgroundColor=[UIColor blackColor];
    [cell.contentView setAlpha:0.7];
    cell.stationNameLabel.text=[[stopList objectAtIndex:indexPath.row] StopName];
    [cell.stationNameLabel setTextColor:[UIColor whiteColor]];
    cell.hasLines=[[stopList objectAtIndex:indexPath.row] HasLines];
    [cell.trainColorImageView setBackgroundColor:[UIColor colorWithRed:0 green:147/255.0 blue:60/255.0 alpha:1]];
    UIImageView * dotImageView=[[UIImageView alloc] initWithFrame:CGRectMake(cell.trainColorImageView.bounds.origin.x+10, cell.trainColorImageView.bounds.origin.x+32, 11, 11)];
    dotImageView.image=[UIImage imageNamed:@"dot"];
    [cell.contentView addSubview:dotImageView];
    cell.northTimeLabel.hidden = TRUE;
    cell.southTimeLabel.hidden = TRUE;
    
    for (int i=0; i < [cell.hasLines length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [cell.hasLines characterAtIndex:i]];
        NSLog(@"has lines %@",ichar);
        UIImageView * smallIcon=[[UIImageView alloc] initWithFrame:CGRectMake(80+20*(i),48,35/2,35/2)];
        smallIcon.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@iconlarge",ichar]];
        [cell.contentView addSubview:smallIcon];
    }
    //cell.lineIcon.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@iconlarge",[lineList objectAtIndex:indexPath.row]]];
    
    [cell.contentView addSubview:cell.lineIcon];
    
    //cell.friendPhoto.image = [[friendList objectAtIndex:indexPath.row] userPhoto] ;
    
    
    
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

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
    switch (dataManager.tState) {
        case tStateArrival:
        {
            if ([dataManager stationAlreadySavedinList:[[stopList objectAtIndex:indexPath.row] StopName] List:dataManager.arrivalSaveList]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[NSString stringWithFormat:@"%@ station is already saved in list.",[[stopList objectAtIndex:indexPath.row] StopName]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else{
                [dataManager.arrivalSaveList addObject:[stopList objectAtIndex:indexPath.row]];
                [dataManager saveData:tStateArrival];
                ArrivalAlarmViewController * arrivalAlarmViewController =[[ArrivalAlarmViewController alloc] init];
                [self.navigationController pushViewController:arrivalAlarmViewController animated:YES];
            }

        }
            break;
        case tStateScheduler:
            break;
        case tStateTripTime:
        {
            if ([dataManager stationAlreadySavedinList:[[stopList objectAtIndex:indexPath.row] StopName] List:dataManager.tripTImeSaveList]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[NSString stringWithFormat:@"%@ station is already saved in list.",[[stopList objectAtIndex:indexPath.row] StopName]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else{
                [[stopList objectAtIndex:indexPath.row] setFromLine:selectedLine];
                StationData *stationData = (StationData*)[stopList objectAtIndex:indexPath.row];
                
                [dataManager.tripTImeSaveList addObject:stationData];
                [dataManager saveData:tStateTripTime];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }

        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
