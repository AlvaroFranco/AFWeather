//
//  AFWeather.m
//  AFWeather-Demo
//
//  Created by Alvaro Franco on 4/22/14.
//  Copyright (c) 2014 AlvaroFranco. All rights reserved.
//

#import "AFWeather.h"

@interface AFWeather ()

@property (nonatomic) BOOL isConfigured;
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic) AFWeatherAPI apiProvider;
@property (nonatomic) AFWeatherLocationType locationType;

-(NSURLRequest *)requestForLocationName:(NSString *)name orLatitude:(NSString *)lat andLongitude:(NSString *)lon;

@end

@implementation AFWeather

+(instancetype)sharedClient {
    
    static AFWeather *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [self new];
    });
    
    return sharedClient;
}

-(void)configureClientWithService:(AFWeatherAPI)service withAPIKey:(NSString *)apiKey {
    
    if ((service && apiKey) || service == AFWeatherAPITest) {
        
        _apiProvider = service;
        
        switch (service) {
            case AFWeatherAPIWorldWeatherOnline:
                _baseURL = [NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v1/tz.ashx?key=%@&format=json", apiKey];
                break;
                
            case AFWeatherAPIWeatherUnderground:
                _baseURL = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions", apiKey];
                break;
                
            case AFWeatherAPIForecast:
                _baseURL = [NSString stringWithFormat:@"http://api.forecast.io/forecast/%@", apiKey];
                break;
                
            case AFWeatherAPIOpenWeatherMap:
                _baseURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?APPID=%@", apiKey];
                break;
                
            case AFWeatherAPIAccuWeather:
                _baseURL = [NSString stringWithFormat:@"http://api.accuweather.com/locations/v1/search?apikey=%@", apiKey];
                break;
                
            case AFWeatherAPITest:
                _baseURL = @"http://api.openweathermap.org/data/2.5/weather";
                break;

            default:
                break;
        }
        
    } else if (service) {
        NSLog(@"AFWeather message: You need to provide a valid service");
    } else if (apiKey) {
        NSLog(@"AFWeather message: You need to provide a valid API key/App ID for the chosen service");
    } else {
        NSLog(@"AFWeather message: You need to provide a valid service and a valid API key/App ID for that service");
    }
}

-(void)fetchForecastOfLocationWithName:(NSString *)locationName andCompletionBlock:(completionBlock)completion {
    
    if (_baseURL && _apiProvider) {
        
        _locationType = AFWeatherLocationTypeName;
        
        [NSURLConnection sendAsynchronousRequest:[self requestForLocationName:locationName orLatitude:nil andLongitude:nil] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if (!connectionError) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                completion(json, nil);
            } else {
                completion(nil, connectionError);
            }
        }];
    }
}

-(void)fetchForecastOfLocationWithLatitude:(NSString *)lat andLogitude:(NSString *)lon andCompletionBlock:(completionBlock)completion {
    
    if (_baseURL && _apiProvider) {
        
        _locationType = AFWeatherLocationTypeLatLon;
        
        [NSURLConnection sendAsynchronousRequest:[self requestForLocationName:nil orLatitude:lat andLongitude:lon] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if (!connectionError) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                completion(json, nil);
            } else {
                completion(nil, connectionError);
            }
        }];
    }
}

-(NSURLRequest *)requestForLocationName:(NSString *)name orLatitude:(NSString *)lat andLongitude:(NSString *)lon {
    
    NSURLRequest *request = [NSURLRequest new];
    
    if (_locationType == AFWeatherLocationTypeName) {
        
        switch (_apiProvider) {
            case AFWeatherAPIWorldWeatherOnline: case AFWeatherAPIOpenWeatherMap: case AFWeatherAPIAccuWeather:
                request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_baseURL stringByAppendingString:[NSString stringWithFormat:@"&q=%@",[name encodeForURLWithEncoding:NSUTF8StringEncoding]]]]];
                break;
                
            case AFWeatherAPIWeatherUnderground:
                request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_baseURL stringByAppendingString:[NSString stringWithFormat:@"/q/%@",[name encodeForURLWithEncoding:NSUTF8StringEncoding]]]]];
                break;
                
            case AFWeatherAPIForecast:
                NSLog(@"AFWeather message: forecast.io does not support city name location, you must use coordinates");
                
            case AFWeatherAPITest:
                request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_baseURL stringByAppendingString:[NSString stringWithFormat:@"?q=%@",[name encodeForURLWithEncoding:NSUTF8StringEncoding]]]]];
                break;
                
            default:
                break;
        }
    } else {
        
        switch (_apiProvider) {
            case AFWeatherAPIWorldWeatherOnline:
                request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_baseURL stringByAppendingString:[NSString stringWithFormat:@"&q=%@/%@",[[lat stringByReplacingOccurrencesOfString:@"," withString:@"."] encodeForURLWithEncoding:NSUTF8StringEncoding],[[lon stringByReplacingOccurrencesOfString:@"," withString:@"."] encodeForURLWithEncoding:NSUTF8StringEncoding]]]]];
                break;

            case AFWeatherAPIOpenWeatherMap:
                request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_baseURL stringByAppendingString:[NSString stringWithFormat:@"&lat=%@&lon=%@",[[lat stringByReplacingOccurrencesOfString:@"," withString:@"."] encodeForURLWithEncoding:NSUTF8StringEncoding],[[lon stringByReplacingOccurrencesOfString:@"," withString:@"."] encodeForURLWithEncoding:NSUTF8StringEncoding]]]]];
                break;
                
            case AFWeatherAPIAccuWeather:
                NSLog(@"AFWeather message: Accu Weather does not support coordinates, you must provide a valid place name or a postal code");
                break;
                
            case AFWeatherAPIWeatherUnderground:
                NSLog(@"AFWeather message: Weather Underground does not support coordinates, you must provide a valid place name or a postal code");
                break;
                
            case AFWeatherAPIForecast:
                request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_baseURL stringByAppendingString:[NSString stringWithFormat:@"/%@,%@?units=auto",[[lat stringByReplacingOccurrencesOfString:@"," withString:@"."] encodeForURLWithEncoding:NSUTF8StringEncoding],[[lon stringByReplacingOccurrencesOfString:@"," withString:@"."] encodeForURLWithEncoding:NSUTF8StringEncoding]]]]];
                break;
                
            case AFWeatherAPITest:
                request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_baseURL stringByAppendingString:[NSString stringWithFormat:@"?lat=%@&lon=%@",[[lat stringByReplacingOccurrencesOfString:@"," withString:@"."] encodeForURLWithEncoding:NSUTF8StringEncoding],[[lon stringByReplacingOccurrencesOfString:@"," withString:@"."] encodeForURLWithEncoding:NSUTF8StringEncoding]]]]];
                break;
                
            default:
                break;
        }
    }
    
    return request;
}

@end

@implementation NSString (AFURLEncoding)

-(NSString *)encodeForURLWithEncoding:(NSStringEncoding)encoding {
    
    NSString *fixedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(encoding)));
    
    return fixedString;
}

@end
