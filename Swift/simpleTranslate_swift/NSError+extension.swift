//
//  NSError+extension.swift
//  simpleTranslate_swift
//
//  Created by Aleksey Anisimov on 25.05.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

import Foundation

public enum DictResponceErrorCode : Int{
    case ERR_OK = 200, //Операция выполнена успешно.
    ERR_KEY_INVALID = 401, //Ключ API невалиден.
    ERR_KEY_BLOCKED = 402, //Ключ API заблокирован.
    ERR_DAILY_REQ_LIMIT_EXCEEDED = 403, //Превышено суточное ограничение на количество запросов.
    ERR_TEXT_TOO_LONG = 413, //Превышен максимальный размер текста.
    ERR_LANG_NOT_SUPPORTED = 501, //Заданное направление перевода не поддерживается.
    ERR_DAILY_AMOUNT_LIMIT_EXCEEDED = 404, //Превышено суточное ограничение на объем переведенного текста
    ERR_TEXT_NOT_TRANSLATE = 422, //Текст не может быть переведен
    ERR_KEY_NO_INTERNET_CONNECTION = 876 // Отсутствует интернет соединение
    
    func localizedUserInfo() -> [String: String] {
        var localizedDescription: String = ""
        let localizedFailureReasonError: String = ""
        let localizedRecoverySuggestionError: String = ""
        
        switch self {
        case .ERR_OK:
            localizedDescription = ""
        case .ERR_KEY_INVALID:
            localizedDescription = "Неправильный ключ API"
        case .ERR_KEY_BLOCKED:
            localizedDescription = "Ключ API заблокирован"
        case .ERR_DAILY_REQ_LIMIT_EXCEEDED:
            localizedDescription = "Превышено суточное ограничение на количество запросов"
        case .ERR_TEXT_TOO_LONG:
            localizedDescription = "Превышен максимально допустимый размер текста"
        case .ERR_LANG_NOT_SUPPORTED:
            localizedDescription = "Заданное направление перевода не поддерживается"
        case .ERR_DAILY_AMOUNT_LIMIT_EXCEEDED:
            localizedDescription = "Превышено суточное ограничение на объем переведенного текста"
        case .ERR_TEXT_NOT_TRANSLATE:
            localizedDescription = "Текст не может быть переведен"
        case .ERR_KEY_NO_INTERNET_CONNECTION:
            localizedDescription = "Отсутствует интернет соединение"
        }
        return [
            NSLocalizedDescriptionKey: localizedDescription,
            NSLocalizedFailureReasonErrorKey: localizedFailureReasonError,
            NSLocalizedRecoverySuggestionErrorKey: localizedRecoverySuggestionError
        ]
    }
}

public let ProjectErrorDomain = "vkrotin.ios.ru"

extension NSError {
    public convenience init(type: DictResponceErrorCode) {
        self.init(domain: ProjectErrorDomain, code: type.rawValue, userInfo: type.localizedUserInfo())
    }
    
    public convenience init(typeInt: Int) {
        let type:DictResponceErrorCode = DictResponceErrorCode(rawValue: typeInt)!
        self.init(domain: ProjectErrorDomain, code: typeInt, userInfo: type.localizedUserInfo())
    }
    
    public convenience init(withError: Error?) {
        self.init(domain: ProjectErrorDomain, code:876, userInfo:DictResponceErrorCode.ERR_KEY_NO_INTERNET_CONNECTION.localizedUserInfo())
    }
}
