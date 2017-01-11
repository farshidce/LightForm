#import <UIKit/UIkit.h>

@protocol LightFormStyle;
@class LightFormCellData;


FOUNDATION_EXPORT const CGFloat kTextFieldLeftMargin;
FOUNDATION_EXPORT const CGFloat kTextFieldRightMargin;
FOUNDATION_EXPORT const CGFloat kTextFieldTopMargin;
FOUNDATION_EXPORT const CGFloat kTextFieldBottomMargin;
FOUNDATION_EXPORT const CGFloat kTextFieldHeight;
FOUNDATION_EXPORT const CGFloat kErrorLabelLeftMargin;
FOUNDATION_EXPORT const CGFloat kErrorLabelRightMargin;
FOUNDATION_EXPORT const CGFloat kErrorLabelMinHeight;
FOUNDATION_EXPORT const CGFloat kAccessoryImageWidth;
FOUNDATION_EXPORT const CGFloat kAccessoryImageRightMargin;
FOUNDATION_EXPORT const CGFloat kAccessoryImageHeight;
FOUNDATION_EXPORT const CGFloat kAccessoryImageTopMargin;


@interface LightFormCell : UITableViewCell <UITextFieldDelegate>

@property(nonatomic, retain) id <LightFormStyle> style;
@property(nonatomic, setter=setCellData:) LightFormCellData *data;

/**
 * this method is used to display the data ( text and validation messages) in the cell.
 * @param data
 */

- (void)setCellData:(LightFormCellData *)data;

/*
 * This method is invoked upon user interaction with the cell.
 *  focused = true when cell is the first responder and user is editing the text
 *  returned = true when return or next button on the keyboard is pressed
 *  goToNext = true when user hits the Next button on the keyboard
 *  input = the text user entered
 *  error = true if the cell has any validations
 *
 */
- (void)executeBlock:(void (^)(LightFormCellData *data, BOOL focused, NSString *input, BOOL returned, BOOL goToNext))onStateChange;

// class methods
+ (CGFloat)cellHeightForData:(LightFormCellData *)data withStyle:(id <LightFormStyle>)style;
@end
