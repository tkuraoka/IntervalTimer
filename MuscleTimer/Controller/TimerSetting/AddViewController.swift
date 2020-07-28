//
//  AddViewController.swift
//  MuscleTimer
//
//  Created by 倉岡隆志 on 2020/06/22.
//  Copyright © 2020 倉岡隆志. All rights reserved.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UIAdaptivePresentationControllerDelegate {

    var min:Int = 0
    var sec:Int = 0


    // 初期値 timerIDがnilの場合は新規
    var id:Int? = nil
    var timerName = "NoName"
    var onTimer = 0
    var offTimer = 0
    var setCount = 1
    
    // OnTimerかOffTimerのどっちに遷移したかの判断
    var whichTimer = ""
    
    let realm = try! Realm()
    var setTimer = SetTimer()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private var openedSections = Set<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // TODO: setTimerが引き継がれていない
        
        
        if setTimer != nil {
            timerName = setTimer.timerName
            onTimer = setTimer.onTime
            offTimer = setTimer.offTime
            setCount = setTimer.setCount
            print("DEBUG_PRINT: 引き継いだidは\(setTimer.id)")
           
        }
        
        
        
        let nib = UINib(nibName: "PickerCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PickerCell")
        
        
        
        
    }

    
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func addButton(_ sender: Any) {
        print("DEBUG_PRINT: addButtonが押されました")
        
        // 新規であればidを作成して追加する
        // 更新の場合
        // onTimerは必須
        if onTimer == 0 {
            Toast.show("運動時間の入力は必須です", self.view)
            return
        }
        
        try! realm.write {
            setTimer.id = setTimer.id
            setTimer.timerName = timerName
            setTimer.onTime = onTimer
            setTimer.offTime = offTimer
            setTimer.setCount = setCount
            realm.add(setTimer, update: .modified)
            
        }

        
        dismiss(animated: true, completion: nil)
        
    }

    // 開閉する際のセルの数を指定する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    

    
    
    // cellの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // セルごとのテキストの設定
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "タイマー名"
            cell.detailTextLabel?.text = timerName
        case 1:
            cell.textLabel?.text = "運動時間(必須)"
            
            // onTimerを分秒に変換して表示
            cell.detailTextLabel?.text = chageTime(countDownSec: onTimer)
        case 2:
            cell.textLabel?.text = "休憩時間"
            
            // offTimerを分秒に変換して表示
            cell.detailTextLabel?.text = chageTime(countDownSec: offTimer)
        case 3:
            cell.textLabel?.text = "セット数"
            cell.detailTextLabel?.text = "\(setCount)"
        default:
            return cell
        }
        return cell
        
        

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let storyBoard = storyboard?.instantiateViewController(withIdentifier: "TimerNameViewController") as! TimerNameViewController
            storyBoard.timerName = self.timerName
            present(storyBoard, animated: true, completion: nil)
            
        case 1,2:
            let storyBoard = storyboard?.instantiateViewController(withIdentifier: "TimeSettingViewController") as! TimeSettingViewController
            let timeChage = ToMinChange()
            
            if indexPath.row == 1 {

                timeChage.totalSec = self.onTimer
                
                whichTimer = "onTimer"
                
            } else {

                timeChage.totalSec = self.offTimer
                
                whichTimer = "offTimer"
            }

            timeChage.minChange()
            storyBoard.min = timeChage.min
            storyBoard.sec = timeChage.sec
            storyBoard.whichTimer = whichTimer

            present(storyBoard, animated: true, completion: nil)
            
        case 3:
            let storyBoard = storyboard?.instantiateViewController(withIdentifier: "SetCountViewController") as! SetCountViewController
            storyBoard.setCount = setCount
            present(storyBoard, animated: true, completion: nil)
            print("DEBUG_PRINT: \(setCount)")
        default:
            print("")
        }
        
        // セルタップ後に選択色を消す処理
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    


    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        switch segue.identifier {
        case "addNameBack":
            let from = segue.source as! TimerNameViewController
            self.timerName = from.textField.text ?? ""
            print("DEBUG_PRINT: \(from.textField.text)")
            print("DEBUG_PRINT: \(self.timerName)")
        case "addTimerBack":
            if whichTimer == "onTimer" {
                let from = segue.source as! TimeSettingViewController
                // Cell内で秒分に変換するため、秒で代入
                let minTime = from.min
                let secTime = from.sec
                self.onTimer = minTime * 60 + secTime
            } else {
                let from = segue.source as! TimeSettingViewController
                // Cell内で秒分に変換するため、秒で代入
                let minTime = from.min 
                let secTime = from.sec ?? 0
                self.offTimer = minTime * 60 + secTime
            }
            print("DEBUG_PRINT: \(self.onTimer)")
        case "addSetCountBack":
            var from = segue.source as! SetCountViewController
            self.setCount = from.setCount
        default:
            print("DEBUG_PRINT: 未設定の画面からUnwindしました")
        }
        

        tableView.reloadData()
    }

    // 時間を文字列で返す
    func chageTime(countDownSec: Int) -> String {
        let timeChage = ToMinChange()
        timeChage.totalSec = countDownSec
        timeChage.minChange()
        
        let min = timeChage.min
        let sec = timeChage.sec
        
        // 秒は二桁に変換
        let zeroSec = String(format: "%02d", sec)
        
        return "\(min):\(zeroSec)"
    }
    
}
