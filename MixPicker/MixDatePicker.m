//
//  MixDatePicker.m
//  RSB
//
//  Created by Eric Lung on 2017/5/27.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

#import "MixDatePicker.h"
#import <objc/runtime.h>

@interface MixDatePicker ()

@property (nonatomic, assign) NSInteger minYear;
@property (nonatomic, assign) NSInteger maxYear;

@property (nonatomic, assign) BOOL hasYear, hasMonth, hasDay;

@end

@implementation MixDatePicker
@synthesize date = _date;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        [formatter setDateFormat:@"yyyy"];
        NSInteger year = [[formatter stringFromDate:[NSDate date]] integerValue];
        [self setMinYear:1900 maxYear:year];
        
        _mode = -1;
        self.mode = MixDatePickerModeYearMonthDate;
    }
    return self;
}

- (void)setMode:(MixDatePickerMode)mode
{
    if (_mode == mode) return;
    _mode = mode;
    self.hasYear = YES;
    self.hasMonth = mode != MixDatePickerModeYear;
    self.hasDay = mode == MixDatePickerModeYearMonthDate;
    [self reloadData];
}

- (void)setMinYear:(NSInteger)minYear maxYear:(NSInteger)maxYear
{
    minYear = MAX(1900, minYear);
    maxYear = MAX(1900, maxYear);
    maxYear = MIN(3000, maxYear);
    if (minYear > maxYear) minYear = maxYear;
    if (self.minYear == minYear && self.maxYear == maxYear) return;
    self.minYear = minYear;
    self.maxYear = maxYear;
    [self reloadData];
}

- (NSArray *)years
{
    NSMutableArray *years = [NSMutableArray new];
    for (NSInteger i = self.minYear; i <= self.maxYear; i++) {
        NSString *string = [NSString stringWithFormat:@"%ld年", (long)i];
        [years addObject:string];
    }
    return years;
}

- (NSArray *)months
{
    NSMutableArray *months = [NSMutableArray new];
    for (int i = 1; i <= 12; i++) {
        NSString *string = [NSString stringWithFormat:@"%@%d月", i < 10 ? @"0" : @"", i];
        [months addObject:string];
    }
    return months;
}

- (NSArray *)days
{
    NSMutableArray *days = [NSMutableArray new];
    for (int i = 1; i <= 31; i++) {
        NSString *string = [NSString stringWithFormat:@"%@%d日", i < 10 ? @"0" : @"", i];
        [days addObject:string];
    }
    return days;
}

- (void)reloadData
{
    switch (self.mode) {
        case MixDatePickerModeYearMonthDate: self.columnElements = @[[self years], [self months], [self days]];break;
        case MixDatePickerModeYearMonth: self.columnElements = @[[self years], [self months]];break;
        default: self.columnElements = @[[self years]];break;
    }
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"yyyy年-MM月-dd日"];
    NSArray *components = [[formatter stringFromDate:date] componentsSeparatedByString:@"-"];
    if (self.hasYear)  [self setElement:components[0] forColumn:0];
    if (self.hasMonth)  [self setElement:components[1] forColumn:1];
    if (self.hasDay)  [self setElement:components[2] forColumn:2];
}

- (NSDate *)date
{
    NSString *day = self.hasDay ? [self elementForColumn:2].text : @"01日";
    NSString *month = self.hasMonth ? [self elementForColumn:1].text : @"01月";
    NSString *year = self.hasYear ? [self elementForColumn:0].text : @"1900年";
    NSString *string = [NSString stringWithFormat:@"%@%@%@", year, month, day];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date = [formatter dateFromString:string];
    return date;
}

@end

@implementation MixDatePickerManager
@synthesize picker = _picker;

- (MixDatePicker *)picker
{
    if (!_picker) {
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.size.height = 220;
        _picker = [[MixDatePicker alloc] initWithFrame:frame];
    }
    return _picker;
}

@end

@implementation UIView (MixDatePicker)

- (MixDatePickerManager *)mixDatePickerManager
{
    MixDatePickerManager *manager = objc_getAssociatedObject(self, _cmd);
    if (!manager) {
        manager = [MixDatePickerManager new];
        manager.view = self;
        objc_setAssociatedObject(self, _cmd, manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return manager;
}

@end
