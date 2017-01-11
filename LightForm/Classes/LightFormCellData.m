//
// Created by Farshid Ghods on 12/6/16.
// Copyright (c) 2016 Farshid Ghods. All rights reserved.
//

#import "LightForm.h"


@implementation LightFormCellData {


}

///**
// * deep copy
// * @param zone
// * @return
// */
//- (id)copyWithZone:(NSZone *)zone {
//
//    LightFormCellData *copy = [[LightFormCellData alloc] init];
//    if (self.accessoryImageUrl) {
//        copy.accessoryImageUrl = [NSString stringWithString:self.accessoryImageUrl];
//    }
//    if (self.placeholder) {
//        copy.placeholder = [NSString stringWithString:self.placeholder];
//    }
//    if (self.value) {
//        copy.value = [NSString stringWithString:self.value];
//    }
//    if (self.validations) {
//        copy.validations = [NSArray arrayWithArray:self.validations];
//    }
//    copy.hasNext = self.hasNext;
//    copy.secureEntry = self.secureEntry;
//    return copy;
//}

/**
 * A convinient method to Create LightFromCellData object from the given dictionary
 * dictionary keys accepted include :
 *  - accessoryImageUrl
 *  - placeholder
 *  - value
 * @param dictionary
 * @return
 */
+ (LightFormCellData *)fromDictionary:(NSDictionary *)dictionary {
    LightFormCellData *obj = [[LightFormCellData alloc] init];
    if (dictionary) {
        if (dictionary[@"accessoryImageUrl"]) {
            obj.accessoryImageUrl = dictionary[@"accessoryImageUrl"];
        }
        if (dictionary[@"placeholder"]) {
            obj.placeholder = dictionary[@"placeholder"];
        }
        if (dictionary[@"value"]) {
            obj.value = dictionary[@"value"];
        }
        if (dictionary[@"key"]) {
            obj.key = dictionary[@"key"];
        }
        if (dictionary[@"validation"]) {
            obj.validations = @[dictionary[@"validation"]];
        }
        if (dictionary[@"validations"]) {
            obj.validations = dictionary[@"validations"];
        }
        if (dictionary[@"hasNext"]) {
            obj.hasNext = [dictionary[@"hasNext"] boolValue];
        } else {
            obj.hasNext = NO;
        }
        if (dictionary[@"secureEntry"]) {
            obj.secureEntry = [dictionary[@"secureEntry"] boolValue];
        } else {
            obj.secureEntry = NO;
        }
    }
    return obj;
}

@end
