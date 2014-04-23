//
//  ViewController.h
//  AFWeather-Demo
//
//  Created by Alvaro Franco on 4/22/14.
//  Copyright (c) 2014 AlvaroFranco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *cityNameTextField;
@property (nonatomic, strong) IBOutlet UIButton *cityNameButton;

@property (nonatomic, strong) IBOutlet UITextField *latTextField;
@property (nonatomic, strong) IBOutlet UITextField *lonTextField;
@property (nonatomic, strong) IBOutlet UIButton *coordinatesButton;

@end
