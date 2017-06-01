//
//  CustomViewFromXib.m
//  simpleTranslate
//
//  Created by Aleksey Anisimov on 01.06.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

#import "CustomViewFromXib.h"

@implementation CustomViewFromXib

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _customView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        _customView.frame = self.bounds;
        if(CGRectIsEmpty(frame)) {
            self.bounds = _customView.bounds;
        }
        [self addSubview:_customView];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        _customView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        _customView.frame = self.bounds;
        [self addSubview:_customView];
        
    }
    return self;
}


@end
