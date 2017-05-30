//
//  NSAttributedString+extension.swift
//  simpleTranslate_swift
//
//  Created by Aleksey Anisimov on 25.05.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString{

    func translate(text:String, trArray:Array<Dictionary<String, Any>>?) {
        
        self.append(textSt(text: String(format: "%@\n", text)))
        
        guard let convert = trArray else {
            return
        }
        
        var isAdd = false
        
        for blockDict in convert {
            if isAdd == false{
                if let text = blockDict["text"] as? String{
                    self.append(textSt(text: text))
                }
                
                if let gen = blockDict["gen"] as? String{
                    self.append(textLightSt(text: gen))
                }
                isAdd = true
            }
            

            if let tr = blockDict["tr"] as? Array<Dictionary<String, Any>>{
                trAtrString(trArray: tr)
            }

        }
        
    }
    
   private func exString(ex:String!, trEx:String!) -> NSAttributedString {
        let formatString = String(format:"\n%@ - %@", ex, trEx)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        style.firstLineHeadIndent = 50.0
        style.headIndent = 50.0
        
        let dictionaryAttr:[String : Any] = [NSFontAttributeName:UIFont.init(name: "HelveticaNeue-MediumItalic", size: 15.0) ?? NSFontAttributeName, NSForegroundColorAttributeName:UIColorRGB(rgb: 0x9a8cb5), NSParagraphStyleAttributeName:style]
    
       return NSAttributedString(string: formatString, attributes: dictionaryAttr)
    }
    
    
   private func trSynString(syn:String!) -> NSAttributedString {
        let formatString = String(format: "\n(%@)", syn)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        style.firstLineHeadIndent = 20.0
        style.headIndent = 20.0
        
        
        let dictionaryAttr:[String : Any] = [NSFontAttributeName:UIFont.init(name: "HelveticaNeue-Medium", size: 15.0) ?? NSFontAttributeName, NSForegroundColorAttributeName:UIColorRGB(rgb: 0x8d634d), NSParagraphStyleAttributeName:style]
        
        return NSAttributedString(string: formatString, attributes: dictionaryAttr)
    }
    
   private func synAttrString(syn:String) -> NSAttributedString {
        let formatString = String(format: "%@", syn)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        
        
        let dictionaryAttr:[String : Any] = [NSFontAttributeName:UIFont.init(name: "HelveticaNeue-Medium", size: 15.0) ?? NSFontAttributeName, NSForegroundColorAttributeName:UIColorRGB(rgb: 0x3c6481), NSParagraphStyleAttributeName:style]
        
        return NSAttributedString(string: formatString, attributes: dictionaryAttr)
    }
    
    private func posAttrString(pos:String) -> NSAttributedString {
        let formatString = String(format: "\n%@", pos)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        
        
        let dictionaryAttr:[String : Any] = [NSFontAttributeName:UIFont.init(name: "HelveticaNeue-Medium", size: 13.0) ?? NSFontAttributeName, NSForegroundColorAttributeName:UIColorRGB(rgb: 0xa37d92), NSParagraphStyleAttributeName:style]
        
        return NSAttributedString(string: formatString, attributes: dictionaryAttr)
    }
    
    private func transAttrString(trans:String) -> NSAttributedString {
        let formatString = String(format: "  [%@]", trans)
        let dictionaryAttr:[String : Any] = [NSFontAttributeName:UIFont.init(name: "HelveticaNeue-Medium", size: 17.0) ?? NSFontAttributeName, NSForegroundColorAttributeName:UIColorRGB(rgb: 0x6b6b6b)]
        return NSAttributedString(string: formatString, attributes: dictionaryAttr)
    }
    
    private func numberAttrString(num:String) -> NSAttributedString {
        let formatString = String(format: "\n%@  ", num)
        let dictionaryAttr:[String : Any] = [NSFontAttributeName:UIFont.init(name: "HelveticaNeue-Medium", size: 17.0) ?? NSFontAttributeName, NSForegroundColorAttributeName:UIColorRGB(rgb: 0x9a9a9a)]
        return NSAttributedString(string: formatString, attributes: dictionaryAttr)
    }
    
    private func textSt(text:String) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        let dictionaryAttr:[String : Any] = [NSFontAttributeName:UIFont.init(name: "HelveticaNeue-Medium", size: 17.0) ?? NSFontAttributeName, NSParagraphStyleAttributeName:style]
        return NSAttributedString(string: text, attributes: dictionaryAttr)
    }
    
    private func textLightSt(text:String) -> NSAttributedString {
        let formatString = String(format: " %@", text)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        let dictionaryAttr:[String : Any] = [NSFontAttributeName:UIFont.init(name: "HelveticaNeue-Light", size: 17.0) ?? NSFontAttributeName, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:UIColorRGB(rgb: 0xAAAAAA)]
        return NSAttributedString(string: formatString, attributes: dictionaryAttr)
    }
    
    private func sinonimsString(text:String, sinonims:Array<Dictionary<String, String>>?) -> String {
        var appString = text
        
        guard (sinonims != nil) else {
            return appString
        }
        
        for dict in sinonims! {
            appString.append(String(format: ", %@", dict["text"]!))
        }
  
  
        return appString
    }
    
    private func bufferString(array:Array<Dictionary<String, String>>) -> String {
        var resultString = String()
        for dict in array {
            var appString = String(format: ", %@", dict["text"]!)
            if NSDictionary(dictionary: dict).isEqual(to: array.first!){
                appString = dict["text"]!
            }
            resultString.append(appString)
        }
        return resultString
    }
    
    private func trAtrString(trArray:Array<Dictionary<String, Any>>)  {
        var index = 0
        for blockDict in trArray {
            index += 1
        
            
            if let sinText = blockDict["text"] as? String{
                self.append(numberAttrString(num: String(format: "%i.", index)))
                self.append(synAttrString(syn: sinonimsString(text: sinText, sinonims: blockDict["syn"] as? Array<Dictionary<String,String>>)))
            }
        
            if let trMean = blockDict["mean"] as? Array<Dictionary<String, String>>{
                let trSyn = bufferString(array: trMean)
                self.append(trSynString(syn: trSyn))
            }
            
            if let array = blockDict["ex"] as? Array<Dictionary<String, Any>>{
                for dict in array {
                    self.append(exString(ex: dict["text"] as! String, trEx: bufferString(array: dict["tr"] as! Array<Dictionary<String, String>>)))
                }
            }
            

        }
    }

    
}

