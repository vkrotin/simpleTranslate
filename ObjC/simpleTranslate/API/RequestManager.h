//
//  RequestManager.h
//  simpleTranslate
//
//  Created by Aleksey Anisimov on 26.02.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"


typedef NS_ENUM(NSInteger , DictResponceErrorCode){
    ERR_OK = 200, //Операция выполнена успешно.
    ERR_KEY_INVALID = 401, //Ключ API невалиден.
    ERR_KEY_BLOCKED = 402, //Ключ API заблокирован.
    ERR_DAILY_REQ_LIMIT_EXCEEDED = 403, //Превышено суточное ограничение на количество запросов.
    ERR_TEXT_TOO_LONG = 413, //Превышен максимальный размер текста.
    ERR_LANG_NOT_SUPPORTED = 501, //Заданное направление перевода не поддерживается.
    ERR_DAILY_AMOUNT_LIMIT_EXCEEDED = 404, //Превышено суточное ограничение на объем переведенного текста
    ERR_TEXT_NOT_TRANSLATE = 422, //Текст не может быть переведен
    ERR_KEY_NO_INTERNET_CONNECTION = 876 // Отсутствует интернет соединение
};

typedef NS_ENUM(NSInteger, TypeRequest){
    TYPE_REQUEST_TRANSLATE = 100,
    TYPE_REQUEST_DESCRIPTION = 200,
    TYPE_REQUEST_LANGUAGE = 300
};

typedef void (^apiRequest)(NSObject *someText, NSError *error);
typedef void (^requestBlock)(NSString *translateText, NSArray *dictTranslateArray, NSError *error);


@interface RequestManager : CoreDataManager

+ (instancetype)sharedManager;

- (void)translateText:(NSString *)_translateText completion:(requestBlock)completion;

- (void)loadLanguageForCurrentLocale;

@end
