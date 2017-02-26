//
//  NSMutableAttributedString+Translate.m
//  simpleTranslate
//
//  Created by Aleksey Anisimov on 26.02.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

#import "NSMutableAttributedString+Translate.h"

@implementation NSMutableAttributedString (Translate)


-(id)initWithText:(NSString *)text andTranslateArray:(NSArray *)trArray; {
    
   
    
    self = [[NSMutableAttributedString alloc] initWithString:@""];
    [self appendAttributedString:[self textString: [NSString stringWithFormat:@"%@\n", text]]];
    
    for (NSDictionary *blockDict in trArray){
        
        if ([blockDict isEqualToDictionary:trArray.firstObject]){
            [self appendAttributedString:[self textString:blockDict[@"text"]]];
            if (blockDict[@"ts"])
                [self appendAttributedString:[self transAttrString:blockDict[@"ts"]]];
        }
        
        [self trAtrString:blockDict[@"tr"]];
    }
    
    return self;
}

-(void) trAtrString:(NSArray *) trArray{
    int currentIndex = 0;
    for (NSDictionary *blockDict in trArray){
        currentIndex++;
        if ([blockDict isEqualToDictionary:trArray.firstObject]){
            [self appendAttributedString:[self posAttrString:blockDict[@"pos"]]];
        }
        [self appendAttributedString:[self numberAttrString:[NSString stringWithFormat:@"%i.", currentIndex]]];
        [self appendAttributedString:[self synAttrString:[self text:[[NSMutableString alloc] initWithString:blockDict[@"text"]] withSinonims:blockDict[@"syn"]]]];
        
        NSString *trSyn = [self bufferString:blockDict[@"mean"]];
        if (![trSyn isEqualToString:@""])
            [self appendAttributedString:[self trSynAttrString:trSyn]];
        
        for (NSDictionary *dictionary in blockDict[@"ex"]){
            [self appendAttributedString:[self exAttrString:dictionary[@"text"] trExAttrString:[self bufferString:dictionary[@"tr"]]]];
        }
    }
}

-(NSString *) bufferString:(NSArray *) trArray{
    NSMutableString *mutableSt = [NSMutableString new];
    for (NSDictionary *dictionary in trArray){
        NSString *appendSt = [NSString stringWithFormat:@", %@", dictionary[@"text"]];
        if ([dictionary isEqualToDictionary:trArray.firstObject])
            appendSt = dictionary[@"text"];
        [mutableSt appendString:appendSt];
    }
    return mutableSt;
}

-(NSString *) text:(NSMutableString *)text withSinonims:(NSArray *)sinArray{
    for (NSDictionary *dictionary in sinArray){
        [text appendString:[NSString stringWithFormat:@", %@", dictionary[@"text"]]];
    }
    return text;
}

-(NSAttributedString *) textString:(NSString *) text{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 8;
    NSDictionary *attrDict = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0], NSParagraphStyleAttributeName : style };
    [attrString addAttributes:attrDict range:NSMakeRange(0, [attrString length])];
    
    return attrString;
}

-(NSAttributedString *) transAttrString:(NSString *) trans{
    NSDictionary *dictionaryAttr = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0], NSForegroundColorAttributeName: UIColorRGB(0x6b6b6b)};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"  [%@]", trans] attributes:dictionaryAttr];
    return attrString;
}

-(NSAttributedString *) numberAttrString:(NSString *) num{
    NSDictionary *dictionaryAttr = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0], NSForegroundColorAttributeName: UIColorRGB(0x9a9a9a)};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@  ", num] attributes:dictionaryAttr];
    return attrString;
}


-(NSAttributedString *) posAttrString:(NSString *) pos{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", pos]];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 8;
    
    NSDictionary *dictionaryAttr =  @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0], NSForegroundColorAttributeName: UIColorRGB(0xa37d92),
                                      NSParagraphStyleAttributeName : style};
    
    [attributedString addAttributes:dictionaryAttr range:NSMakeRange(0, [attributedString length])];
    
    return attributedString;
}

-(NSAttributedString *) synAttrString:(NSString *) syn{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:syn];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 8;
    
    
    NSDictionary *dictionaryAttr =  @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0], NSForegroundColorAttributeName: UIColorRGB(0x3c6481), NSParagraphStyleAttributeName : style};
    
    [attrString addAttributes:dictionaryAttr range:NSMakeRange(0, [attrString length])];
    
    return attrString;
}

-(NSAttributedString *) trSynAttrString:(NSString *) syn{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n(%@)", syn]];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 8;
    style.firstLineHeadIndent = 20.f;
    style.headIndent = 20.f;
    
    NSDictionary *dictionaryAttr =  @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0], NSForegroundColorAttributeName: UIColorRGB(0x8d634d), NSParagraphStyleAttributeName : style};
    
    [attrString addAttributes:dictionaryAttr range:NSMakeRange(0, [attrString length])];
    
    return attrString;
}

-(NSAttributedString *) exAttrString:(NSString *) ex trExAttrString:(NSString *) trEx{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@ - %@", ex, trEx]];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 8;
    style.firstLineHeadIndent = 50.f;
    style.headIndent = 50.f;
    
    
    NSDictionary *dictionaryAttr =  @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-MediumItalic" size:15.0], NSForegroundColorAttributeName: UIColorRGB(0x9a8cb5), NSParagraphStyleAttributeName : style};
    
    
    [attrString addAttributes:dictionaryAttr range:NSMakeRange(0, [attrString length])];
    
    return attrString;
}
@end
