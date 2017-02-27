//
//  DictionaryTableViewCell.m
//  simpleTranslate
//
//  Created by Aleksey Anisimov on 27.02.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

#import "DictionaryTableViewCell.h"


@implementation DictionaryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) setTranslateObject:(STTranslate *)translateObject{
    _translateObject = translateObject;
    
    self.dictTextLabel.text = _translateObject.request;
    self.dictTextLabel.text = _translateObject.responce;
    self.fromToLabel.text = [NSString stringWithFormat:@"%@-%@", _translateObject.fromLangKey, _translateObject.toLangKey];
}

@end
