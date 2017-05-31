//
//  MixDatePicker.h
//  RSB
//
//  Created by Eric Lung on 2017/5/27.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

#import "MixPicker.h"

typedef NS_ENUM(NSInteger, MixDatePickerMode) {
    MixDatePickerModeYearMonthDate,
    MixDatePickerModeYearMonth,
    MixDatePickerModeYear,
};

@interface MixDatePicker : MixPicker

@property (nonatomic, assign) MixDatePickerMode mode;

@property (nonatomic, strong, nullable) NSDate *date;

/**
 设置年限

 @param minYear 最小
 @param maxYear 最大
 */
- (void)setMinYear:(NSInteger)minYear maxYear:(NSInteger)maxYear;

@end

@interface MixDatePickerManager : MixPickerManager

@property (nonatomic, readonly, nonnull) MixDatePicker *picker;

@property (nonatomic, assign) MixDatePickerMode mode;

@end

@interface UIView (MixDatePicker)

@property (nonatomic, readonly, nonnull) MixDatePickerManager *mixDatePickerManager;

@end
