//
//  MixPickerComponent.m
//  RSB
//
//  Created by Eric Lung on 2017/5/27.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

#import "MixPickerComponent.h"
#import "MixPickerCell.h"

@interface MixPickerComponent ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation NSString (MixPicker)

- (NSString *)text
{
    return self;
}

@end

@implementation MixPickerComponent

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nib = [UINib nibWithNibName:_mixPickerCellID bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:_mixPickerCellID];
    
    self.tableView.tableHeaderView = [self headerFooterView];
    self.tableView.tableFooterView = [self headerFooterView];
    
    self.rightBorderView.hidden = YES;
}

- (void)setElements:(NSArray<id<MixPickerElement>> *)elements
{
    _elements = elements;
    [self.tableView reloadData];
}

- (void)setElement:(id<MixPickerElement>)element
{
    _element = element;
    
    self.currentIndex = [self getIndexPath:element];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self tableView:self.tableView scrollToCurrentIndexWitnAnimated:YES];
    });
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (_currentIndex == currentIndex) return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
    MixPickerCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.isCurrent = NO;
    
    _currentIndex = currentIndex;
    
    indexPath = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.isCurrent = YES;
    
    if (currentIndex >= 0 && currentIndex < self.elements.count) {
        _element = self.elements[currentIndex];
    }
}

- (NSInteger)getIndexPath:(id<MixPickerElement>)element
{
    if (!self.elements.count) return -1;
    for (NSInteger i = 0; i < self.elements.count; i++) {
        if ([element.text isEqualToString:self.elements[i].text]) {
            return i;
        }
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView scrollToCurrentIndexWitnAnimated:(BOOL)animated
{
    if (self.currentIndex >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
        @try {
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
        } @catch (NSException *exception) {
            NSLog(@"===%@===", exception);
        }
    }
}

#pragma mark
#pragma mark === tableView ===

- (UIView *)headerFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 44 * 2)];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.elements.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MixPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:_mixPickerCellID];
    NSInteger row = indexPath.row;
    cell.textLabel.text = self.elements[row].text;
    cell.isCurrent = self.currentIndex == indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)scrollViewDidScroll:(UITableView *)tableView
{
    CGPoint contentOffset = tableView.contentOffset;
    contentOffset.y += 44 * 2 + 22;
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:contentOffset];
    NSInteger index = indexPath.row;
    if (!indexPath && contentOffset.y > 0) {
        index = [self tableView:tableView numberOfRowsInSection:0] - 1;
    }
    self.currentIndex = index;
}

- (void)scrollViewDidEndDragging:(UITableView *)tableView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self tableView:tableView scrollToCurrentIndexWitnAnimated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UITableView *)tableView
{
    [self tableView:tableView scrollToCurrentIndexWitnAnimated:YES];
}

@end


