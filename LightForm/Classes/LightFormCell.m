#import "LightForm.h"


CGFloat const kTextFieldLeftMargin = 15.0;
CGFloat const kTextFieldRightMargin = 15.0;
CGFloat const kTextFieldTopMargin = 10.0;
CGFloat const kTextFieldBottomMargin = 5.0;
CGFloat const kTextFieldHeight = 25.0;
CGFloat const kErrorLabelMinHeight = 0.0;
CGFloat const kAccessoryImageRightMargin = 25.0;
CGFloat const kErrorLabelLeftMargin = 15.0;
CGFloat const kErrorLabelRightMargin = 15.0;
CGFloat const kAccessoryImageWidth = 20.0;
CGFloat const kAccessoryImageHeight = 20.0;
CGFloat const kAccessoryImageTopMargin = 20.0;

@implementation LightFormCell {
    void (^executeOnStateChange)(LightFormCellData *data, BOOL focused, NSString *input, BOOL returned, BOOL goToNext);

    UITextField *_inputTextField;
    UIView *_containerView;
    UILabel *_validationsLabel;
    UIImageView *_accessoryImage;
    LightFormCellData *_data;
    BOOL isTextFieldSelected;
    BOOL validationsVisible;
    BOOL placeholderVisible;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    return [self initWithStyle:style
               reuseIdentifier:reuseIdentifier
                     formStyle:[[LightFormDefaultStyle alloc] init]];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                    formStyle:(id <LightFormStyle>)formStyle {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.style = formStyle;
        isTextFieldSelected = NO;
        validationsVisible = NO;
        placeholderVisible = YES;
        [self initCellStyle];
        _accessoryImage = [self createAccessoryImageView];
        _validationsLabel = [self createErrorLabel];
        _inputTextField = [self createInputTextField];
        _containerView = [self createContainerViewWith:_inputTextField
                                      validationsLabel:_validationsLabel
                                    accessoryImageView:_accessoryImage];
        [_containerView addConstraints:[self constraintsForTextField]];
        [_containerView addConstraints:[self constraintsForErrorLabel]];
        [_containerView addConstraints:[self constraintsForAccessoryImage]];

        [self.contentView addSubview:_containerView];
        [self.contentView addConstraints:[self constraintsForContainerView]];
    }
    // setting the constraint
    return self;
}

