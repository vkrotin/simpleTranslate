//
//  String+extension.swift
//  simpleTranslate_swift
//
//  Created by Aleksey Anisimov on 25.05.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

import Foundation

public enum TypeRequest:Int {
    case TYPE_REQUEST_TRANSLATE = 100,
    TYPE_REQUEST_DESCRIPTION = 200,
    TYPE_REQUEST_LANGUAGE = 300
}

extension String {
    init(keyTr:String, textTr:String, type:TypeRequest){
        self = ""
        switch type {
        case .TYPE_REQUEST_TRANSLATE:
            self = translate_request(tLang: keyTr, tText: textTr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        case .TYPE_REQUEST_DESCRIPTION:
            self = dict_request(tLang: keyTr, tText: textTr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        case .TYPE_REQUEST_LANGUAGE:
            self = current_lang_list
        }
    }
    
    
}
