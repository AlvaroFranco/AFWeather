//
//  ViewController.m
//  AFWeather-Demo
//
//  Created by Alvaro Franco on 4/22/14.
//  Copyright (c) 2014 AlvaroFranco. All rights reserved.
//

#import "ViewController.h"
#import "AFWeather.h"

@interface ViewController ()

@property (nonatomic, strong) NSString *response;

-(void)showCityNameResponse;
-(void)showCoordinatesResponse;

@end

@implementation ViewController

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidLoad {
    [super viewDidLoad];

    [_cityNameButton addTarget:self action:@selector(showCityNameResponse) forControlEvents:UIControlEventTouchUpInside];
    [_coordinatesButton addTarget:self action:@selector(showCoordinatesResponse) forControlEvents:UIControlEventTouchUpInside];
    
    _cityNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"City name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    _latTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Latitude" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    _lonTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Longitude" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [[AFWeather sharedClient]configureClientWithService:AFWeatherAPITest withAPIKey:nil];
}

-(void)showCityNameResponse {
    
    if (_cityNameTextField.text.length != 0) {
        
        [[AFWeather sharedClient]fetchForecastOfLocationWithName:_cityNameTextField.text andCompletionBlock:^(NSDictionary *response, NSError *error) {
            
            if (!error) {

                NSData *data = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:nil];
                NSLog(@"%@",[NSString stringWithUTF8String:[data bytes]]);
            }
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You need to provide a valid name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)showCoordinatesResponse {
    
    if (_cityNameTextField.text.length != 0) {
        
        [[AFWeather sharedClient]fetchForecastOfLocationWithLatitude:_latTextField.text andLogitude:_lonTextField.text andCompletionBlock:^(NSDictionary *response, NSError *error) {
            
            if (!error) {
                
                NSData *data = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:nil];
                NSLog(@"%@",[NSString stringWithUTF8String:[data bytes]]);
            }
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You need to provide a valid name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_cityNameTextField resignFirstResponder];
    [_latTextField resignFirstResponder];
    [_lonTextField resignFirstResponder];
}

@end
