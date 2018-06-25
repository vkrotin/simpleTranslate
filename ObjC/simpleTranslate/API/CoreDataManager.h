//
//  CoreDataManager.h
//  simpleTranslate
//
//  Created by Aleksey Anisimov on 26.02.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STTranslate+CoreDataClass.h"
#import "STLang+CoreDataClass.h"

typedef void (^fromToLang)(STLang *fromLang, STLang *toLang);

@interface CoreDataManager : NSObject


- (void)saveLanguage:(NSDictionary *)langDictionary;

-(NSArray *) getLanguageArray;

- (void)currentSelectedLanguage:(fromToLang) completion;

- (NSString *)currentSelectedLanguageString;

-(void) setFromLangKey:(NSString *) fromLangKey;
-(void) setToLangKey:(NSString *) toLangKey;

-(NSString *) getFromLangKey;
-(NSString *) getToLangKey;


// translates methods

- (void)transformLang:(fromToLang) complete;

- (NSMutableArray *)getAllTranslates;

-(void)saveTranslateToDictionary:(NSDictionary *) translateObject;

- (NSArray *)getTranslatesForName:(NSString *)translateName;
-(void) deleteTranslate:(STTranslate *) tr;


@end
