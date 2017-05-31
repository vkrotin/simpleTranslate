//
//  TranslateVC.swift
//  simpleTranslate_swift
//
//  Created by Aleksey Anisimov on 26.05.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

import Foundation
import UIKit


class TranslateVC: UIViewController, UITextViewDelegate, ChangeLanguageDelegate, YSKVocalizerDelegate, YSKRecognizerDelegate {

//MARK: - Initialize
    
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var translateTextView: UITextView!
    
    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var fromButtonItem: UIBarButtonItem!
    @IBOutlet weak var toButtonItem: UIBarButtonItem!
    
    private var buffText:String = ""
    private var buffTrArray:Array<Dictionary<String, Any>>?
    
    private var _vocalizer:YSKVocalizer?
    private var _recognition:YSKRecognition?
    private var _recognizer:YSKRecognizer?
    

    deinit {
        // perform the deinitialization
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName:.SELECT_TRANSLATE, object:nil, queue:OperationQueue.main, using:selectTranslate)
        NotificationCenter.default.addObserver(forName:.UIKeyboardWillShow, object: nil, queue: OperationQueue.main, using: keyboardWillShow)
        NotificationCenter.default.addObserver(forName:.UIKeyboardWillHide, object: nil, queue: OperationQueue.main, using: keyboardWillHide)
        
        inputTextView.scrollRangeToVisible(NSMakeRange(0, 1))
        
        self.navigationItem.leftBarButtonItem?.title = fromLangString
        self.navigationItem.rightBarButtonItem?.title = toLangString

        RequestManager().loadLanguageForCurrentLocale(completion: {(isComplite, error) in
            self.navigationItem.leftBarButtonItem?.title = fromLangString
            self.navigationItem.rightBarButtonItem?.title = toLangString
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if inputTextView.text.characters.count == 0{
            inputTextView.becomeFirstResponder()
        }
    }
    
//MARK: - Translate request
    
    func request(text:String!, isSave:Bool) {
        if text == nil{
            return
        }
        
        RequestManager().translate(text: text, completion: {(_text, _array, error) in  
            self.buffText = _text ?? ""
            self.buffTrArray = _array ?? Array()
            
            let attr = NSMutableAttributedString(string: "")
            attr.translate(text: _text ?? "", trArray: _array ?? Array())
            self.translateTextView.attributedText = attr
            
            if (isSave){
                self.keyboardWillHide(notification: nil)
            }
            
            
        
        })
        
    }
 
//MARK: - Events Notification
    
    func keyboardWillShow(notification:Notification?) -> Void {
        
    }
    
    func keyboardWillHide(notification:Notification?) -> Void  {
        RequestManager().saveTranslate(translate: ["inputText":inputTextView.text, "outputText":buffText, "arrayDict":buffTrArray ?? Array()])
    }
    
    func selectTranslate(notification:Notification) -> Void {
        guard let object = notification.object else {
            print("No object recive")
            return
        }
        
        if let selectTranslate:STTranslate = object as? STTranslate{
            setDictionaryTranslate(tr: selectTranslate)
        }
    }

//MARK: - Events UI Touch
    
    @IBAction func revertButton_touch(_ sender: Any) {
        
        RequestManager().transformLang(completion: {(from, to) in
            self.navigationItem.leftBarButtonItem?.title = from?.langName ?? ""
            self.navigationItem.rightBarButtonItem?.title = to?.langName ?? ""
            
            self.inputTextView.text = self.buffText
            request(text: buffText, isSave: true)
        })
    }
    @IBAction func volumeButton_touch(_ sender: Any) {
        if let button = sender as? UIButton{
            button.isEnabled = false
            _vocalizer = YSKVocalizer(text: inputTextView.text, language: YSKVocalizerLanguageRussian, autoPlay: true, voice: YSKVocalizerVoiceJane)
            _vocalizer?.delegate = self
            _vocalizer?.start()
        }

    }
   
    @IBAction func micButton_touch(_ sender: Any) {
        if let button = sender as? UIButton{
            button.isEnabled = false
            _recognition = nil
            _recognizer = YSKRecognizer(language: YSKRecognitionLanguageRussian, model: YSKRecognitionModelGeneral)
            _recognizer?.delegate = self
            _recognizer?.isVADEnabled = true
            _recognizer?.start()
        }
    }
    
    @IBAction func tapGesture(_ sender: Any) {
        view.endEditing(true)
    }
    
//MARK: - Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let nav = segue.destination as? UINavigationController, let langController = nav.topViewController as? LanguagesVC {
            langController.isFrom = segue.identifier == "fromSeque"
            langController.langDelegate = self
        }
    }
    
//MARK: - Pass parameters
    
    func setDictionaryTranslate(tr:STTranslate) {
        buffText = tr.responce ?? ""
        buffTrArray = NSKeyedUnarchiver.unarchiveObject(with: tr.dictionaryL! as Data) as? Array<Dictionary<String, Any>>
        
        inputTextView.text = tr.request ?? ""
        let attr = NSMutableAttributedString(string: "")
        attr.translate(text: buffText, trArray: buffTrArray!)
        translateTextView.attributedText = attr
        
        self.navigationItem.leftBarButtonItem?.title = fromLangString
        self.navigationItem.rightBarButtonItem?.title = toLangString
    }
    
//MARK: - ErrorView
    
    func presentError(error:Error!)  {
        let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
//MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        request(text: textView.text, isSave: false)
    }
    
//MARK: - ChangeLanguageDelegate
    
    func changeLanguage(){
        self.navigationItem.leftBarButtonItem?.title = fromLangString
        self.navigationItem.rightBarButtonItem?.title = toLangString
        
        request(text: inputTextView.text, isSave: true)
    }
    
//MARK: - YSKVocalizerDelegate
    
    func vocalizerDidFinishPlaying(_ vocalizer: YSKVocalizer!) {
        voiceButton.isEnabled = true
        _vocalizer?.delegate = nil
        _vocalizer = nil
    }
    
    func vocalizer(_ vocalizer: YSKVocalizer!, didFailWithError error: Error!) {
        voiceButton.isEnabled = true
        _vocalizer?.delegate = nil
        _vocalizer = nil
        presentError(error: error)
    }
    
    
//MARK: - YSKRecognizerDelegate
    
    func recognizer(_ recognizer: YSKRecognizer!, didReceivePartialResults results: YSKRecognition!, withEndOfUtterance endOfUtterance: Bool) {
        _recognition = results
        inputTextView.text = _recognition?.bestResultText
        request(text: inputTextView.text, isSave: false)
    }
    
    func recognizer(_ recognizer: YSKRecognizer!, didCompleteWithResults results: YSKRecognition!) {
        _recognition = results
        _recognizer?.delegate = nil
        _recognizer = nil
        micButton.isEnabled = true
        inputTextView.text = _recognition?.bestResultText
        request(text: inputTextView.text, isSave: true)
    }
    
    func recognizer(_ recognizer: YSKRecognizer!, didFailWithError error: Error!) {
        presentError(error: error)
        _recognizer?.delegate = nil
        _recognizer = nil
        micButton.isEnabled = true
        inputTextView.text = ""
    }

}
