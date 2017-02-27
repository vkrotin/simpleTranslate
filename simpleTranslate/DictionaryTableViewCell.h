//
//  DictionaryTableViewCell.h
//  simpleTranslate
//
//  Created by Aleksey Anisimov on 27.02.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTranslate+CoreDataClass.h"

@interface DictionaryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dictTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dictTranslateLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromToLabel;

@property (weak, nonatomic) STTranslate *translateObject;

@end
