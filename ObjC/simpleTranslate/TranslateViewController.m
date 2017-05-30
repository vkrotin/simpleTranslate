//
//  TranslateViewController.m
//  simpleTranslate
//
//  Created by Aleksey Anisimov on 26.02.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

#import "TranslateViewController.h"
#import "LangTableViewController.h"
#import "RequestManager.h"
#import "NSMutableAttributedString+Translate.h"

static NSNotificationName const notificationSelectTranslate = @"notificationSelectTranslate";
static NSNotificationName const notificationUpdateUI = @"updateUI";

@interface TranslateViewController ()<YSKVocalizerDelegate, YSKRecognizerDelegate>{
    NSString *_buffText;
    NSArray *_buffTrArray;
    BOOL _fromDictionaryTab;
    YSKVocalizer *_vocalizer;
    YSKRecognition *_recognition;
    YSKRecognizer *_recognizer;
}
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UITextView *translateTextView;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@property (weak, nonatomic) IBOutlet UIButton *micButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonTo;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonFrom;

@end

@implementation TranslateViewController

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _buffText = [NSString new];
    _buffTrArray = [NSArray new];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyboard) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectTranslate:) name:notificationSelectTranslate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:notificationUpdateUI object:nil];
    
    [self.inputTextView scrollRangeToVisible:NSMakeRange(0, 1)];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self updateUI];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.1 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (_inputTextView.text.length == 0)
            [_inputTextView becomeFirstResponder];
    });
}


-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _fromDictionaryTab = NO;
}

-(IBAction)playButtonTouch:(UIButton *)sender{
    sender.enabled = NO;
    _vocalizer = [[YSKVocalizer alloc] initWithText:_inputTextView.text language:YSKVocalizerLanguageRussian autoPlay:YES voice:YSKVocalizerVoiceZahar];
    _vocalizer.delegate = self;
    [_vocalizer start];
   
}

- (IBAction)recognizeTextButtonTouch:(UIButton *)sender{
    sender.enabled = NO;
    _recognizer = [[YSKRecognizer alloc] initWithLanguage:YSKRecognitionLanguageRussian model:YSKRecognitionModelGeneral];
    _recognizer.delegate = self;
    _recognizer.VADEnabled = YES;
    
    _recognition = nil;
    
    [_recognizer start];
}


- (IBAction)tapGesture:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)revertLangButtonTouch:(id)sender {
    [[RequestManager sharedManager] transformLang:^(STLang *fromLang, STLang *toLang){
        [self.navigationItem.leftBarButtonItem setTitle:fromLang.langName];
        [self.navigationItem.rightBarButtonItem setTitle:toLang.langName];
        
        if (_buffText){
            _inputTextView.text = _buffText;
            [self setRequestWithText:_buffText saveIt:YES];
        }
    }];
    
}

- (void)setRequestWithText:(NSString *)inputText saveIt:(BOOL) saveIt {
    
    if (inputText.length == 0)
        return;
    
    [[RequestManager sharedManager]translateText:inputText
                                      completion:^(NSString *translateText, NSArray *trArray, NSError *error){
                                          _buffText = translateText;
                                          _buffTrArray = trArray;
                                          _translateTextView.attributedText = [[NSMutableAttributedString alloc] initWithText:translateText andTranslateArray:trArray];
                                          
                                          if (saveIt)
                                              [self willHideKeyboard];
                                      }];
}

-(void)willHideKeyboard{
    [[RequestManager sharedManager] saveTranslateToDictionary:@{@"inputText" : _inputTextView.text, @"outputText" : _buffText, @"arrayDict" : _buffTrArray}];
}

-(void) selectTranslate:(NSNotification *) notification{
    STTranslate *selectTr = notification.object;
    _buffText = selectTr.responce;
    _buffTrArray = [NSKeyedUnarchiver unarchiveObjectWithData:selectTr.dictionaryL];
    
    self.inputTextView.text = selectTr.request;
     _translateTextView.attributedText = [[NSMutableAttributedString alloc] initWithText:_buffText
                                                                       andTranslateArray:_buffTrArray];
    _fromDictionaryTab = YES;
}

-(void) updateUI{
    [[RequestManager sharedManager] currentSelectedLanguage:^(STLang *fromLang, STLang *toLang){
        [self.navigationItem.leftBarButtonItem setTitle:fromLang.langName];
        [self.navigationItem.rightBarButtonItem setTitle:toLang.langName];
        
        if (_fromDictionaryTab)
            return;
        
        [self setRequestWithText:_inputTextView.text saveIt:YES];
        
    }];
}

#pragma mark - YSKRecognizerDelegate

- (void)recognizerDidStartRecording:(YSKRecognizer *)recognizer{
    // start recognize
}

- (void)recognizer:(YSKRecognizer *)recognizer didReceivePartialResults:(YSKRecognition *)results withEndOfUtterance:(BOOL)endOfUtterance{
    _recognition = results;
    // update translate
    
    _inputTextView.text = _recognition.bestResultText;
     [self setRequestWithText:_inputTextView.text saveIt:NO];
}

- (void)recognizer:(YSKRecognizer *)recognizer didCompleteWithResults:(YSKRecognition *)results{
    _recognition = results;
    _recognizer = nil;
    _micButton.enabled = YES;
    // _complerion update translate
    _inputTextView.text = _recognition.bestResultText;
     [self setRequestWithText:_inputTextView.text saveIt:YES];
}

- (void)recognizer:(YSKRecognizer *)recognizer didFailWithError:(NSError *)error{
    [self presentError:error];
    _recognizer = nil;
    _micButton.enabled = YES;
    _inputTextView.text = @"";
}

#pragma mark - YSKVocalizerDelegate


- (void)vocalizerDidFinishPlaying:(YSKVocalizer *)vocalizer{
    _voiceButton.enabled = YES;
    _vocalizer = nil;
}

- (void)vocalizer:(YSKVocalizer *)vocalizer didFailWithError:(NSError*)error{
    [self presentError:error];

    _voiceButton.enabled = YES;
}

-(void) presentError:(NSError *) error{
    UIAlertController *failAlert = [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [failAlert addAction:defaultAction];
    [self presentViewController:failAlert animated:YES completion:nil];
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    [self setRequestWithText:textView.text saveIt:NO];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"toSeque"] || [[segue identifier] isEqualToString:@"fromSeque"]){
        UINavigationController *navigationController = [segue destinationViewController];
        LangTableViewController  *langController = (LangTableViewController *)navigationController.topViewController;
        langController.isFrom = [[segue identifier] isEqualToString:@"fromSeque"];
    }
    

}

@end
