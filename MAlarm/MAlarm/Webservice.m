//
//  Webservice.m
//  MAlarm
//
//  Created by Chen on 5/5/13.
//
//

#import "Webservice.h"

@implementation Webservice

+(NSDictionary *)getIncomingTrains:(NSString*)routeID StopName:(NSString*)stopName
{
    NSString *strURL = [NSString stringWithFormat:API_GETINCOMINGTRAINS, routeID, stopName];
      
    NSURL *url = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
     NSLog(@"URL is %@",url);
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSError        *error = nil;
    NSURLResponse  *response = nil;
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary* result =[NSDictionary dictionary];
    if (!error) {
        result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"Result = %@",result);
    }
    else{
        result = nil;
        
        //NSLog(@"Server Error=%@",error);
    }
    // Not Use NSOpreatrion here for asyn but use GCD for asyn
    /*;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    __block NSDictionary *result = [NSDictionary dictionary];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
  
        
        
        if (!error) {
            
            result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
             NSLog(@"Response = %@",result);
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Server Connection Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
            NSLog(@"Server Error=%@",error);
        }
    }];
     */
    return result;
   
}

+(NSDictionary *)getServiceStatus
{
    NSString *strURL = API_GETSERVICESTATUS;
    NSURL *url = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
   
    NSError        *error = nil;
    NSURLResponse  *response = nil;
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary* result =[NSDictionary dictionary];
    if (!error) {
        result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
    else{
        result = nil;

    }
  
 
    return result;
}
@end
