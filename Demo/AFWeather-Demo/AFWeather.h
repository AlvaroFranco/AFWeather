//
//  AFWeather.h
//  AFWeather-Demo
//
//  Created by Alvaro Franco on 4/22/14.
//  Copyright (c) 2014 AlvaroFranco. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AFWeatherAPI) {
    AFWeatherAPIWorldWeatherOnline,
    AFWeatherAPIWeatherUnderground,
    AFWeatherAPIForecast,
    AFWeatherAPIOpenWeatherMap,
    AFWeatherAPIAccuWeather,
    AFWeatherAPITest
};

typedef NS_ENUM(NSInteger, AFWeatherLocationType) {
    AFWeatherLocationTypeName,
    AFWeatherLocationTypeLatLon,
    AFWeatherLocationTypeCurrent
};

@interface AFWeather : NSObject

typedef void (^completionBlock)(NSDictionary *response, NSError *error);

+(instancetype)sharedClient;

-(void)configureClientWithService:(AFWeatherAPI)service withAPIKey:(NSString *)apiKey;

-(void)fetchForecastOfLocationWithName:(NSString *)locationName andCompletionBlock:(completionBlock)completion;
-(void)fetchForecastOfLocationWithLatitude:(NSString *)lat andLogitude:(NSString *)lon andCompletionBlock:(completionBlock)completion;

@end

@interface NSString (AFURLEncoding)

-(NSString *)encodeForURLWithEncoding:(NSStringEncoding)encoding;

@end
