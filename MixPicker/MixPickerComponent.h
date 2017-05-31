//
//  MixPickerComponent.h
//  RSB
//
//  Created by Eric Lung on 2017/5/27.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MixPickerElement <NSObject>

@property (nonatomic, readonly) NSString *text;

@end

@interface NSString (MixPicker)<MixPickerElement>

@end

@interface MixPickerComponent : UIView

@property (nonatomic, copy) id<MixPickerElement> element;

@property (nonatomic, strong) NSArray<id<MixPickerElement>> *elements;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, weak) IBOutlet UIView *rightBorderView;

@end