- (void)initCellStyle {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (UITextField *)createInputTextField {
    UITextField *inputTextField = [[UITextField alloc] init];
    inputTextField.userInteractionEnabled = YES;
    inputTextField.textAlignment = NSTextAlignmentLeft;
    inputTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [inputTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    inputTextField.delegate = self;
    return inputTextField;
}

- (UILabel *)createErrorLabel {
    UILabel *validationsLabel = [[UILabel alloc] init];
    validationsLabel.textAlignment = NSTextAlignmentLeft;
    [validationsLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    validationsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    validationsLabel.numberOfLines = 0;
    return validationsLabel;
}

- (UIImageView *)createAccessoryImageView {
    UIImageView *accessoryImage = [[UIImageView alloc] init];
    [accessoryImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [accessoryImage clipsToBounds];
    accessoryImage.contentMode = UIViewContentModeCenter;
    return accessoryImage;

}


- (UIView *)createContainerViewWith:(UITextField *)inputTextField
                   validationsLabel:(UILabel *)validationsLabel
                 accessoryImageView:(UIImageView *)accessoryImageView {
    UIView *containerView = [[UIView alloc] init];
    [containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [containerView addSubview:inputTextField];
    [containerView addSubview:validationsLabel];
    [containerView addSubview:accessoryImageView];
    return containerView;
}


- (NSArray<NSLayoutConstraint *> *)constraintsForContainerView {
    NSString *hFormat = [NSString stringWithFormat:@"H:|-%f-[containerView]-%f-|",
                                                   self.style.contentInsets.left, self.style.contentInsets.right];
    NSArray<NSLayoutConstraint *> *horizontal = [NSLayoutConstraint
            constraintsWithVisualFormat:hFormat
                                options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil
                                  views:@{@"containerView": _containerView}];
    NSString *vFormat = [NSString stringWithFormat:@"V:|-%f-[containerView]-%f-|",
                                                   self.style.contentInsets.top, self.style.contentInsets.bottom];
    NSArray<NSLayoutConstraint *> *vertical = [NSLayoutConstraint
            constraintsWithVisualFormat:vFormat
                                options:NSLayoutFormatDirectionLeadingToTrailing
                                metrics:nil
                                  views:@{@"containerView": _containerView}];
    return [vertical arrayByAddingObjectsFromArray:horizontal];
}

- (NSArray<NSLayoutConstraint *> *)constraintsForTextField {
    NSString *vFormat = [NSString stringWithFormat:
            @"V:|-%f-[inputTextField(%f)]-%f-[validationsLabel(>=%f)]|",
            kTextFieldTopMargin, kTextFieldHeight, kTextFieldBottomMargin, kErrorLabelMinHeight];
    NSArray<NSLayoutConstraint *> *vertical = [NSLayoutConstraint

            constraintsWithVisualFormat:vFormat
                                options:NSLayoutFormatDirectionLeadingToTrailing
                                metrics:nil
                                  views:@{@"inputTextField": _inputTextField,
                                          @"validationsLabel": _validationsLabel}];
    NSString *hFormat = [NSString stringWithFormat:
            @"H:|-%f-[inputTextField]-%f-[accessoryImage]-%f-|",
            kTextFieldLeftMargin, kTextFieldRightMargin, kAccessoryImageRightMargin];
    NSArray<NSLayoutConstraint *> *horizontal = [NSLayoutConstraint
            constraintsWithVisualFormat:hFormat
                                options:NSLayoutFormatDirectionLeadingToTrailing
                                metrics:nil
                                  views:@{@"inputTextField": _inputTextField,
                                          @"accessoryImage": _accessoryImage}];
    return [vertical arrayByAddingObjectsFromArray:horizontal];
}

- (NSArray<NSLayoutConstraint *> *)constraintsForErrorLabel {
    NSString *hFormat = [NSString stringWithFormat:@"H:|-%f-[validationsLabel]-%f-[accessoryImage(%f)]-|",
                                                   kErrorLabelLeftMargin, kErrorLabelRightMargin, kAccessoryImageWidth];
    NSArray<NSLayoutConstraint *> *horizontal = [NSLayoutConstraint
            constraintsWithVisualFormat:hFormat
                                options:NSLayoutFormatDirectionLeadingToTrailing
                                metrics:nil
                                  views:@{@"validationsLabel": _validationsLabel,
                                          @"accessoryImage": _accessoryImage}];
    return horizontal;

}

- (NSArray<NSLayoutConstraint *> *)constraintsForAccessoryImage {
    NSArray<NSLayoutConstraint *> *vertical = [NSLayoutConstraint
            constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[accessoryImage(%f)]",
                                                                   kAccessoryImageTopMargin, kAccessoryImageHeight]
                                options:NSLayoutFormatDirectionLeadingToTrailing
                                metrics:nil
                                  views:@{@"accessoryImage": _accessoryImage}];
    return vertical;
}


- (void)executeBlock:(void (^)(LightFormCellData *data, BOOL focused, NSString *input, BOOL returned, BOOL goToNext))onStateChange {
    executeOnStateChange = onStateChange;
}

/**
 * sets the cell data
 * view
 * @param data
 */
- (void)setCellData:(LightFormCellData *)data {
    _data = data;
    if (_data) {
        validationsVisible = _data.validations && [_data.validations count] > 0;
    }
    [self refreshView];
}

- (void)refreshView {
    if (self.style) {
        if (placeholderVisible) {
            if (_data && _data.placeholder) {
                if (_style) {
                    NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];
                    if (_style.placeholderColor) {
                        mutableDictionary[NSForegroundColorAttributeName] = _style.placeholderColor;
                    }
                    if (_style.placeholderFont) {
                        mutableDictionary[NSFontAttributeName] = _style.placeholderFont;
                    }
                    if ([mutableDictionary count] > 0) {
                        _inputTextField.placeholder = nil;
                        _inputTextField.attributedPlaceholder = [[NSAttributedString alloc]
                                initWithString:_data.placeholder
                                    attributes:[NSDictionary dictionaryWithDictionary:mutableDictionary]];
                    } else {
                        _inputTextField.attributedPlaceholder = nil;
                        _inputTextField.placeholder = _data.placeholder;
                    }
                } else {
                    _inputTextField.attributedPlaceholder = nil;
                    _inputTextField.placeholder = _data.placeholder;
                }
            }
        } else {
            _inputTextField.placeholder = nil;
            _inputTextField.attributedPlaceholder = nil;
        }
        if (isTextFieldSelected) {

            if (_style.selectedBorderColor) {
                _containerView.layer.borderColor = _style.selectedBorderColor.CGColor;
            }
            if (_style.selectedBorderWidth) {
                _containerView.layer.borderWidth = _style.selectedBorderWidth;
            }
            _containerView.layer.cornerRadius = 5.0;

        } else {

            if (_style.borderColor) {
                _containerView.layer.borderColor = _style.borderColor.CGColor;
            }
            if (_style.borderWidth) {
                _containerView.layer.borderWidth = _style.borderWidth;
            }
            _containerView.layer.cornerRadius = 5.0;

        }
        if (validationsVisible) {
            NSMutableDictionary *defaultAttributes = [NSMutableDictionary new];
            if (_style.validationFont) {
                defaultAttributes[NSFontAttributeName] = _style.validationFont;
            }
            if (_style.validationColor) {
                defaultAttributes[NSForegroundColorAttributeName] = _style.validationColor;
            }
            NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];
            mutableDictionary[NSForegroundColorAttributeName] = _style.titleColor;
            __block NSUInteger numberOfLines = 0;
            mutableDictionary[NSFontAttributeName] = _style.placeholderFont;
            if (_data.validations && [_data.validations count] > 0) {
                NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] init];
                [_data.validations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([obj isKindOfClass:[NSString class]]) {
                        NSString *line = nil;
                        if (idx < _data.validations.count - 1) {
                            line = [NSString stringWithFormat:@"%@\n", obj];
                        } else {
                            line = [NSString stringWithFormat:@"%@", obj];
                        }
                        [mutableAttributedString appendAttributedString:[[NSAttributedString alloc]
                                initWithString:line
                                    attributes:[NSDictionary dictionaryWithDictionary:defaultAttributes]]];
                    } else if ([obj isKindOfClass:[NSAttributedString class]]) {
                        [mutableAttributedString appendAttributedString:obj];
                        if (idx < _data.validations.count - 1) {
                            [mutableAttributedString appendAttributedString:[[NSAttributedString alloc]
                                    initWithString:@"\n" attributes:nil]];
                        }
                    }
                    numberOfLines++;
                }];
                _validationsLabel.text = nil;
                _validationsLabel.attributedText = mutableAttributedString;
                [_validationsLabel sizeToFit];
                [_containerView sizeToFit];
            }
        } else {
            _validationsLabel.attributedText = nil;
            _validationsLabel.text = nil;
            [_validationsLabel sizeToFit];
            [_containerView sizeToFit];
        }
        if (_data.accessoryImageUrl) {
            _accessoryImage.image = [UIImage imageNamed:_data.accessoryImageUrl];
        } else {
            _accessoryImage.image = nil;
        }
    } else {
        _validationsLabel.attributedText = nil;
        _validationsLabel.text = nil;
        _inputTextField.text = nil;
        _inputTextField.attributedPlaceholder = nil;
        _accessoryImage.image = nil;
    }
    _inputTextField.secureTextEntry = _data && _data.secureEntry;
}



// UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_data && _data.hasNext) {
        textField.returnKeyType = UIReturnKeyNext;
    } else {
        textField.returnKeyType = UIReturnKeyGo;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    placeholderVisible = NO;
    isTextFieldSelected = YES;
    if (executeOnStateChange) {
        executeOnStateChange(_data, isTextFieldSelected, _inputTextField.text, NO, NO);
    }
    [self refreshView];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!textField.attributedText.string || [textField.attributedText.string length] < 1) {
        placeholderVisible = YES;
    }
    isTextFieldSelected = NO;
    [self refreshView];
}

/**
 * The textField is not being edited anymore. this function notifies the delegate that
 *  the textField is out of focus (isTextFieldSelected=NO)
 *  and the control can transfer to the next textField ( goToNext=YES)
 *  and keyboard has not returned yet. (returned=NO)
 * @param textField
 * @param reason
 */
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0) {
    if (!textField.attributedText.string || [textField.attributedText.string length] < 1) {
        placeholderVisible = YES;
    }
    isTextFieldSelected = NO;
    if (executeOnStateChange) {
        executeOnStateChange(_data, isTextFieldSelected, textField.text, YES, NO);
    }
    [self refreshView];
}

/*
 * The textField is being edited. The delegate needs to be notified that
 * isTextFieldSelected=YES
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *replacementText = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];
    mutableDictionary[NSForegroundColorAttributeName] = _style.titleColor;
    mutableDictionary[NSFontAttributeName] = _style.placeholderFont;
    _inputTextField.attributedText = [[NSAttributedString alloc]
            initWithString:replacementText
                attributes:[NSDictionary dictionaryWithDictionary:mutableDictionary]];
    if (executeOnStateChange) {
        executeOnStateChange(_data, isTextFieldSelected, replacementText, NO, NO);
    }
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    isTextFieldSelected = NO;
    [self refreshView];
    if (executeOnStateChange) {
        executeOnStateChange(_data, isTextFieldSelected, textField.text, NO, YES);
    }
    [textField resignFirstResponder];
    return YES;
}

/*
 * reset the validationsLabel size and content
 */
