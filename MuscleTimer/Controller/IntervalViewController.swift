//
//  TimerViewController.swift
//  MuscleTimer
//
//  Created by 倉岡隆志 on 2020/05/29.
//  Copyright © 2020 倉岡隆志. All rights reserved.
//

import UIKit
import AVFoundation

class IntervalViewController: UIViewController {


    @IBOutlet weak var onTimeLabel: UILabel!
    @IBOutlet weak var offTimeLabel: UILabel!
    @IBOutlet weak var setCountLabel: UILabel!
    @IBOutlet weak var navigationBarTitle: UINavigationItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var stopButtonLabel: UIButton!
    @IBOutlet weak var startButtonLabel: UIButton!
    @IBOutlet weak var setLabel: UILabel!
    
    @IBOutlet weak var onTimeView: UIView!
    @IBOutlet weak var offTimeView: UIView!
    
    @IBOutlet weak var shapeView: UIView!
    // タイマー用の時間のための変数
    var timer_sec:Int = 0
    var timer: Timer!
    var isStart: Bool = false
    var isCountDownFinish: Bool = false
    
    var endCount:Int = 0


    var itemName = "NoName"
    var onTime = Int()
    var offTime = Int()
    var setCount = Int()
    
    var changeTimer = 0
    var nowCount = 1 // 何セット目かを表示するための変数
    let intervalTimer = IntervalTimerView()
    
    // カウントダウンミュージック
    var audioPlayer: AVAudioPlayer!
    
    var player: AVAudioPlayer!
    var player2: AVAudioPlayer!
    
    let url = Bundle.main.path(forResource: "Countdown", ofType: "mp3")
    let url2 = Bundle.main.path(forResource: "Countdownfinish", ofType: "mp3")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBarTitle.title = itemName
        
        
        // カウントダウンの表示
        self.timer_sec = Int(onTime)
        
        // OnTimeを秒から分秒に変換
        
        let countDownTime = countDownChageTime(countDownSec: timer_sec)
        self.countDownLabel.text = countDownTime

        // 上部のセット数の設定
        setLabel.text = "セット数：\(nowCount) / \(setCount)"
        
        // 下部のラベル設定
//        onTimeLabel?.text = "\(toMinChange.min):\(onSec)"
        onTimeLabel.text = underLabelChangeTime(nowSec: onTime)
        offTimeLabel?.text = underLabelChangeTime(nowSec: offTime)
        setCountLabel?.text = String(setCount)
        
        // 中央のカウントラベルの色の初期値
        countDownLabel.textColor = .systemRed
        
        // 上部セット数の設定
        setLabel.backgroundColor = UIColor.systemRed
        setLabel.layer.cornerRadius = 10
        setLabel.clipsToBounds = true
        
        // 下部ボタンのデザイン設定
        startButtonLabel.layer.cornerRadius = 10
        stopButtonLabel.layer.cornerRadius = 10
        
        // 運動ラベルのデザイン設定
        onTimeView.layer.borderWidth = 2
        onTimeView.layer.borderColor = UIColor.systemRed.cgColor
        onTimeView.layer.cornerRadius = 10
        
