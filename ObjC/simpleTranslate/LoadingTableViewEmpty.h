//
//  LoadingTableViewEmpty.h
//  simpleTranslate
//
//  Created by Aleksey Anisimov on 01.06.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewFromXib.h"


@interface LoadingTableViewEmpty : CustomViewFromXib
@property (weak, nonatomic) IBOutlet UIImageView *emptyImageView;
@property (weak, nonatomic) IBOutlet UILabel *enptyTextLabel;

@end
