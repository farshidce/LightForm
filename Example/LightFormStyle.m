//
// Created by Farshid Ghods on 12/6/16.
// Copyright (c) 2016 Farshid Ghods. All rights reserved.
//

#import "LightFormStyle.h"


@implementation LightFormInternalStyles


+ (UIColor *)UIColorFromHex:(NSUInteger)rgbValue alpha:(float)alpha {

    return [UIColor colorWithRed:(CGFloat) (((rgbValue & 0xFF0000) >> 16) / 255.0)
                           green:(CGFloat) (((rgbValue & 0x00FF00) >> 16) / 255.0)
                            blue:(CGFloat) (((rgbValue & 0x0000FF) >> 16) / 255.0)
                           alpha:alpha];
}

+ (UIColor *)borderColor {
    return [LightFormInternalStyles UIColorFromHex:0x333333 alpha:0.1];
}

+ (UIColor *)selectedBorderColor {
    return [LightFormInternalStyles UIColorFromHex:0x333333 alpha:0.8];
}

+ (NSUInteger)borderWidth {
    return 1;
}

+ (NSUInteger)selectedBorderWidth {
    return 1;
}

+ (float)borderOpacity {
    return 0.3;
}

+ (float)selectedBorderOpacity {
    return 1.0;
}

+ (UIColor *)errorColor {
    return [UIColor redColor];
}

+ (UIFont *)errorFont {
    return [UIFont fontWithName:@"TrebuchetMS" size:12.0];
}

+ (UIColor *)titleColor {
    return [LightFormInternalStyles UIColorFromHex:0x333333 alpha:1.0];
}

+ (UIFont *)titleFont {
    return [UIFont fontWithName:@"TrebuchetM" size:15.0];
}


+ (UIColor *)placeholderColor {
    return [UIColor colorWithRed:(CGFloat) (153.0 / 255.0) green:(CGFloat) (153.0 / 255.0) blue:(CGFloat) (153.0 / 255.0) alpha:1.0];
    //return [UIColor greenColor];
}

+ (UIFont *)placeholderFont {
    return [UIFont fontWithName:@"TrebuchetMS" size:15.0];
}

+ (UIKeyboardType)keyboardType {
    return UIKeyboardTypeDefault;
}

+ (UITextAutocorrectionType)autocorrectionType {
    return UITextAutocorrectionTypeNo;
}

+ (UIReturnKeyType)returnKeyType {
    return UIReturnKeyNext;
}


@end

@implementation LightFormDefaultStyle {

}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.borderColor = [LightFormInternalStyles borderColor];
        self.selectedBorderColor = [LightFormInternalStyles selectedBorderColor];
        self.borderWidth = [LightFormInternalStyles borderWidth];
        self.selectedBorderWidth = [LightFormInternalStyles selectedBorderWidth];
        self.borderOpacity = [LightFormInternalStyles borderOpacity];
        self.selectedBorderOpacity = [LightFormInternalStyles selectedBorderOpacity];
        self.titleColor = [LightFormInternalStyles titleColor];
        self.titleFont = [LightFormInternalStyles titleFont];
        self.errorColor = [LightFormInternalStyles errorColor];
        self.errorFont = [LightFormInternalStyles errorFont];
        self.placeholderFont = [LightFormInternalStyles placeholderFont];
        self.placeholderColor = [LightFormInternalStyles placeholderColor];
        self.keyboardType = [LightFormInternalStyles keyboardType];
        self.autocorrectionType = [LightFormInternalStyles autocorrectionType];
        self.returnKeyType = [LightFormInternalStyles returnKeyType];
        self.title = @"";
    }
    return self;
}

@end
