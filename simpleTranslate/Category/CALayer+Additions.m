//
//  CALayer+Additions.m
//  simpleTranslate
//
//  Created by Aleksey Anisimov on 26.02.17.
//  Copyright © 2017 vkrotin. All rights reserved.
//

#import "CALayer+Additions.h"

@implementation CALayer (Additions)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}


-(UIColor *)shadowUIColor {
    return [UIColor colorWithCGColor:self.shadowColor];
}

-(void)setShadowUIColor:(UIColor *)shadowUIColor {
    self.shadowColor = shadowUIColor.CGColor;
}


@end
