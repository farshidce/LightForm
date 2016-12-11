//
// Created by Farshid Ghods on 12/6/16.
// Copyright (c) 2016 Farshid Ghods. All rights reserved.
//

#import "LightFormStyle.h"


@implementation LightFormInternalStyles

+ (UIColor *)borderColor {
    return UIColorFromRGB(0x999999, 1.0);
}

+ (UIColor *)selectedBorderColor {
    return nil;
}

+ (NSUInteger)borderWidth {
    return 5;
}

+ (NSUInteger)selectedBorderWidth {
    return 5;
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
    return [UIFont fontWithName:@"Helvetica-Light" size:12.0];
}

+ (UIColor *)titleColor {
    return UIColorFromRGB(0x999999, 1.0);
}

+ (UIFont *)titleFont {
    return [UIFont fontWithName:@"Helvetica-Light" size:18.0];
}


+ (UIColor *)placeholderColor {
    return UIColorFromRGB(0x10D0A0, 1.0);
}

+ (UIFont *)placeholderFont {
    return [UIFont fontWithName:@"Helvetica-Light" size:18.0];
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
        self.selectedBorderColor = [LightFormInternalStyles borderColor];
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
    }
    return self;
}

@end