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
import AVFoundation

class GameViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    
    
    @IBOutlet weak var vremeLabela: UILabel!
    var match: GKMatch?
    
    @IBOutlet weak var lokalniPogodjeni: UILabel!
    
    @IBOutlet weak var imeProtivnik: UILabel!
    @IBOutlet weak var protivnikPogodjeni: UILabel!
    @IBOutlet weak var skipLabel: UILabel!
    
    @IBOutlet weak var predmetLabel: UILabel!
    @IBOutlet weak var pogadjaLabela: UILabel!
    @IBOutlet weak var skipImage: UIImageView!
    @IBOutlet weak var quitBtn: UIButton!
    @IBOutlet weak var uputstvoLabel: UILabel!
    
    public var gameModel: GameModel! {
            didSet {
                updateUI()
            }
        }
   
    
    let captureSession = AVCaptureSession()
    let cell = SettingsCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gameModel = GameModel()
        
        
        match?.delegate = self
        
        savePlayers()
        
        staviLabeleNaVrh()
        
        // pozivamo fju za vreme
        startOtpTimer()
        
        // fja za pritisak na skip dugme/sliku
        pritisniSkip()
        
        // odavde krece za kameru
        predmetLabel.text =  r.vratiRandomRec()
        
        // muzika
        if  cell.defaults.bool(forKey: "musicButton") as Bool == true{
            playMusic()
        }
        

        //captureSession.sessionPreset = .photo // da bude cropovano na vrhu i dnu
       
        //let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else{return}
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else{return}
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        // tri linije ispod su da bi kamera bila preko celog ekrana
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
        
        
        // ovde analiziramo sta nam kamera pokazuje
        // ovaj vn image req handler je odgovoran za analiziranje slike koju mu prosledjujemo za parametar cgImage. To radis preko ovog .perform poziva
        
        //VNImageRequestHandler(cgImage: <#T##CGImage#>, options: <#T##[VNImageOption : Any]#>).perform(<#T##requests: [VNRequest]##[VNRequest]#>)
        
        
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        guard let model = try? VNCoreMLModel(for: FindMeModel().model) else{return}
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
                    self.sendData()
                }
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    var r = Reci()
    
