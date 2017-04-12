//
//  EIRadioButton.m
//  EInsure
//
//  Created by ivan on 13-7-9.
//  Copyright (c) 2013年 ivan. All rights reserved.
//

#import "QRadioButton.h"

#define Q_RADIO_ICON_WH                     (16.0)
#define Q_ICON_TITLE_MARGIN                 (5.0)


static NSMutableDictionary *_groupRadioDic = nil;

@implementation QRadioButton

@synthesize delegate = _delegate;
@synthesize checked  = _checked;

- (id)initWithDelegate:(id)delegate groupId:(NSString*)groupId {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _groupId = [groupId copy];
        
        [self addToGroup];
        
        self.exclusiveTouch = YES;
        
        [self setImage:[UIImage imageNamed:@"icon_unfocus"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"icon_focus"] forState:UIControlStateSelected];
        [self addTarget:self action:@selector(radioBtnChecked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)addToGroup {
    if(!_groupRadioDic){
        _groupRadioDic = [NSMutableDictionary dictionary];
    }
    
    NSMutableArray *_gRadios = [_groupRadioDic objectForKey:_groupId];
    if (!_gRadios) {
        _gRadios = [NSMutableArray array];
    }
    [_gRadios addObject:self];
    [_groupRadioDic setObject:_gRadios forKey:_groupId];
}

- (void)removeFromGroup {
    if (_groupRadioDic) {
        NSMutableArray *_gRadios = [_groupRadioDic objectForKey:_groupId];
        if (_gRadios) {
            [_gRadios removeObject:self];
            if (_gRadios.count == 0) {
                [_groupRadioDic removeObjectForKey:_groupId];
            }
        }
    }
}

//返回前一个checked
- (QRadioButton *)uncheckOtherRadios {
    NSMutableArray *_gRadios = [_groupRadioDic objectForKey:_groupId];
    QRadioButton *prevChecked = nil;
    if (_gRadios.count > 0) {
        for (QRadioButton *_radio in _gRadios) {
            if (_radio.checked && ![_radio isEqual:self]) {
                _radio.checked = NO;
                prevChecked = _radio;
            }
        }
    }
    return prevChecked;
}

- (void)delegateWith:(QRadioButton *)prevRadio {
    if (self.selected && _delegate && [_delegate respondsToSelector:@selector(didSelectedRadioButton:prevChecked:groupId:)]) {
        [_delegate didSelectedRadioButton:self prevChecked:prevRadio groupId:_groupId];
    }
}

- (void)setChecked:(BOOL)checked {
    if (_checked == checked) {
        if (_checked) {
            [self delegateWith:self];
        }
        return;
    }
    
    _checked = checked;
    self.selected = checked;
    
    QRadioButton *prevChecked = nil;
    if (self.selected) {
       prevChecked = [self uncheckOtherRadios];
    }
    
    [self delegateWith:prevChecked];
}

- (void)radioBtnChecked {
    if (_checked) {
        [self delegateWith:self];
        return;
    }
    
    self.selected = !self.selected;
    _checked = self.selected;
    
    QRadioButton *prevChecked = nil;
    if (self.selected) {
        prevChecked = [self uncheckOtherRadios];
    }
    
    [self delegateWith:prevChecked];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, (CGRectGetHeight(contentRect) - Q_RADIO_ICON_WH)/2.0, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(Q_RADIO_ICON_WH + Q_ICON_TITLE_MARGIN, 0,
                      CGRectGetWidth(contentRect) - Q_RADIO_ICON_WH - Q_ICON_TITLE_MARGIN,
                      CGRectGetHeight(contentRect));
}

- (void)setGroupId:(NSString *)groupId
{
    _groupId = [groupId copy];
    
    [self addToGroup];
    
    self.exclusiveTouch = YES;
    
    [self setImage:[UIImage imageNamed:@"icon_unfocus"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"icon_focus"] forState:UIControlStateSelected];
    [self addTarget:self action:@selector(radioBtnChecked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc {
    [self removeFromGroup];
    
    _delegate = nil;
    _groupId = nil;
}


@end
