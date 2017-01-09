#import <Foundation/Foundation.h>


@protocol LightFormStyle <NSObject>

@required

@property(nonatomic, retain) NSString *title;

@optional

/**
 * the cell border color
 */
@property(nonatomic, retain) UIColor *borderColor;

/*
 * the cell border color when it is selected
 */
@property(nonatomic, retain) UIColor *selectedBorderColor;

/*
 * the cell border width when it is not selected
 */
@property(nonatomic) NSUInteger borderWidth;

/*
 * the cell border width when it is selected
 */
@property(nonatomic) NSUInteger selectedBorderWidth;

/*
 * the border opacity when cell is not selected
 */
@property(nonatomic) float borderOpacity;

/*
 * the border opacity when cell is selected
 */
@property(nonatomic) float selectedBorderOpacity;

/*
 * the color used for displaying the validation messages
 */
@property(nonatomic, retain) UIColor *validationColor;

/*
 * the font used for displaying the validation messages
 */

@property(nonatomic, retain) UIFont *validationFont;

/*
 * the font used for formatting the text input by the user
 */
@property(nonatomic, retain) UIFont *titleFont;

/*
 * the text color for formatting the text input by the user
 */

@property(nonatomic, retain) UIColor *titleColor;

@property(nonatomic, retain) UIFont *placeholderFont;
@property(nonatomic, retain) UIColor *placeholderColor;
@property(nonatomic, retain) UIImage *accessoryImage;
@property(nonatomic) UIKeyboardType keyboardType;
@property(nonatomic) UITextAutocorrectionType autocorrectionType;
@property(nonatomic) UIReturnKeyType returnKeyType;
@property(nonatomic) UIEdgeInsets contentInsets;

@end

@interface LightFormInternalStyles : NSObject

+ (UIColor *)UIColorFromHex:(NSUInteger)rgbValue alpha:(float)alpha;

+ (UIColor *)borderColor;

+ (UIColor *)selectedBorderColor;

+ (NSUInteger)borderWidth;

+ (NSUInteger)selectedBorderWidth;

+ (float)borderOpacity;

+ (float)selectedBorderOpacity;

+ (UIColor *)validationColor;

+ (UIFont *)validationFont;

+ (UIColor *)titleColor;

+ (UIFont *)titleFont;

+ (UIColor *)placeholderColor;

+ (UIFont *)placeholderFont;

+ (UIKeyboardType)keyboardType;

+ (UITextAutocorrectionType)autocorrectionType;

+ (UIReturnKeyType)returnKeyType;

+ (UIEdgeInsets)contentInsets;


@end

@interface LightFormDefaultStyle : NSObject <LightFormStyle>

@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) UIColor *borderColor;
@property(nonatomic, retain) UIColor *selectedBorderColor;
@property(nonatomic) NSUInteger borderWidth;
@property(nonatomic) NSUInteger selectedBorderWidth;
@property(nonatomic) float borderOpacity;
@property(nonatomic) float selectedBorderOpacity;
@property(nonatomic, retain) UIColor *validationColor;
@property(nonatomic, retain) UIFont *validationFont;
@property(nonatomic, retain) UIFont *titleFont;
@property(nonatomic, retain) UIColor *titleColor;
@property(nonatomic, retain) UIFont *placeholderFont;
@property(nonatomic, retain) UIColor *placeholderColor;
@property(nonatomic, retain) UIImage *accessoryImage;
@property(nonatomic) UIKeyboardType keyboardType;
@property(nonatomic) UITextAutocorrectionType autocorrectionType;
@property(nonatomic) UIReturnKeyType returnKeyType;
@property(nonatomic) UIEdgeInsets contentInsets;


@end


