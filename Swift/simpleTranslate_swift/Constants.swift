//
//  Constants.swift
//  simpleTranslate_swift
//
//  Created by Aleksey Anisimov on 24.05.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

import Foundation
import UIKit

let current_language = Locale.current.languageCode
let yandex_dict_key = "dict.1.1.20150223T182028Z.44c4ff2b1c7e23bd.ae779d9902ca707e1bc272cf99eaa4cb51295c01"
let yandex_sound_key = "63abe285-f288-45c6-bf15-73007e00cf4c"
let yandex_key = "trnsl.1.1.20150222T163032Z.8d580206cee16d6a.a311de8a6dd03085ba816701636b7ffdb45e5373"

let current_lang_list = String(format: "https://translate.yandex.net/api/v1.5/tr.json/getLangs?key=%@&ui=%@", yandex_key, current_language!)

func dict_request(tLang:String, tText:String) -> String {
    return String(format: "https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=%@&lang=%@&text=%@",yandex_dict_key, tLang, tText)
}

func translate_request(tLang:String, tText:String) -> String {
    return String(format: "https://translate.yandex.net/api/v1.5/tr.json/translate?key=%@&lang=%@&text=%@",yandex_key, tLang, tText)
}

func current_lang(tText:String) -> String {
    return String(format: "https://translate.yandex.net/api/v1.5/tr.json/detect?key=%@&text=%@",yandex_key, tText)
}

func yandex_sound_request(lang:String, speacer:String, text:String) -> String {
    return String(format: "http://tts.voicetech.yandex.net/generate?text=%@&format=wav&lang=%@&speaker=%@&emotion=good&key=%@", text, lang, speacer, yandex_sound_key)
}



func UIColorRGB(rgb: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgb & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func ShowNetworkActivityIndicator() {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
}

func HideNetworkActivityIndicator(){
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
}

let _mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