//    func vratiRandomRec() -> String{
//        let randomInt = Int.random(in: 0...r.reci.count-1)
//        return r.reci[randomInt]
//        
//        r.reci.shuffle()
//    }
    
    var player1: AVAudioPlayer!
    
    func playMusic(){
        
        let number = Int.random(in: 1...4)
        
        switch number {
        case 1:
            let url = Bundle.main.url(forResource: "muzika1", withExtension: "wav")
            self.player1 = try! AVAudioPlayer(contentsOf: url!)
        case 2:
            let url = Bundle.main.url(forResource: "muzika2", withExtension: "wav")
            self.player1 = try! AVAudioPlayer(contentsOf: url!)
        case 3:
            let url = Bundle.main.url(forResource: "muzika3", withExtension: "wav")
            self.player1 = try! AVAudioPlayer(contentsOf: url!)
        case 4:
            let url = Bundle.main.url(forResource: "muzika4", withExtension: "wav")
            self.player1 = try! AVAudioPlayer(contentsOf: url!)
        default:
            print("greska sa zvukom")
        }
        // pusti zvuk
        self.player1.play()
    }
    
    //MARK: - SKIP
    
    var skips = 3
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {

        if(skips > 0){
            if  cell.defaults.bool(forKey: "soundsButton") as Bool == true{
                let url = Bundle.main.url(forResource: "skip", withExtension: "wav")
                player = try! AVAudioPlayer(contentsOf: url!)
                player.play()
            }
           
            skips -= 1
            skipLabel.text = "Skips: \(skips)"
            predmetLabel.text = r.vratiRandomRec()
        }else{
            skipImage.isUserInteractionEnabled = false
        }
        
    }
    
    //MARK: - Fja za pritisni skip dugme
    
    func pritisniSkip(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        skipImage.isUserInteractionEnabled = true
        skipImage.addGestureRecognizer(tapGestureRecognizer)
        
        
    }
    
    // MARK: - Vreme 60s
    
    var timer: Timer?
    var totalTime = 60

    private func startOtpTimer() {
        self.totalTime = 60
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        
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
        if(totalTime <= 5){
            vremeLabela.textColor = .red
            vremeLabela.font = UIFont.systemFont(ofSize: 20)
        }
    }

    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds
        return String(format: "\(seconds) s")
    }
    
    
    let kraj = KrajViewController()
    
    
    func prekiniIgru(){
        
        captureSession.stopRunning()    // da prekine da prepoznaje objekte
        timer?.invalidate()             // i tajmer da prestane
        
        // prekini muziku
        self.player1.stop()
        
        // prikazuje krajVC na kraju igre
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let krajViewController = storyBoard.instantiateViewController(withIdentifier: "krajVC") as! KrajViewController
        //saljemo podatke o rezultatima
        krajViewController.lokalniRezultatVar = "\(gameModel.igraci[1].ime) : \(gameModel.igraci[1].pogodjeni)"
        
        krajViewController.protivnikRezultatVar = "\(gameModel.igraci[0].ime) : \(gameModel.igraci[0].pogodjeni)"
        
        // da zna ko je pobednik
        if gameModel.igraci[0].pogodjeni > gameModel.igraci[1].pogodjeni{
            krajViewController.winner = gameModel.igraci[0].ime
        }else if gameModel.igraci[1].pogodjeni > gameModel.igraci[0].pogodjeni{
            krajViewController.winner = gameModel.igraci[1].ime
        }else{
            krajViewController.winner = "It's a tie!"
        }
        
        krajViewController.modalPresentationStyle = .fullScreen
        self.present(krajViewController, animated:true, completion:nil)
        
        //sendData()
    }
    
    
    
    
    //MARK: - VOICE CHAT
    
        //The name of the channel to join -> to je parametar
    func voiceChat(withName name: String) -> GKVoiceChat?{
        return nil
    }
    
    
    //MARK: - igra
    
    // da labele budu na vrhu kamere tj da se vide
    func staviLabeleNaVrh(){
        vremeLabela.layer.zPosition = 1
        predmetLabel.layer.zPosition = 1
        imeProtivnik.layer.zPosition = 1
        protivnikPogodjeni.layer.zPosition = 1
        lokalniPogodjeni.layer.zPosition = 1
        skipLabel.layer.zPosition = 1
        uputstvoLabel.layer.zPosition = 1
        
        //self.view.sendSubviewToBack(self.view)
        quitBtn.layer.zPosition = 1
        
        skipImage.layer.zPosition = 1
        
        // ovo je da uputstvoLabel nestane nakon 4 sekunde
        uputstvoLabel.text = "Find this object"
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            //self.uputstvoLabel.isHidden = true
            UIView.animate(withDuration: 2) {
                self.uputstvoLabel.alpha = 0
            }
        }
        
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
        guard let protivnik = match?.players.first?.displayName else { return }

        let igracLokalni = Igrac(ime: GKLocalPlayer.local.displayName, pogodjeni: 0)
        let igracProtivnik = Igrac(ime: protivnik, pogodjeni: 0)
        
        // prvo da bude na indeksu 0 protivnik
        gameModel.igraci.insert(igracProtivnik, at: 0)
        // a na indeksu 1 lokalni
        gameModel.igraci.insert(igracLokalni, at: 1)
        
        imeProtivnik.text = match?.players.first?.displayName
        sendData()
    }
    
    // update UI fja se poziva svaki put kad se desi neka promena sa GameModel-om
    private func updateUI() {
        
        guard gameModel.igraci.count >= 2 else { return }
       
        if gameModel.igraci[0].ime == imeProtivnik.text{
            //lokalniPogodjeni.text = String(gameModel.igraci[1].pogodjeni)
            lokalniPogodjeni.text = "You: \(gameModel.igraci[1].pogodjeni)"
            protivnikPogodjeni.text = String(gameModel.igraci[0].pogodjeni)
        }else{
            //lokalniPogodjeni.text = String(gameModel.igraci[0].pogodjeni)
            lokalniPogodjeni.text = "You: \(gameModel.igraci[0].pogodjeni)"
            protivnikPogodjeni.text = String(gameModel.igraci[1].pogodjeni)
        }
    }
    
    private func recPogodjena(){
        
        if cell.defaults.bool(forKey: "soundsButton") as Bool == true{
            playSoundFoundObject()
        }
        
        // ako je igraci[0].ime sto je protivnik(tj onaj koji nije lokalni) == ime protivnika u labeli to znaci da je lokalni pogodio
        if gameModel.igraci[0].ime == imeProtivnik.text {
            // onda povecaj lokalnom pogodjene
            gameModel.igraci[1].pogodjeni += 1
            
        }else{
            // u suprotnom povecaj protivniku pogodjene
            gameModel.igraci[0].pogodjeni += 1
            
        }
        sendData()
        predmetLabel.text =  r.vratiRandomRec()
    }
    
    var player: AVAudioPlayer!
    
    func playSoundFoundObject(){
        
        let number = Int.random(in: 1...3)
        
        switch number {
        case 1:
            let url = Bundle.main.url(forResource: "pogodio1", withExtension: "wav")
            self.player = try! AVAudioPlayer(contentsOf: url!)
        case 2:
            let url = Bundle.main.url(forResource: "pogodio2", withExtension: "wav")
            self.player = try! AVAudioPlayer(contentsOf: url!)
        case 3:
            let url = Bundle.main.url(forResource: "pogodio3", withExtension: "wav")
            self.player = try! AVAudioPlayer(contentsOf: url!)
        default:
            print("greska sa zvukom")
        }
        // pusti zvuk
        self.player.play()
    }

    //MARK: - QUIT
    
    @IBAction func quitPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Quit?", message: "Are you sure you want to quit the match?", preferredStyle: .alert)
                                                                                // u {} zagradama je ono sto ce da
                                                                                //  se desi kad pritisne yes
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            // ako pritisne yes onda mu prikazuje novi ekran tj ekran KrajViewController
             self.prekiniIgru()
                
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))

        self.present(alert, animated: true)
        
    }
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        var lokalniRezultat : String
//        var protivnikRezultat : String
//        
//        if gameModel.igraci[0].ime == imeProtivnik.text{
//            lokalniRezultat = "\(gameModel.igraci[1].ime) : \(gameModel.igraci[1].pogodjeni)"
//            protivnikRezultat = "\(gameModel.igraci[0].ime) : \(gameModel.igraci[0].pogodjeni)"
//        }else{
//            lokalniRezultat = "\(gameModel.igraci[0].ime) : \(gameModel.igraci[0].pogodjeni)"
//            protivnikRezultat = "\(gameModel.igraci[1].ime) : \(gameModel.igraci[1].pogodjeni)"
//        }
//        let destinationVC = segue.destination as! KrajViewController
//        destinationVC.lokalniRezultat.text = lokalniRezultat
//        destinationVC.protivnikRezultat.text = protivnikRezultat
//    }
    
}


//Na osnovu fje sendData -> When this information is received, the didReceive data method of the GKMatchDelegate is triggered and the other players will receive the GameModel. After receiving the new model, just replace the current one with the new one. This is just what is necessary to carry out the exchange of information that we mentioned earlier.
extension GameViewController: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        guard let model = GameModel.decode(data: data) else { return }
        gameModel = model
    }
    
    
}
