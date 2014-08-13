AFWeather
=========

[![Build Status](https://travis-ci.org/AlvaroFranco/AFWeather.svg?branch=master)](https://travis-ci.org/AlvaroFranco/AFWeather)
[![alt text](https://cocoapod-badges.herokuapp.com/v/AFWeather/badge.png "")]()
[![alt text](https://cocoapod-badges.herokuapp.com/p/AFWeather/badge.png "")]()
[![alt text](https://camo.githubusercontent.com/f513623dcee61532125032bbf1ddffda06ba17c7/68747470733a2f2f676f2d736869656c64732e6865726f6b756170702e636f6d2f6c6963656e73652d4d49542d626c75652e706e67 "")]()

Getting the weather forecast never has been so easy and it supports 5 different services. It returns the raw json so you can easily get the data you need.

![alt text](https://raw.github.com/AlvaroFranco/AFWeather/master/preview.png "Preview")

##Installation

AFWeather is available on CocoaPods so you can get it by adding this line to your Podfile:
	
	pod 'AFWeather', '~> 1.0'
	
If you don't use CocoaPods, you will have to import these files into your project:

	AFWeather.h
	AFWeather.m

##Services supported

| Service name | Place name/Zip code | Coordinates | AFWeather name |
|----------|-------|----------|---------|-------------|
| **World Weather Online** | :white_check_mark: | :white_check_mark: | *AFWeatherAPIWorldWeatherOnline* |
| **Weather Undeground** | :white_check_mark: | :no_entry_sign: | *AFWeatherAPIWeatherUnderground* |
| **Open Weather Map** | :white_check_mark: | :white_check_mark: | *AFWeatherAPIOpenWeatherMap* |
| **AccuWeather** | :white_check_mark: | :no_entry_sign: | *AFWeatherAPIAccuWeather* |
| **Forecast.io** | :no_entry_sign: | :white_check_mark: | *AFWeatherAPIForecast* |

##Usage

First of all, make sure that you have imported the main class into the class where you are going to get the weather information.

	#import "AFWeather.h"
	
###Configuring the client

In order to make AFWeather know what service are you using and what's your API key, use the method ```-configureClientWithService:withAPIKey:```. Example:

    [[AFWeather sharedClient]configureClientWithService:AFWeatherAPIForecast withAPIKey:@"myawesomeapikey"];

    
###Getting the forecast from a city name or Zip code

For this, use ```-fetchForecastOfLocationWithName:andCompletionBlock:```

Example:

        [[AFWeather sharedClient]fetchForecastOfLocationWithName:@"Murcia" andCompletionBlock:^(NSDictionary *response, NSError *error) {
            
            if (!error) {

				// Handle the response dictionary with all the information
				
            } else {
            	
            	//Handle the error
            }
        }];

###Getting the forecast from the coordinates

You can also use the latitude and the longitude instead of the place name.

        [[AFWeather sharedClient]fetchForecastOfLocationWithLatitude:@"121.518446" andLogitude:@"-26.181156" andCompletionBlock:^(NSDictionary *response, NSError *error) {
            
            if (!error) {

				// Handle the response dictionary with all the information
				
            } else {
            	
            	//Handle the error
            }
        }];
		
##License
AFWeather is under MIT license so feel free to use it!

##Author
Made by Alvaro Franco. If you have any question, feel free to drop me a line at [alvarofrancoayala@gmail.com](mailto:alvarofrancoayala@gmail.com)
