//
// Created by Farshid Ghods on 12/6/16.
// Copyright (c) 2016 Farshid Ghods. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LightFormCellData : NSObject <NSCopying>

/*
 * placeholder string to display in the textField
 */
@property(nonatomic, retain) NSString *placeholder;
/*
 * the value that the user entered
 */
@property(nonatomic, retain) NSString *value;
/*
 * list of validations or messages that should be displayed to the user
 */
@property(nonatomic, retain) NSArray *validations;
/*
 * whether the keyboard should should "Next" button or "Go"
 * while returning from the cell associated with this data
 */
@property(nonatomic) BOOL hasNext;
/*
 * whether the cell textField should mask the input characters
 */
@property(nonatomic) BOOL secureEntry;
/*
 * the image that will be displayed on the right side
 * @optional
 */
@property(nonatomic, retain) NSString *accessoryImageUrl;

+ (LightFormCellData *)fromDictionary:(NSDictionary *)dictionary;

@end