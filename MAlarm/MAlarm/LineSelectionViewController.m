//
//  LineSelectionViewController.m
//  MAlarm
//
//  Created by Chen on 5/4/13.
//
//

#import "LineSelectionViewController.h"
#import "StopSelectionViewController.h"
#import "ScheduleChangeViewController.h"
#import "ArrivalAlarmTableCell.h"

@interface LineSelectionViewController ()

@end

@implementation LineSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.title = NSLocalizedString(@"Line Selection", @"Line Selection");
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    dataManager=[ShareDataManager shareDataManager];
    [self getLineData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    
    UIImageView *bgImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TABLEHEIGHT)];
    bgImage.image = [UIImage imageNamed:@"selectlinebg"];
    [self.view addSubview:bgImage];
    
    
    LineSelectionTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TABLEHEIGHT) style:UITableViewStylePlain];
    [LineSelectionTable setDelegate:self];
    [LineSelectionTable setDataSource:self];
    [LineSelectionTable setBackgroundColor:[UIColor clearColor]];
    LineSelectionTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [LineSelectionTable setScrollsToTop:YES];
    //finishGameTable=[[UITableView alloc] initWithFrame:CGRectMake(20, 240, self.view.bounds.size.width-20, 100.0) style:UITableViewStyleGrouped];
    [self.view addSubview:LineSelectionTable];
    
  //@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"J",@"L",@"M",@"N",@"Q",@"R",@"S",@"Z"];
    // Do any additional setup after loading the view from its nib.
}

//Load train data from json
-(void)getLineData{
    lineList = [NSMutableArray array];

    
    NSString * dataPath=[[NSBundle mainBundle] pathForResource:@"LinesFullName" ofType:@"json"];
    NSData * data =[NSData dataWithContentsOfFile:dataPath];
    //NSString * dataContent = [NSString stringWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:&fileError];
    NSError *jsonError = nil;
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

    
    if (!jsonError) {
        
        
        for (NSDictionary * result in dataDic) {
            LineData * line =[[LineData alloc] init];
            line.lineName=result[@"lineName"];
            line.FullName=result[@"fullName"];
            [lineList addObject:line];
            
        }
    }
    else{
        NSLog(@"Json Error = %@",jsonError);
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
    return [lineList count];
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
    NSString * colorCase = [[lineList objectAtIndex:indexPath.row] lineName];
    
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
    
    
    cell.contentView.backgroundColor=[UIColor blackColor];
    [cell.contentView setAlpha:0.7];
    cell.stationNameLabel.text=[[lineList objectAtIndex:indexPath.row]FullName];
    [cell.stationNameLabel setTextColor:[UIColor whiteColor]];
    cell.northTimeLabel.hidden = TRUE;
    cell.southTimeLabel.hidden = TRUE;
    cell.lineIcon.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@iconlarge",[[lineList objectAtIndex:indexPath.row] lineName]]];

    [cell.contentView addSubview:cell.lineIcon];

    
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
    // Navigation logic may go here. Create and push another view controller.

    switch (dataManager.tState) {
        case tStateArrival:
        {
            
            StopSelectionViewController * stopSelectionViewController =[[StopSelectionViewController alloc] init];
            stopSelectionViewController.selectedLine=[[lineList objectAtIndex:indexPath.row] lineName];
            
            [self.navigationController pushViewController:stopSelectionViewController animated:YES];
        }
            break;
        case tStateScheduler:
        {
            if ([dataManager lineAlreadySavedinList:[[lineList objectAtIndex:indexPath.row] lineName] List:dataManager.schedulerSaveList]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[NSString stringWithFormat:@"%@ train is already saved in list.",[[lineList objectAtIndex:indexPath.row] lineName]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else{
                [dataManager.schedulerSaveList addObject:[[lineList objectAtIndex:indexPath.row] lineName]];
                [dataManager saveData:tStateScheduler];
                //ScheduleChangeViewController * scheduleChangeViewController =[[ScheduleChangeViewController alloc] init];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
            break;
        case tStateTripTime:
        {
       
            StopSelectionViewController * stopSelectionViewController =[[StopSelectionViewController alloc] init];
            stopSelectionViewController.selectedLine=[[lineList objectAtIndex:indexPath.row] lineName];
            [self.navigationController pushViewController:stopSelectionViewController animated:YES];
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
