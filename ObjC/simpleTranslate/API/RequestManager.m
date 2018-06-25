//
//  RequestManager.m
//  simpleTranslate
//
//  Created by Aleksey Anisimov on 26.02.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

#import "RequestManager.h"


NSString *(^encodedURL)(NSString *keyTr, NSString *textTr, TypeRequest typeRequest) = ^(NSString *_keyTr, NSString *_textTr, TypeRequest _typeRequest){
    
    switch (_typeRequest){
        case TYPE_REQUEST_TRANSLATE:
            return  [translate_request(_keyTr, _textTr) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        case TYPE_REQUEST_DESCRIPTION:
            return [dict_request(_keyTr, _textTr) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        case TYPE_REQUEST_LANGUAGE:
            return current_lang_list;
        default:
            return @"";
    }
};

NSError * (^parseError)(NSInteger errorCode) = ^NSError *(NSInteger _errorCode){
    switch (_errorCode) {
        case ERR_OK:
            return nil;
        case ERR_KEY_INVALID:
            return [NSError errorWithDomain:@"vkrotin.ios.ru" code:ERR_KEY_INVALID userInfo:@{NSLocalizedDescriptionKey : @"Неправильный ключ API"}];
        case ERR_KEY_BLOCKED:
            return [NSError errorWithDomain:@"vkrotin.ios.ru" code:ERR_KEY_BLOCKED userInfo:@{NSLocalizedDescriptionKey : @"Ключ API заблокирован"}];
        case ERR_DAILY_REQ_LIMIT_EXCEEDED:
            return [NSError errorWithDomain:@"vkrotin.ios.ru" code:ERR_DAILY_REQ_LIMIT_EXCEEDED userInfo:@{NSLocalizedDescriptionKey : @"Превышено суточное ограничение на количество запросов"}];
        case ERR_TEXT_TOO_LONG:
            return [NSError errorWithDomain:@"vkrotin.ios.ru" code:ERR_TEXT_TOO_LONG userInfo:@{NSLocalizedDescriptionKey : @"Превышен максимально допустимый размер текста"}];
        case ERR_TEXT_NOT_TRANSLATE:
            return [NSError errorWithDomain:@"vkrotin.ios.ru" code:ERR_TEXT_NOT_TRANSLATE userInfo:@{NSLocalizedDescriptionKey : @"Текст не может быть переведен"}];
        case ERR_LANG_NOT_SUPPORTED:
            return [NSError errorWithDomain:@"vkrotin.ios.ru" code:ERR_LANG_NOT_SUPPORTED userInfo:@{NSLocalizedDescriptionKey : @"Заданное направление перевода не поддерживается"}];
        case ERR_DAILY_AMOUNT_LIMIT_EXCEEDED:
            return [NSError errorWithDomain:@"vkrotin.ios.ru" code:ERR_DAILY_AMOUNT_LIMIT_EXCEEDED userInfo:@{NSLocalizedDescriptionKey : @"Заданное направление перевода не поддерживается"}];
        case ERR_KEY_NO_INTERNET_CONNECTION:
            return [NSError errorWithDomain:@"vkrotin.ios.ru" code:ERR_KEY_NO_INTERNET_CONNECTION userInfo:@{NSLocalizedDescriptionKey : @"Отсутствует интернет соединение"}];
        default:
            return [NSError errorWithDomain:@"vkrotin.ios.ru" code:ERR_DAILY_AMOUNT_LIMIT_EXCEEDED userInfo:@{NSLocalizedDescriptionKey : @"Сервер в данный момент не отвечает"}];
    }
};


@implementation RequestManager

+ (instancetype)sharedManager {
    
    static RequestManager *requestManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestManager = [[RequestManager alloc] init];
    });
    return requestManager;
}


- (void)translateText:(NSString *)_translateText completion:(requestBlock)completion {
    ShowNetworkActivityIndicator;
    
    NSString *_keyWord = [self currentSelectedLanguageString];
    
    __block NSError *completionError;
    __block NSString *completionText;
    __block NSArray *completionTrArray;
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        [self _returnTranslate:_translateText
                       keyWord:_keyWord
                       forType:TYPE_REQUEST_TRANSLATE
                    completion:^(NSObject *obj, NSError *err){
            completionError = err;
            completionText = (NSString *) obj;
            if (!completionText)
                completionText = @"";
        }];
    });
    
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        [self _returnTranslate:_translateText
                       keyWord:_keyWord
                       forType:TYPE_REQUEST_DESCRIPTION
                    completion:^(NSObject *obj, NSError *err){
            completionError = err;
            completionTrArray = (NSArray *) obj;
                        
            if (!completionTrArray)
                completionTrArray = [NSArray new];
        }];
    });
    
    dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        
        //  NSDictionary *saveDict = @{@"inputText" : _translateText, @"outputText" : completionText, @"keyWord" : _keyWord, @"arrayDict" : !completionTrArray ? [NSArray new] : completionTrArray };
        
        //[self saveTranslateToDictionary:saveDict];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            HideNetworkActivityIndicator;
            completion(completionText, completionTrArray, completionError);
        });
        
        
    });
}

-(void) _returnTranslate:(NSString *) _textTr keyWord:(NSString *) _keyWord forType:(TypeRequest) _typeRequest completion:(apiRequest) completion{
    
    NSData *dateURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedURL(_keyWord, _textTr, _typeRequest)]];
    if (!dateURL){
        completion(nil, parseError(ERR_KEY_NO_INTERNET_CONNECTION));
        return;
    }
    NSError *error = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:dateURL options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonDictionary && !error){
        error = parseError([jsonDictionary[@"code"] integerValue]);
        
        switch (_typeRequest){
            case TYPE_REQUEST_TRANSLATE:{
                completion(error ? nil :[jsonDictionary[@"text"] lastObject], error ? error : nil);
                break;
            }
            case TYPE_REQUEST_DESCRIPTION:{
                completion(jsonDictionary[@"def"] ? jsonDictionary[@"def"] :[NSArray new], error ? error : nil);
                break;
            }
                
            default:
                completion(nil, parseError(ERR_KEY_NO_INTERNET_CONNECTION));
                
        }
        
    } else{
        NSLog(@"Some error %@", error.description);
        completion(nil, parseError(ERR_KEY_NO_INTERNET_CONNECTION));
    }
}

-(void) loadLanguageForCurrentLocale{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;

        NSString *urlSt = encodedURL(nil, nil, TYPE_REQUEST_LANGUAGE);
        NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlSt]];
        if (!dataURL){
            return;
        }
        
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:dataURL options:NSJSONReadingMutableContainers error:&error];
        if (jsonDictionary && !error){
            [self saveLanguage:jsonDictionary];
        }
    
    });
}



@end
