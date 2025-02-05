//
//  JPExport.m
//
//
//  Created by Jinxiansen on 2017/11/30.
//  Copyright © 2017年 Jinxiansen. All rights reserved.
//

#import "JPExport.h"

@implementation JPExport

+ (NSString *)exportFromDictionary:(NSDictionary *)dictionary {
    return [self exportFromDictionary:dictionary removeUnderLine:NO];
}

+ (NSString *)exportFromDictionary:(NSDictionary *)dictionary
                           removeUnderLine:(BOOL)isRemove {
    
    NSMutableString * mutableString = [NSMutableString string];
    [mutableString appendString:[self parseDictionary:dictionary removeUnderLine:isRemove]];
    NSLog(@"%@",mutableString);
    
    return mutableString;
}

+ (NSString *)parseDictionary:(NSDictionary *)dictionary
              removeUnderLine:(BOOL)isRemove {
    
    NSMutableString * mutableString = [NSMutableString string];
    NSString * title = [NSString stringWithFormat:@"\n\n/*** %lu个 property ✍️✍️ ***/\n\n",[[dictionary allKeys] count]];
    [mutableString appendString:title];
    
    NSMutableString * dictString = [NSMutableString string];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString * string = nil;
        id newKey = isRemove ? [self uppercaseStringFromKey:key] : key;
        
        NSString * className = NSStringFromClass([obj class]);
        if ([className containsString:@"String"]) {
            string = [NSString stringWithFormat:@"/** <#%@#> */\n@property (nonatomic, copy) NSString *%@;",newKey,newKey];
        } else if ([className containsString:@"Array"]) {
            string = [NSString stringWithFormat:@"/** <#%@#> */\n@property (nonatomic, strong) NSArray *%@;",newKey,newKey];
            [dictString appendString:[self parseArrayWithObj:obj isRemove:isRemove]];
        }else if ([className containsString:@"Number"]) {
            string = [NSString stringWithFormat:@"/** <#%@#> */\n@property (nonatomic, strong) NSNumber *%@;",newKey,newKey];
        }else if ([className containsString:@"Dictionary"]) {
            [dictString appendString:[self parseDictionary:obj removeUnderLine:isRemove]];
            string = [NSString stringWithFormat:@"/** <#%@#> */\n@property (nonatomic, strong) NSDictionary *%@;",newKey,newKey];
        }else if ([className containsString:@"Boolean"]) {
            string = [NSString stringWithFormat:@"/** <#%@#> */\n@property (nonatomic, assign) BOOL %@;",newKey,newKey];
        }else {
            NSLog(@" 未识别的key : %@ \n",newKey);
        }
        [mutableString appendFormat:@"%@\n",string];
    }];
    [mutableString appendString:dictString];
    
    return mutableString;
}

+ (id)uppercaseStringFromKey:(id)key {
    
    if (![key isKindOfClass:[NSString class]]) {
        return key;
    }
    
    NSString * tempKey = key;
    NSString * first = [[tempKey substringToIndex:1] lowercaseString];
    NSString * newKey = [tempKey stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:first];
    
    if ([newKey containsString:@"_"]) {
        NSString * newKeyString = (NSString *)newKey;
        NSRange range = [newKeyString rangeOfString:@"_"];
        if (newKeyString.length >= (range.location + range.length)) {
            NSString * letter = [newKeyString substringWithRange:NSMakeRange(range.location + 1, range.length)];
            NSString * result = [newKeyString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"_%@",letter] withString:[letter uppercaseString]];
            newKey = result;
        }
    }
    return newKey;
}


+ (NSString *)parseArrayWithObj:(id)obj isRemove:(BOOL)isRemove {
    
    if (![obj isKindOfClass:[NSArray class]]) {
        return @"";
    }
    
    if ([NSStringFromClass([[obj firstObject]class]) containsString:@"Dictionary"]) {
        
        NSDictionary * firstDict = [obj firstObject];
        NSMutableString * arrayString = [NSMutableString string];
        if ([obj count] > 1) {
            NSDictionary * lastDict = [obj lastObject];
            NSSet * firstSet = [NSSet setWithArray:[firstDict allKeys]];
            NSSet * lastSet = [NSSet setWithArray:[lastDict allKeys]];
            
            if ([firstSet isEqualToSet:lastSet]) {
                [arrayString appendString:[self parseDictionary:firstDict removeUnderLine:isRemove]];
            } else {
                for (NSDictionary * dict in obj) {
                    [arrayString appendString:[self parseDictionary:dict removeUnderLine:isRemove]];
                }
            }
        }else {
            [arrayString appendString:[self parseDictionary:firstDict removeUnderLine:isRemove]];
        }
        
        return arrayString;
    }
    return @"";
}





@end