- (void)prepareForReuse {
    [super prepareForReuse];
    _validationsLabel.text = nil;
    _validationsLabel.attributedText = nil;
    _inputTextField.text = nil;
    _inputTextField.attributedText = nil;
    _inputTextField.attributedPlaceholder = nil;
    _inputTextField.placeholder = nil;
    _accessoryImage.image = nil;
}


/**
 * setting preferredMaxLayoutWidth since _validationsLabel height needs to be recalculated
 * by the auto layout engine in case validationsLabel is displaying an error
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    _validationsLabel.preferredMaxLayoutWidth = _validationsLabel.frame.size.width;
    [super layoutSubviews];
}


- (void)drawRect:(CGRect)rect {
    CGSize size = _validationsLabel.bounds.size;
    // tell the label to size itself based on the current width
    [_validationsLabel sizeToFit];
    if (!CGSizeEqualToSize(size, _validationsLabel.bounds.size)) {
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
    [super drawRect:rect];
}

/**
 * calculates the cell height based on the current text and validation messages that is being displayed
 * @param data
 * @param style
 * @return
 */
+ (CGFloat)cellHeightForData:(LightFormCellData *)data withStyle:(id <LightFormStyle>)style {
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize constraint = CGSizeMake([[UIScreen mainScreen] bounds].size.width, CGFLOAT_MAX);
    __block CGFloat height = 25.0f + kTextFieldHeight + kTextFieldTopMargin +
            style.contentInsets.top + style.contentInsets.bottom;
    NSMutableDictionary *defaultAttributes = [NSMutableDictionary new];
    if (style.validationFont) {
        defaultAttributes[NSFontAttributeName] = style.validationFont;
    }
    if (style.validationColor) {
        defaultAttributes[NSForegroundColorAttributeName] = style.validationColor;
    }

    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] init];
    if (data && data.validations) {
        [data.validations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                [mutableAttributedString appendAttributedString:[[NSAttributedString alloc]
                        initWithString:obj
                            attributes:[NSDictionary dictionaryWithDictionary:defaultAttributes]]];
                CGSize boundingBox = [obj
                        boundingRectWithSize:constraint
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:[NSDictionary dictionaryWithDictionary:defaultAttributes]
                                     context:context].size;
                height += boundingBox.height;
            } else if ([obj isKindOfClass:[NSAttributedString class]]) {
                NSString *text = ((NSAttributedString *) obj).string;
                NSDictionary *attributes = [((NSAttributedString *) obj) attributesAtIndex:0
                                                                     longestEffectiveRange:nil
                                                                                   inRange:NSMakeRange(0, text.length)];
                [mutableAttributedString appendAttributedString:obj];
                if (idx < data.validations.count - 1) {
                    [mutableAttributedString appendAttributedString:[[NSAttributedString alloc]
                            initWithString:@"\n" attributes:nil]];
                }
                CGSize boundingBox = [text
                        boundingRectWithSize:constraint
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:context].size;
                height += boundingBox.height;
            }
        }];
    }
    return height;
}

- (BOOL)becomeFirstResponder {
    [super becomeFirstResponder];
    [_inputTextField becomeFirstResponder];
    return YES;
}

@end
