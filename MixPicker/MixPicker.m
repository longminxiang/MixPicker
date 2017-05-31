//
//  MixPicker.m
//  RSB
//
//  Created by Eric Lung on 2017/4/10.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

#import "MixPicker.h"
#import <objc/runtime.h>
#import "MixPickerToobar.h"

@implementation UIView (MixPickerXibView)

+ (instancetype)mix_picker_xibView
{
    NSString *className = NSStringFromClass(self);
    if (![[NSBundle mainBundle] pathForResource:className ofType:@"nib"]) return nil;
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil];
    for (id object in viewArray) {
        if ([object isKindOfClass:[self class]]) {
            return object;
        }
    }
    return nil;
}

@end

@interface MixPicker ()

@property (nonatomic, strong) NSArray<MixPickerComponent *> *components;

@end

@implementation MixPicker

- (void)setColumnElements:(NSArray<NSArray<id<MixPickerElement>> *> *)columnElements
{
    _columnElements = columnElements;
    [self.components makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray<MixPickerComponent *> *components = [NSMutableArray new];
    for (int i = 0; i < columnElements.count; i++) {
        NSArray<id<MixPickerElement>> *elements = columnElements[i];
        MixPickerComponent *component = [MixPickerComponent mix_picker_xibView];
        component.rightBorderView.hidden = i == columnElements.count - 1;
        [self addSubview:component];
        [components addObject:component];
        component.elements = elements;
        
        component.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSArray *csns = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]-|" options:0 metrics:nil views:@{@"view": component}];
        [self addConstraints:csns];
        
        NSString *format = i == 0 ?  @"H:|[view]" : @"H:[frontView][view]";
        NSDictionary *dict = i == 0 ? @{@"view": component} : @{@"frontView": components[i - 1], @"view": component};
        csns = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:dict];
        [self addConstraints:csns];
        
        if (i == columnElements.count - 1) {
            csns = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]|" options:0 metrics:nil views:@{@"view": component}];
            [self addConstraints:csns];
        }
        
        if (i != 0 ) {
            csns = [NSLayoutConstraint constraintsWithVisualFormat:@"[view(==frontView)]" options:0 metrics:nil views:@{@"view": component, @"frontView": components[i - 1]}];
            [self addConstraints:csns];
        }
    }
    self.components = components;
}

- (void)setElement:(id<MixPickerElement>)element forColumn:(NSInteger)columnIndex
{
    self.components[columnIndex].element = element;
}

- (id<MixPickerElement>)elementForColumn:(NSInteger)columnIndex
{
    return self.components[columnIndex].element;
}

@end

@interface MixPickerManager ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation MixPickerManager
@synthesize picker = _picker;

- (MixPicker *)picker
{
    if (!_picker) {
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.size.height = 220;
        _picker = [[MixPicker alloc] initWithFrame:frame];
    }
    return _picker;
}

- (UITextField *)textField
{
    if (!_textField) {
        
        UITextField *field = [UITextField new];
        [self.view addSubview:field];
        field.inputView = self.picker;
        
        MixPickerToobar *toobar = [MixPickerToobar mix_picker_xibView];
        [toobar.cancelButton addTarget:self action:@selector(cancelButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [toobar.doneButton addTarget:self action:@selector(doneButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        field.inputAccessoryView = toobar;
        _textField = field;
        
        CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAfterWaiting, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity _) {
            BOOL isFirstResponder = _textField.isFirstResponder;
            self.show = isFirstResponder;
        });
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    }
    return _textField;
}

- (void)setShow:(BOOL)show
{
    if (_show == show) return;
    _show = show;
    
    if (show) {
        if (!self.textField.isFirstResponder) [self.textField becomeFirstResponder];
    }
    else {
        if (self.textField.isFirstResponder) [self.textField resignFirstResponder];
    }
}

- (void)doneButtonTouched:(UIButton *)button
{
    self.show = NO;
    if (self.doneBlock) self.doneBlock(self.picker);
}

- (void)cancelButtonTouched:(UIButton *)button
{
    self.show = NO;
}

@end

@implementation UIView (MixPicker)

- (MixPickerManager *)mixPickerManager
{
    MixPickerManager *manager = objc_getAssociatedObject(self, _cmd);
    if (!manager) {
        manager = [MixPickerManager new];
        manager.view = self;
        objc_setAssociatedObject(self, _cmd, manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return manager;
}

@end
