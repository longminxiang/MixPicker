//
//  MixPicker.h
//  RSB
//
//  Created by Eric Lung on 2017/4/10.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixPickerComponent.h"

@interface MixPicker : UIView

@property (nonatomic, strong) NSArray<NSArray<id<MixPickerElement>> *> * _Nullable columnElements;

- (_Nullable id<MixPickerElement>)elementForColumn:(NSInteger)columnIndex;

- (void)setElement:(_Nullable id<MixPickerElement>)element forColumn:(NSInteger)columnIndex;

@end

@interface MixPickerManager : NSObject

@property (nonatomic, readonly, nonnull) MixPicker *picker;

@property (nonatomic, weak, nullable) UIView *view;

@property (nonatomic, copy, nullable) void (^doneBlock)(__kindof MixPicker * _Nonnull picker);

@property (nonatomic, assign) BOOL show;

@end

@interface UIView (MixPicker)

@property (nonatomic, readonly, nonnull) MixPickerManager *mixPickerManager;

@end
