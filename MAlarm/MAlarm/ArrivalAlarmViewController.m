//
//  ArrivalAlarmViewController.m
//  MAlarm
//
//  Created by Chen on 5/4/13.
//
//UIFont *helvFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];

#import "ArrivalAlarmViewController.h"
#import "LineSelectionViewController.h"
#import "ArrivalAlarmTableCell.h"

@interface ArrivalAlarmViewController ()

@end

@implementation ArrivalAlarmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = NSLocalizedString(@"Alarm", @"Alarm");
        self.tabBarItem.image = [UIImage imageNamed:@"stationicon"];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    dataManager=[ShareDataManager shareDataManager];
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
    bgImage.image = [UIImage imageNamed:@"arrivalbg"];
    [self.view addSubview:bgImage];
    

   
    //addnew
    
    arrivalTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TABLEHEIGHT) style:UITableViewStylePlain];
    [arrivalTable setDelegate:self];
    [arrivalTable setDataSource:self];
    [arrivalTable setBackgroundColor:[UIColor clearColor]];
    arrivalTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    //finishGameTable=[[UITableView alloc] initWithFrame:CGRectMake(20, 240, self.view.bounds.size.width-20, 100.0) style:UITableViewStyleGrouped];
    [self.view addSubview:arrivalTable];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma Button Method
-(void)gotoLinSelection:(id)sender{
    dataManager.tState = tStateArrival;
    LineSelectionViewController* lineSelectionViewController =[[LineSelectionViewController alloc] init];
    [self.navigationController pushViewController:lineSelectionViewController animated:YES];
    
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
    return [dataManager.arrivalSaveList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"Load txt!");
    static NSString *cellIdentifier = @"ArrivalAlarmTableCell";
    ArrivalAlarmTableCell *cell = (ArrivalAlarmTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil){
        cell= [[ArrivalAlarmTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
	}
    
    cell.stationNameLabel.text=[[dataManager.arrivalSaveList objectAtIndex:indexPath.row] StopName];
    cell.hasLines=[[dataManager.arrivalSaveList objectAtIndex:indexPath.row] HasLines];
    cell.lineIcon.image=[UIImage imageNamed:[NSString stringWithFormat:@"alarmicon"]];
    cell.northTimeLabel.hidden=YES;
    cell.southTimeLabel.hidden=YES;
    
    [cell.contentView addSubview:cell.lineIcon];
    
    for (int i=0; i < [cell.hasLines length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [cell.hasLines characterAtIndex:i]];
        UIImageView * smallIcon=[[UIImageView alloc] initWithFrame:CGRectMake(80+20*(i),48,35/2,35/2)];
        smallIcon.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@iconlarge",ichar]];
        [cell.contentView addSubview:smallIcon];
    }
    
    //cell.friendPhoto.image = [[friendList objectAtIndex:indexPath.row] userPhoto] ;
    
    
    
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  137.0f/2;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [dataManager.arrivalSaveList removeObjectAtIndex:[indexPath row]];
        [dataManager saveData:tStateArrival];
        [arrivalTable reloadData];
        
    }
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
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
