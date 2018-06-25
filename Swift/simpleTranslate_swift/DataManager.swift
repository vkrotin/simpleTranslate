//
//  DataManager.swift
//  simpleTranslate_swift
//
//  Created by Aleksey Anisimov on 24.05.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

import Foundation
import MagicalRecord

typealias fromToLang = (STLang?, STLang?) ->Void

var fromLangString:String{
    get{
        var from:String = ""
        if let fromLang = STLang.mr_findFirst(byAttribute: "langKey", withValue: getFromLangKey()){
            from = fromLang.langName!
        }
        return from
    }
}

var toLangString:String{
    get{
        var from:String = ""
        if let fromLang = STLang.mr_findFirst(byAttribute: "langKey", withValue: getToLangKey()){
            from = fromLang.langName!
        }
        return from
    }
}


class DataManager{
    
    
    // MARK: - get data methods
    
    
    let allTranslates = STTranslate.mr_findAllSorted(by: "dateAdd", ascending: false)
    let allLanguage = STLang.mr_findAllSorted(by: "langName", ascending: true)
    let selectedLanguageString = String(format: "%@-%@", getFromLangKey(), getToLangKey())
    
    
    func translatesForName(name:String) -> Array<STTranslate> {
        let predicate = NSPredicate(format: "request contains[c] %@ OR responce  contains[c] %@",name, name)
        return STTranslate.mr_findAllSorted(by: "dateAdd", ascending: true, with: predicate) as! Array<STTranslate>
        
    }

    
    
    func currentSelectedLanguage(completion: fromToLang) {
        let fromLang = STLang.mr_findFirst(byAttribute: "langKey", withValue: getFromLangKey())
        let toLang = STLang.mr_findFirst(byAttribute: "langKey", withValue: getToLangKey())
        completion(fromLang, toLang)
    }
    
    func transformLang(completion:fromToLang){
        let fromKey = getFromLangKey()
        let toKey = getToLangKey()
        
        setFromLangKey(langKey: toKey)
        setToLangKey(langKey: fromKey)
        
        currentSelectedLanguage(completion:{ (from, to) in
            completion(from, to)
        })
    }
    
    // MARK: - save data methods
    
    func saveTranslate(translate:Dictionary<String, Any>) {
        
        let inputText:String = translate["inputText"] as! String
        let outputText:String = translate["outputText"] as! String
        let translateDict = translate["arrayDict"] as! Array<Dictionary<String, Any>>
        
        if inputText.characters.count == 0 || outputText.characters.count == 0{
            return;
        }
        
        MagicalRecord.save(blockAndWait:{(localContext : NSManagedObjectContext!) in
            let predicate = NSPredicate(format: "request contains[c] %@ && responce  contains[c] %@", inputText, outputText)
            
            var translate = STTranslate.mr_findFirst(with: predicate, in: localContext)
            
            if translate == nil{
                translate = STTranslate.mr_createEntity(in: localContext)
                translate?.dateAdd = NSDate()
            }
            
            translate?.request = inputText
            translate?.responce = outputText
            translate?.fromLangKey = getFromLangKey()
            translate?.toLangKey = getToLangKey()
            translate?.dictionaryL = NSKeyedArchiver.archivedData(withRootObject: translateDict) as NSData
        })
    }
    
    
    
    func deleteTranslate(tr:STTranslate) {
        MagicalRecord.save(blockAndWait: {(localContext:NSManagedObjectContext!) in
            tr.mr_deleteEntity(in: localContext)
        })
    }
    
    public func saveLanguage(lanDict:Dictionary<String, Any>, completion:@escaping boolBlock) {
        guard let langs:Dictionary<String,String> = lanDict["langs"] as? Dictionary<String, String> else{
            // error
            return
        }
            MagicalRecord.save({(localContext:NSManagedObjectContext!) -> Void in
                for keyLang in langs.keys {
                    if let langName:String = langs[keyLang]{
                        let predicate = NSPredicate(format: "langKey contains[c] %@ AND langName contains[c] %@", keyLang, langName)
                        
                        var lang:STLang? = STLang.mr_findFirst(with: predicate, in: localContext)
                        if lang == nil{
                            lang = STLang.mr_createEntity(in: localContext)
                        }
                        lang?.langKey = keyLang;
                        lang?.langName = langs[keyLang]
                    }
                }
            }, completion: {(save, error) in
                completion(save, nil)
                if save{
                    NotificationCenter.default.post(name: .UPDATE_UI, object: nil)
                }
            })
       
    }
    


}

// MARK: - set/get UserDefaultObj

let from_uk = "from_user_default_key"
let to_uk = "to_user_default_key"


private func getFromLangKey() -> String {
    if (UserDefaults.standard.object(forKey: from_uk) != nil){
        return UserDefaults.standard.object(forKey: from_uk) as! String
    }else{
        setFromLangKey(langKey: "ru")
        return getFromLangKey()
    }
}

func setFromLangKey(langKey:String) {
    UserDefaults.standard.set(langKey, forKey: from_uk)
    UserDefaults.standard.synchronize()
}

private func getToLangKey() -> String {
    if (UserDefaults.standard.object(forKey: to_uk) != nil){
        return UserDefaults.standard.object(forKey: to_uk) as! String
    }else{
        setToLangKey(langKey: "en")
        return getToLangKey()
    }
}

public func setToLangKey(langKey:String) {
    UserDefaults.standard.set(langKey, forKey: to_uk)
    UserDefaults.standard.synchronize()
}




