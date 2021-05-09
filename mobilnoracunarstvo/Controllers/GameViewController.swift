//
//  GameViewController.swift
//  mobilnoracunarstvo
//
//  Created by mladen on 6.4.21..
//

import UIKit
import GameKit
import AVKit
import Vision


class GameViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    
    
    @IBOutlet weak var vremeLabela: UILabel!
    var match: GKMatch?
    
    @IBOutlet weak var lokalniPogodjeni: UILabel!
    
    @IBOutlet weak var imeProtivnik: UILabel!
    @IBOutlet weak var protivnikPogodjeni: UILabel!
    
    @IBOutlet weak var predmetLabel: UILabel!
    @IBOutlet weak var pogadjaLabela: UILabel!
    private var gameModel: GameModel! {
            didSet {
                updateUI()
            }
        }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        print("Game view KONTROLER")
        gameModel = GameModel()
        match?.delegate = self
        
        savePlayers()
        //updateUI()
        
        staviLabeleNaVrh()
        
        // pozivamo fju za vreme
        startOtpTimer()
        
        // odavde krece za kameru
        predmetLabel.text =  vratiRandomRec()
        
        
        
        let captureSession = AVCaptureSession()
        //captureSession.sessionPreset = .photo // da bude cropovano na vrhu i dnu
        
        
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else{return}
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else{return}
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
    
        
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
        
        // ovde analiziramo sta nam kamera pokazuje
        // ovaj vn image req handler je odgovoran za analiziranje slike koju mu prosledjujemo za parametar cgImage. To radis preko ovog .perform poziva
        
        //VNImageRequestHandler(cgImage: <#T##CGImage#>, options: <#T##[VNImageOption : Any]#>).perform(<#T##requests: [VNRequest]##[VNRequest]#>)
        
        
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else{return}
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            //print(finishedReq.results)
            guard let results = finishedReq.results as? [VNClassificationObservation] else{return}
            
            guard let firstObservation = results.first else{return} // results.first je ono sto kamera misli da je objekat
            print(firstObservation.identifier, firstObservation.confidence)
            // ovo .identifier je rec koju prepoznaje a confidence % sigurnosti
            
            // ovde se sad bavimo situacijom kad je prepoznat zadati predmet
            DispatchQueue.main.async{
                if firstObservation.identifier == self.predmetLabel.text{
                    print("POGODIO")
                    self.recPogodjena()
                }
            }
            
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    let r = Reci()
    
    func vratiRandomRec() -> String{
        let randomInt = Int.random(in: 0...r.reci.count-1)
        return r.reci[randomInt]
    }
    
    // MARK: - Vreme 60s
    var timer: Timer?
    var totalTime = 60

    private func startOtpTimer() {
        self.totalTime = 60
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        print(self.totalTime)
        self.vremeLabela.text = self.timeFormatted(self.totalTime) // will show timer

        //self.vremeLabela.text = "\(self.totalTime)s"
        
        if totalTime != 0 {
            totalTime -= 1  // decrease counter timer
        }
        else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
            }
            prekiniIgru()
        }
    }

    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds
        return String(format: "\(seconds)s")
    }
    
    func prekiniIgru(){
        
    }
    
    //MARK: - updateUI
    
    private func updateUI() {
        guard gameModel.igraci.count >= 2 else { return }
            
        //vremeLabela.text = "\(gameModel.time)"
        
        lokalniPogodjeni.text = String(gameModel.igraci[0].pogodjeni)
        
        imeProtivnik.text = gameModel.igraci[1].ime
        
        protivnikPogodjeni.text = String(gameModel.igraci[1].pogodjeni)
        
        
    }
    
    //MARK: - VOICE CHAT
        //The name of the channel to join -> to je parametar
    func voiceChat(withName name: String) -> GKVoiceChat?{
        return nil
    }
    
    
    //MARK: - igra
    // da labele budu na vrhu kamere tj da se vide
    func staviLabeleNaVrh(){
        vremeLabela.layer.zPosition = 1;
        predmetLabel.layer.zPosition = 1;
        imeProtivnik.layer.zPosition = 1;
        protivnikPogodjeni.layer.zPosition = 1;
        lokalniPogodjeni.layer.zPosition = 1;
    }
    
    // send it to the other players when there is a change. We use the sendData method available in GKMatch, passing the GameModel converted to Data.

    private func sendData() {
        guard let match = match else { return }
            
        do {
            guard let data = gameModel.encode() else { return }
            try match.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("Send data failed")
        }
    }

    private func savePlayers() {
        guard let player2Name = match?.players.first?.displayName else { return }
            
        
        let player1 = Igrac(ime: GKLocalPlayer.local.displayName, pogodjeni: 0)
        
        let player2 = Igrac(ime: player2Name, pogodjeni: 0)
            
        gameModel.igraci = [player1, player2]
        print(gameModel.igraci)
        gameModel.igraci.sort { (player1, player2) -> Bool in
            player1.ime < player2.ime
        }
            
        sendData()
    }
    
    private func getLocalPlayerType() -> PlayerType {
        if gameModel.igraci.first?.ime == GKLocalPlayer.local.displayName {
            return .one
        } else {
            return .two
        }
    }
    
    private func recPogodjena(){
        let localPlayer = getLocalPlayerType()
                
        gameModel.igraci[localPlayer.index()].pogodjeni += 1
        sendData()
                
        
        predmetLabel.text =  vratiRandomRec()
        
    }
    
}

//Na osnovu fje sendData -> When this information is received, the didReceive data method of the GKMatchDelegate is triggered and the other players will receive the GameModel. After receiving the new model, just replace the current one with the new one. This is just what is necessary to carry out the exchange of information that we mentioned earlier.
extension GameViewController: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        guard let model = GameModel.decode(data: data) else { return }
        gameModel = model
    }
}
