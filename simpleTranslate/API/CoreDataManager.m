//
//  CoreDataManager.m
//  simpleTranslate
//
//  Created by Aleksey Anisimov on 26.02.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

- (void)saveTranslateToDictionary:(NSDictionary *)translateObject {
    
    if (((NSString *)translateObject[@"inputText"]).length == 0 || ((NSString *)translateObject[@"outputText"]).length == 0){
        return;
    }
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *currentContext){
        STTranslate *translate = [STTranslate MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"request contains[c] %@ && responce  contains[c] %@", translateObject[@"inputText"], translateObject[@"outputText"]] inContext:currentContext];
        
        if (!translate){
            translate = [STTranslate MR_createEntityInContext:currentContext];
            translate.dateAdd = [NSDate date];
        }
        
        translate.request = translateObject[@"inputText"];
        translate.responce = translateObject[@"outputText"];
        translate.fromLangKey = [self getFromLangKey];
        translate.toLangKey = [self getToLangKey];
        translate.dictionaryL = [NSKeyedArchiver archivedDataWithRootObject:translateObject[@"arrayDict"]];
        
    }];
}


- (NSMutableArray *)getAllTranslates{
    return [[STTranslate MR_findAllSortedBy:@"dateAdd" ascending:NO] mutableCopy];
}

- (NSArray *)getTranslatesForName:(NSString *)translateName {
    
    return [STTranslate MR_findAllSortedBy:@"dateAdd" ascending:YES
                             withPredicate:[NSPredicate predicateWithFormat:@"request contains[c] %@ OR responce  contains[c] %@", translateName, translateName]
                                 inContext:[NSManagedObjectContext MR_newMainQueueContext]];
}

- (void)deleteTranslateObject:(STTranslate *)deleteObject {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *currentContext){
        [deleteObject MR_deleteEntityInContext:currentContext];
    }];
}


-(void)saveLanguage:(NSDictionary *)langDictionary {
        
        NSDictionary *langs = langDictionary[@"langs"];
        for(NSString *keyLang in langs.allKeys){
            [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *currentContext){
                STLang *lang = [STLang MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"langKey contains[c] %@ AND langName contains[c] %@", keyLang, langs[keyLang]] inContext:currentContext];
                
                if (!lang){
                    lang = [STLang MR_createEntityInContext:currentContext];
                }
                
                lang.langKey = keyLang;
                lang.langName = langs[keyLang];
                
            }];
        }
        
   
}

- (NSArray *)getLanguageArray {
    return  [STLang MR_findAllSortedBy:@"langName" ascending:YES];
}

- (void)currentSelectedLanguage:(fromToLang) completion{
    
    STLang *fromLang = [STLang MR_findFirstByAttribute:@"langKey" withValue:[self getFromLangKey]];
    STLang *toLang = [STLang MR_findFirstByAttribute:@"langKey" withValue:[self getToLangKey]];
    
    completion(fromLang, toLang);
}

- (NSString *)currentSelectedLanguageString{
    return [NSString stringWithFormat:@"%@-%@", [self getFromLangKey],[self getToLangKey]];
}


- (void)transformLang:(fromToLang) complete{
    
    NSString *from = [self getFromLangKey];
    NSString *to = [self getToLangKey];
    [self setFromLangKey:to];
    [self setToLangKey:from];
    
    [self currentSelectedLanguage:^(STLang *fromL, STLang *toL){
        complete(fromL, toL);
    }];
    
}


#pragma mark - set/get UserDefaultObj

#define FROM_UK @"from_user_default_key"
#define TO_UK @"to_user_default_key"
#define SharedUserDefault [NSUserDefaults standardUserDefaults]

-(NSString *) getFromLangKey{
    if ([SharedUserDefault objectForKey:FROM_UK]){
        return [SharedUserDefault objectForKey:FROM_UK];
    }else{
        [self setFromLangKey:@"ru"];
        return [self getFromLangKey];
    }
}

-(void) setFromLangKey:(NSString *) fromLangKey{
    [SharedUserDefault setObject:fromLangKey forKey:FROM_UK];
    [SharedUserDefault synchronize];
}

-(NSString *) getToLangKey{
    if ([SharedUserDefault objectForKey:TO_UK]){
        return [SharedUserDefault objectForKey:TO_UK];
    }else{
        [self setToLangKey:@"en"];
        return [self getToLangKey];
    }
}
-(void) setToLangKey:(NSString *) toLangKey{
    [SharedUserDefault setObject:toLangKey forKey:TO_UK];
    [SharedUserDefault synchronize];
}

@end
