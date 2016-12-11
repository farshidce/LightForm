#import <UIKit/UIkit.h>

@protocol LightFormStyle;
@class LightFormCellData;


@interface LightFormCell : UITableViewCell <UITextFieldDelegate>

@property(nonatomic, retain) id <LightFormStyle> style;
@property(nonatomic, setter=setCellData:) LightFormCellData *data;

- (void)setCellData:(LightFormCellData *)data;

- (void)executeBlock:(void (^)(BOOL focused, NSString *input, BOOL error, BOOL returned, BOOL goToNext))onStateChange;

// class methods
+ (CGFloat)cellHeightForData:(LightFormCellData *)data withStyle:(id <LightFormStyle>)style;
@end
