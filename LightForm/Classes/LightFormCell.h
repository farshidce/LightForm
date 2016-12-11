#import <UIKit/UIkit.h>

@protocol LightFormStyle;
@class LightFormCellData;


@interface LightFormCell : UITableViewCell<UITextFieldDelegate>

@property(nonatomic, retain) id <LightFormStyle> style;
@property(nonatomic) LightFormCellData *data;
@end