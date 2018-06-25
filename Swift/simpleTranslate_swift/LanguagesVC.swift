//
//  LanguagesVC.swift
//  simpleTranslate_swift
//
//  Created by Aleksey Anisimov on 26.05.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

import Foundation
import UIKit

protocol ChangeLanguageDelegate: class {
    func changeLanguage()
}

class LanguagesVC: UITableViewController {
    weak var langDelegate:ChangeLanguageDelegate?
    var isFrom:Bool = false
    let langs:Array<STLang> = RequestManager().allLanguage as! Array<STLang>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        title = isFrom ? "Язык оригинала" : "Язык перевода";
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return langs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell", for: indexPath)
        let lang = langs[indexPath.row]
        cell.textLabel?.text = lang.langName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true)
        
        let lang = langs[indexPath.row]
        if isFrom{
            setFromLangKey(langKey: lang.langKey!)
        }else{
            setToLangKey(langKey: lang.langKey!)
        }
        
        langDelegate?.changeLanguage()
        
       dismiss(animated: true, completion: nil)
        
        
    }

    @IBAction func closeModalAction(_ sender: Any) {
        dismiss(animated: true, completion: {()->Void in
            self.langDelegate = nil
        })
    }
    
}
