//
//  DictionaryVC.swift
//  simpleTranslate_swift
//
//  Created by Aleksey Anisimov on 26.05.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

import Foundation
import UIKit

class DictionaryVC : UITableViewController{
    
    private let cellIdent = "dictionaryViewCell"
    private var translates:Array<STTranslate> =  Array()
    private var emptyView:LoadingTableViewEmpty = LoadingTableViewEmpty()

    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        tableView.tableFooterView = UIView()
        translates = RequestManager().allTranslates as! Array<STTranslate>
        tableView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        emptyView = LoadingTableViewEmpty(frame: tableView.frame)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if translates.count > 0 {
            tableView.backgroundView = UIView()
            return translates.count
        }else{
            tableView.backgroundView = emptyView
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdent, for: indexPath) as! DictionaryCell
        cell.translate(tr: translates[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let navControl:UINavigationController = tabBarController?.viewControllers?[0] as? UINavigationController{
            if let translate:TranslateVC = navControl.viewControllers[0] as? TranslateVC{
                setFromLangKey(langKey: translates[indexPath.row].fromLangKey!)
                setToLangKey(langKey: translates[indexPath.row].toLangKey!)
                translate.setDictionaryTranslate(tr: translates[indexPath.row])
            }
        }
        tabBarController?.selectedIndex = 0
        // use notification
        // NotificationCenter.default.post(name: .SELECT_TRANSLATE, object: translates[indexPath.row])
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let tr = translates[indexPath.row]
            if let index = translates.index(of:tr) {
                translates.remove(at: index)
            }
            RequestManager().deleteTranslate(tr: tr)
            tableView.deleteRows(at:[indexPath], with:.automatic)
            tableView.reloadData()
        }
    }

    

}