        // 休憩ラベルのデザイン設定
        offTimeView.layer.borderWidth = 2
        offTimeView.layer.borderColor = UIColor.systemBlue.cgColor
        offTimeView.layer.cornerRadius = 10
        

        
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
            try player2 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: url2!))
            
            player.prepareToPlay()
            player2.prepareToPlay()
            
        } catch {
            print(error)
        }
        

    }
    
    
    
    
    @objc func countDown(_ timer: Timer) {

        // タイマーが1になったときの処理
        if self.timer_sec == 1 {
            print("0秒")
            
            // 0ならOnTime作動中、1ならOffTimer作動中
            switch changeTimer {
            case 0:
                // offTimeへ切り替え
                // 最後の休憩は実施しない
                if nowCount != setCount {
                    print("DEBUG_PRINT: OnTIme終了")
                    timer_sec = Int(offTime)
                    setLabel.text = "セット数：\(nowCount) / \(setCount)"

                    // 秒を分秒で表示する
                    let countDownTime = countDownChageTime(countDownSec: timer_sec)
                    self.countDownLabel.text = countDownTime
                    self.countDownLabel.textColor = .systemBlue
                    self.setLabel.backgroundColor = UIColor.systemBlue
                    
                    print("DEBUG_PRINT: offTimeは\(countDownTime)")
                    changeTimer = 1
                } else {
                    self.timer.invalidate()
                    setLabel.text = "お疲れ様でした"
                    // -1 で表示するのを避ける
                    self.countDownLabel.text = "終了"
                }
                // 終了の音を鳴らす
                player2.play()
//                playSound(name: "Countdownfinish")
                return
            case 1:
                // set数更新後OnTimeへ切り替え
                print("DEBUG_PRINT: OffTime終了")
                nowCount += 1
                timer_sec = Int(onTime)
                
                // 秒を分秒で表示する
                let countDownTime = countDownChageTime(countDownSec: timer_sec)
                self.countDownLabel.text = countDownTime
                
                self.countDownLabel.textColor = .systemRed
                setLabel.text = "セット数：\(nowCount) / \(setCount)"
                self.setLabel.backgroundColor = UIColor.systemRed
                
                changeTimer = 0
                
                //終了の音を鳴らす
                playSound(name: "Countdownfinish")
                return
            default:
                return
            }

            
            
        }
        
        self.timer_sec -= 1
        let countDownTime = countDownChageTime(countDownSec: timer_sec)
        self.countDownLabel.text = countDownTime

        // カウントダウンの音を鳴らす
        let countRange = 1...3
        // 2回目以降音が鳴らない現象を回避
        if countRange.contains(timer_sec) {
            if (player.isPlaying) {
                player.stop()
                player.currentTime = 0
            }
            player.play()

        }
        
        if timer_sec == 0 {
            player.stop()
            player2.play()
//            playSound(name: "Countdownfinish")
        }
        

    }

    
    @IBAction func tapStartButton(_ sender: Any) {
        print("DEBUG_PRINT: スタートボタンが押されました")
        
        // カウントダウン完了済みか判断
        if self.isCountDownFinish {
            // STOP中にリセットを押した時の対策のためにifで分岐
            if self.timer != nil {
                self.timer.invalidate()
            }
            
            // ポップアップで本当にリセットしますか？を表示
            let alertController:UIAlertController = UIAlertController(title: "Reset", message: "リセットしますか？", preferredStyle: .alert)
            
            // 初期値にする処理
            let yesAction = UIAlertAction(title: "YES", style: .default) { action in
                print("DEBUG_PRINT: リセットYesAction")
                // 初期値に設定
                self.timer = nil
                self.isCountDownFinish = false
                self.nowCount = 1
                self.changeTimer = 0
                
                self.timer_sec = Int(self.onTime)
                self.setLabel.text = "セット数：\(self.nowCount) / \(self.setCount)"
                
                let countDownTime = self.countDownChageTime(countDownSec: self.timer_sec)
                self.countDownLabel.text = countDownTime
                
                self.startButtonLabel.setTitle("Start", for: UIControl.State())
                self.stopButtonLabel.setTitle("Stop", for: UIControl.State())
                
            }
            
            // リセットをキャンセルしてタイマー再開処理
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { action in
                print("DEBUG_PRINT: リセットCancelAction")
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
                self.stopButtonLabel.setTitle("Stop", for: UIControl.State())
            }
            
            alertController.addAction(yesAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            
            
        } else {
            
            performSegue(withIdentifier: "CountDownViewController", sender: nil)
            
        }

    }
    
    @IBAction func tapStopButton(_ sender: Any) {
        print("DEBUG_PRINT: タイマーがストップされました")
        // カントダウンが完了している場合は処理
        if isCountDownFinish {
            // タイマー作動中
            if self.timer != nil {
                print("タイマー止める")
                self.timer.invalidate()
                self.timer = nil
                stopButtonLabel.setTitle("ReStart", for: UIControl.State())
                
            } else {
                
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:  #selector(countDown), userInfo: nil, repeats: true)
                stopButtonLabel.setTitle("Stop", for: UIControl.State())
                
            }
            
        }

        
    }
    
    @IBAction func backButton(_ sender: Any) {
        if self.timer != nil {
            timer.invalidate()
            self.timer = nil
        }
        dismiss(animated: true, completion: nil)
    }
    
    // スタート前カウントダウン後の最初の処理
    func calledWhenModalDismisses() {
        print("DEBUG_PRINT: インターバルを開始します")
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        self.isCountDownFinish = true
        startButtonLabel.setTitle("Reset", for: UIControl.State())
        self.setLabel.backgroundColor = UIColor.systemRed

    }
    
    
    // 下部のラベル用
    // 秒数を渡すと分秒の文字列で返す関数
    func underLabelChangeTime(nowSec: Int) -> String {
        let timeChange = ToMinChange()
        timeChange.totalSec = nowSec
        timeChange.minChange()
        
        let min = timeChange.min
        let sec = timeChange.sec

        // 秒は二桁に変換
        let zeroSec = String(format: "%02d", sec)
        
        return "\(min):\(zeroSec)"
        
    }
    
    // カウントダウンを文字列で返す
    func countDownChageTime(countDownSec: Int) -> String {
        
        if countDownSec > 59 {
            let timeChage = ToMinChange()
            timeChage.totalSec = countDownSec
            timeChage.minChange()
            
            let min = timeChage.min
            let sec = timeChage.sec
            
            // 秒は二桁に変換
            let zeroSec = String(format: "%02d", sec)
            
            return "\(min):\(zeroSec)"
        } else {
            // 60秒~10秒の時は分なしで表示
            return "\(countDownSec)"
        }
        
    }
}


extension IntervalViewController: AVAudioPlayerDelegate {
    func playSound(name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
            print("DEBUG_PRINT: 音源ファイルが見つかりません")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            
            audioPlayer.delegate = self
            
            audioPlayer.play()
        } catch {
            
        }
    }
}
