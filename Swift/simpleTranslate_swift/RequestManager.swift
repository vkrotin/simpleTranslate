//
//  RequestManager.swift
//  simpleTranslate_swift
//
//  Created by Aleksey Anisimov on 25.05.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

import Foundation



typealias boolBlock = (Bool, NSError?) ->Void
typealias apiRequest = (Any?,NSError?) ->Void
typealias requestBlock = (String?,Array<Dictionary<String, Any>>?,NSError?) ->Void


class RequestManager:DataManager{
    
    // MARK: - Properties
    static let sharedInstance = RequestManager()
    
    
    func translate(text:String, completion:@escaping requestBlock) {
        ShowNetworkActivityIndicator()
        var completionError:NSError?
        var completionText:String = ""
        var completionTrArray:Array<Dictionary<String, Any>>?

        
        let group = DispatchGroup()
        
        group.enter()
        _translate(text: text, key: selectedLanguageString, type: .TYPE_REQUEST_TRANSLATE, completion: {(object, error) in
            completionError = error  
            if let result:Array<String> = object as? Array<String>{
                completionText  = result.first ?? ""
            }
            group.leave()
        })
        
        group.enter()
        _translate(text: text, key: selectedLanguageString, type: .TYPE_REQUEST_DESCRIPTION, completion: {(object, error) in
            completionError = error
            
            guard let aray = object as? Array<Dictionary<String, Any>> else{
                group.leave()
                return
            }
            completionTrArray  = aray
            group.leave()
        })
        
        group.notify(queue: DispatchQueue.main) {
            HideNetworkActivityIndicator()
            completion(completionText, completionTrArray, completionError)
        }
        
    }
    
    
    private func _translate(text:String, key:String, type:TypeRequest, completion:@escaping apiRequest){
        let urlSt = String(keyTr: key, textTr: text, type: type)
        guard let url =  URL(string:urlSt) else{
            completion(nil, NSError(type: .ERR_KEY_NO_INTERNET_CONNECTION))
            return
        }
        let httprequest = URLSession.shared.dataTask(with: url){ (data, response, error) in
            if error != nil {
                completion(nil, NSError(withError: error))
            } else {
                if let urlContent = data {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options:
                            JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        var error:NSError?
                        if let code:DictResponceErrorCode = jsonResult["code"] as? DictResponceErrorCode{
                            error = NSError(type: code)
                        }
                        
                        switch type{
                        case.TYPE_REQUEST_TRANSLATE:
                            completion (jsonResult["text"], error)
                        case.TYPE_REQUEST_DESCRIPTION:
                            completion(jsonResult["def"], error);
                        default:
                            completion(nil, NSError(type: .ERR_KEY_NO_INTERNET_CONNECTION))
                        }
                    } catch {
                        completion(nil, NSError(type:.ERR_TEXT_NOT_TRANSLATE))
                    }
                }
            }
        }
        httprequest.resume()

    }
    
    func loadLanguageForCurrentLocale(completion:@escaping boolBlock){
        
        let urlSt = String(keyTr: "", textTr: "", type: .TYPE_REQUEST_LANGUAGE)
        let httprequest = URLSession.shared.dataTask(with: URL(string:urlSt)!){ (data, response, error) in
            if error != nil {
                completion(false, NSError.init(withError: error))
                print(error ?? "")
            } else {
                if let urlContent = data {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options:
                            JSONSerialization.ReadingOptions.mutableContainers)
                        
                        self.saveLanguage(lanDict: jsonResult as! Dictionary<String, Any>, completion: {(load, error) in
                            completion(load, error)
                        })
                        
                    } catch {
                        print("JSON Processing Failed")
                    }
                }
            }
        }
        httprequest.resume()
    }
}










