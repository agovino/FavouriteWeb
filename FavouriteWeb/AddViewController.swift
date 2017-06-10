//
//  AddViewController.swift
//  FavouriteWeb
//
//  Created by Line Stettler & Marco Agovino on 10.06.17.
//  Copyright © 2017 Stettler & Agovino. All rights reserved.
//

import UIKit
// Speech Framework importieren
import Speech

class AddViewController: UIViewController {
    
    // Delegate setzen
    var delegate: FavouriteWebDelegate?
    
    // Hilfsvariablen
    // auf Audio - Hardware zugreifen
    private let audioEngine = AVAudioEngine()
    // speech
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.current)!
    // nicht als Optional rauskommen
    
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    //
    private var recognitionTask: SFSpeechRecognitionTask?
    
    
    @IBOutlet weak var nameAudioBtn: UIButton!
    @IBOutlet weak var UrlAudioBtn: UIButton!
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var UrlInput: UITextField!
    
    // Aufnahme drücken (Mikrophone)
    @IBAction func nameBtnTapped(_ sender: Any) {
        // hier auf die Methode zugreiffen
        speechInput(forField: nameInput, andButton: nameAudioBtn)
    }
    
    @IBAction func urlBtnTapped(_ sender: Any) {
        // hier auf die Methode zugreiffen
        speechInput(forField: UrlInput, andButton: UrlAudioBtn)
    }
    
    @IBAction func safeTapped(_ sender: Any) {
        // check
        guard  let name = nameInput.text ,
            let url = UrlInput.text
            else {
                print("Name oder Url nicht gesetzt.")
                return
        }
        // Delegate
        // let superUrl = FavouriteWeb(name:name, url:url)
        
        // beide Werte vorhanden, also dem FavouriteWebDelegate übergeben
        delegate?.superUrlAdded(withName: name, andUrl: url)
        // dann Interface verschwinden lassen
        // gibt den letzten ViewController wieder - > abfangen
        // mit Wildcard
        let _ = navigationController?.popViewController(animated: true)
    }

    // Hilfsfunktionen: REC , um Mik-Bilder zu ändern
    private func setRecordingImage(forButton: UIButton){
        forButton.setImage(UIImage(named: "micro-recording"), for: .normal)
    }
    // Hilfsfunktionen: Default , um Mik-Bilder zu ändern
    private func setDefaultImage(forButton: UIButton){
        forButton.setImage(UIImage(named: "micro-default"), for: .normal)
    }
    
    // Hilfsmethode: die beide Mik-Bilder zurücksetzt
    private func resetButtons(){
        setDefaultImage(forButton: nameAudioBtn)
        setDefaultImage(forButton: UrlAudioBtn)
    }
    
    // AudioInput - ganze handeln der Aufnahme
    private func speechInput(forField: UITextField, andButton: UIButton) {
        // wenn audioEngine schon läuft -> stop
        if audioEngine.isRunning{
            audioEngine.stop()
            // Audio beenden
            recognitionRequest?.endAudio()
            // Bild ändern
            // Hilfsfunktionen: REC , um Mik-Bild zu ändern
            setDefaultImage(forButton: andButton)
            
        } else {
            // Aufnahme starten
            // Bild ändern
            setRecordingImage(forButton: andButton)
            do {
                try getTranscription {
                    (transcript) in
                    // Bild ändern - > mit self, da closur-methode
                    self.setDefaultImage(forButton: andButton)
                    // das was aus (transcript) reinkommt wird im Textfeld gespeichert
                    forField.text = transcript
                }
            }   catch let error as NSError {
                // show Error aufrufen
                showError(error.localizedDescription)
                
                // Bild ändern
                setDefaultImage(forButton: andButton)
            }
        }
    }
    
    // Audio in String umwandeln
    // ComplishenHandler @Closerfunction
    // diese Methode kann auch Fehler werfen
    private func getTranscription(withHandler: @escaping (_ transcript: String) ->()) throws {
        // wenn nicht nil -> holen und alten task beenden
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        // audio aufnehmen
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        // --- Request 1. / 2. ---- //
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        // 1. hier wird auf die AudioEngine zugegriffen (Hardware)
        guard let inputNode = audioEngine.inputNode else {
            // show Error aufrufen
            showError("Kein Input gefunden...!")
            
            // Bilder resetButton() rec -> default
            self.resetButtons()
            return
        }
        // 2. nicht Nil sonst
        guard let recognitionRequest = recognitionRequest else {
            print("Request nicht erstellbar.")
            // Bilder resetButton() rec -> default
            self.resetButtons()
            return
        }
        // nur kurze (komplete) Aufnahme -> kein Diktiergerät (mehrere Sätze)!
        recognitionRequest.shouldReportPartialResults = false
        
        // Mikrophon Zugriff vorbereiten
        let format = inputNode.outputFormat(forBus: 0)
        // Tapping - 'Abhören'
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        // Umwandeln von Audio zu Text
        // recognitionTask initialisieren
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            // achtung resultHandler wenn fertig!
            self.audioEngine.stop() // AudioAufnahme stoppen
            inputNode.removeTap(onBus: 0) // tapping entfernen
            
            self.recognitionRequest = nil
            self.recognitionTask = nil
            
            // Offline oder sonst irgend ein Fehler
            guard error == nil else {
                // Error: -> self [closur func]
                self.showError("Konnte Transkript nicht erstellen")
                
                // Bilder reset
                self.resetButtons()
                
                return
            }
            // wenn OK! -> Handler holen (withHandler == Parameter in getTranscription())
            if let result = result {
                withHandler(result.bestTranscription.formattedString)
            }
            
        })
        audioEngine.prepare() // Task starten
        try audioEngine.start() // Aufnahme starten...
        
        
    }
    
    // Fehler anzeigen ohne externes label
    private func showError(_ errorMsg: String){
        // alert Controller
        let alert = UIAlertController(title: "Fehler", message: errorMsg, preferredStyle: .alert) //Fenster
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        // noch anzeigen
        present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
