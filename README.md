# LightForm
[![CI Status](https://travis-ci.org/farshidce/LightForm.svg?style=flat)](https://travis-ci.org/farshidce/LightForm)
[![Version](https://img.shields.io/cocoapods/v/LightForm.svg?style=flat)](http://cocoapods.org/pods/LightForm)
[![License](https://img.shields.io/cocoapods/l/LightForm.svg?style=flat)](http://cocoapods.org/pods/LightForm)
[![Platform](https://img.shields.io/cocoapods/p/LightForm.svg?style=flat)](http://cocoapods.org/pods/LightForm)

## LightForm
Simple interactive and customizable library to handle form input and validations.


![demo](https://s3.amazonaws.com/farshid.ghods.github/lightform-1.gif)

A simple library which let the user create beautiful and interactive forms for
handling user inputs and validating the data as the user inputs. The library
notifies the caller if and when the user changes the input and let the caller
decide what is validated and what validation messages needs to be displayed.

While developing Log In and Sign Up pages I ran into many use cases where the rules for
username or password and it is common to provide feedback to the user as they type in value.
This library uses blocks to notify the user of any input changes and then let the user
update the validation string if needed.

### Features

- customize the font and color used for displaying the placeholder
- customize the font and color used for displaying the input text
- customize the image displayed on each cell
- the keyboard can display "Next" or "Go" based on the cell data.


While developing Log In and Sign Up pages I ran into many use cases where the rules for
username or password and it is common to provide feedback to the user as they type in value.


In the demo the caller validates the input username and password and as the user types it can provide feedback.
Since validation label is refreshed upon each user input the user can see immediate feedback.


## Usage

pod install

```bash
    pod install
```

import the library

```objectivec
#import "LightForm.h"
```

Register LightFormCell with an identifier. You can also use "Interface Builder" if you are designing the view
 controller using the storyboards.

```objectivec
[self.tableView registerClass:[LightFormCell class] forCellReuseIdentifier:@"SignUpFormCellId"];
```

Create form data. In this example we will create 
You can create the form data using "Dictionary" or by creating an instance of LightFormCellData.

```objectivec
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    LightFormCell *lightFormCell = (LightFormCell *) cell;
    lightFormCell.data = [LightFormCellData fromDictionary:
    @{@"key": @"username",
       @"placeholder": @"Username",
       @"hasNext": @(YES)}];
}
```

In order to validate the user input as it is being typed you can handle.
 
 
 ```objectivec
[cell executeBlock:^(LightFormCellData *data, BOOL focused, NSString *input, BOOL returned, BOOL goToNext) {
        BOOL updatedNeeded = NO;
       
        if (input) {
            // format the validation message as red
            data.validations = @[[[NSAttributedString alloc] 
            initWithString:@"x at least 8 characters" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}]];
            // or if you dont need to format the validation message
            data.validations = @[@"x at least 8 characters"];
        }
];

```

implement this method in order to specify the height for this cell



```objectivec
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

        return [LightFormCell cellHeightForData:form[(NSUInteger) indexPath.row]
                                      withStyle:[[LightFormDefaultStyle alloc] init]];

}
```

in  order to transfer the control to the next cell ( e.g when user selects next 
button the caller can decide which control should become the first responder next)

 ```objectivec
[cell executeBlock:^(LightFormCellData *data, BOOL focused, NSString *input, BOOL returned, BOOL goToNext) {
        if (goToNext) {
            UIResponder *nextResponder = [self.view viewWithTag:cell.tag + 1];
            [nextResponder becomeFirstResponder];
        }
}];

```

hide the input validation if the cell is not selected anymore

```objectivec
[cell executeBlock:^(LightFormCellData *data, BOOL focused, NSString *input, BOOL returned, BOOL goToNext) {
        if (returned) {
            data.validations = nil;
        }
];
```




## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

LightForm is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LightForm"
```


## Todo

1- add ability to show or hide the password
2- add ability to modify the placeholder or text font and color without having to refresh
    the cell
3- add a protocol that can be used to handle the input validation

## Author

Farshid Ghods, farshid.ghods@gmail.com

## License

LightForm is available under the MIT license. See the LICENSE file for more info.
