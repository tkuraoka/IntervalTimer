//
//  ViewController.swift
//  MuscleTimer
//
//  Created by 倉岡隆志 on 2020/05/29.
//  Copyright © 2020 倉岡隆志. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class MainViewController: UIViewController,GADBannerViewDelegate {
    
@IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var bannerView: GADBannerView!
    
    
//    var itemList: Results<SetTimer>!
    let realm = try! Realm()
    
    var setTimerArray = try! Realm().objects(SetTimer.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let mainBundle = Bundle.main
        let seedFilePath = mainBundle.path(forResource: "seed", ofType: "realm")
        let path = Bundle.main.path(forResource: "CountDown", ofType: "mp3")


        let documentDir: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        print(documentDir)
        let realmPath = documentDir.strings(byAppendingPaths: ["seed.realm"])
        print(realmPath)


        configureCollectionView()
        
        let nib = UINib(nibName: "CustomCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CustomCell")
        
        do {
            let realm = try Realm()
            setTimerArray = realm.objects(SetTimer.self)
                                    .sorted(byKeyPath: "order", ascending: true)
                                    .sorted(byKeyPath: "id", ascending: false)
        }catch{
            
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        // ダークモード対応
        if traitCollection.userInterfaceStyle == .dark {
            // ナビゲーションバーのタイトルの文字色
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()

        bannerView.adUnitID = AdmobData.getID()
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }

    // アプリ起動中にダークモードに切り替わった時の動き
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        
        
    }
    func configureCollectionView() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(actionLongPressGesture(gesture:)))
        self.collectionView.addGestureRecognizer(longPressGesture)
    }
    
    // 追加するときは主キーを作成してAddViewへ値を渡す
    @IBAction func addButton(_ sender: Any) {
        print("addButtonが押されました")
        let setTimer = SetTimer()
        let allSetTimer = realm.objects(SetTimer.self)
        print("DEBUG_PRINT: 作成したIDは\(allSetTimer.count)")
        if allSetTimer.count != 0 {
            setTimer.id = allSetTimer.max(ofProperty: "id")! + 1
            print("DEBUG_PRINT: 作成したIDは\(setTimer.id)")
        }
        
        let storyBoard = self.storyboard?.instantiateViewController(identifier: "add") as! AddViewController
        storyBoard.setTimer = setTimer
        present(storyBoard, animated: true, completion: nil)
    }
    
    @objc func actionLongPressGesture(gesture: UILongPressGestureRecognizer) {
        switch (gesture.state) {
        case .began:

            guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                break
            }
            
            // 削除するかのポップアップ
            let alertController:UIAlertController = UIAlertController(title: "Edit", message: "", preferredStyle: .alert)
            
            let editAction = UIAlertAction(title: "Edit", style: .default) { action in
                // editするセルの値を取得
                let setTimer = SetTimer()
                setTimer.timerName = self.setTimerArray[selectedIndexPath.row].timerName
                setTimer.onTime = self.setTimerArray[selectedIndexPath.row].onTime
                setTimer.offTime = self.setTimerArray[selectedIndexPath.row].offTime
                setTimer.setCount = self.setTimerArray[selectedIndexPath.row].setCount
                setTimer.id = self.setTimerArray[selectedIndexPath.row].id
                let storyBoard = self.storyboard?.instantiateViewController(identifier: "add") as! AddViewController
                storyBoard.setTimer = setTimer
                
                print("DEBUG_PRINT: 選択されたindexは\(selectedIndexPath.row)")
                print("DEBUG_PRINT: 選択されたセルのitem名は\(self.setTimerArray[selectedIndexPath.row].timerName)")
                
                self.present(storyBoard, animated: true, completion: nil)
                
            }
            
            let deleteAction = UIAlertAction(title: "Delete", style: .default) { action in
                print("DEBUG_PRINT: 削除ボタンが押されました")
                print(selectedIndexPath.row)
                var selectData = self.setTimerArray[selectedIndexPath.row]
                // 削除する
                try! self.realm.write {
                    self.realm.delete(selectData)
                }
                self.collectionView.reloadData()
            }
            
            
            // Deleteをキャンセル
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { action in
                print("DEBUG_PRINT: Deleteがキャンセルされました")
            }
            
            alertController.addAction(editAction)
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            

        case .changed:
            print("DEBUG_PRINT: changedが押されました")
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            print("DEBUG_PRINT: endedが押されました")
            collectionView.endInteractiveMovement()
            // 終了時に位置を保存します
            
            
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
}


//MARK: - UICollectionViewDataSource Methods
extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return setTimerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.itemLabel.text = "\(setTimerArray[indexPath.row].timerName)"
        
        // OnTimeを秒から分秒に変換して表示
        let toMinChange = ToMinChange()
        toMinChange.totalSec = setTimerArray[indexPath.row].onTime
        toMinChange.minChange()
        cell.onTimeLabel.text = String("\(toMinChange.min) min \(toMinChange.sec) sec")
        
        // OffTimeを秒から分秒に変換して表示
        let toMinChange2 = ToMinChange()
        toMinChange2.totalSec = setTimerArray[indexPath.row].offTime
        toMinChange2.minChange()
        cell.offTimeLabel.text = String("\(toMinChange2.min) min \(toMinChange2.sec) sec")
        
        cell.setCountLabel.text = String("\(setTimerArray[indexPath.row].setCount) Set")
        
        // cellのデザインを変更
        cell.layer.cornerRadius = 10
        
        if self.traitCollection.userInterfaceStyle == .dark {
            cell.onTimeLabel.textColor = .white
            cell.offTimeLabel.textColor = .white
            cell.setCountLabel.textColor = .white
            cell.onTimeTitleLabel.textColor = .white
            cell.offTimeTitleLabel.textColor = .white
            cell.setCountTitleLbal.textColor = .white
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

    }
    
}


extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = self.storyboard?.instantiateViewController(identifier: "IntervalViewController") as! IntervalViewController
        storyBoard.itemName = setTimerArray[indexPath.row].timerName
        storyBoard.onTime = setTimerArray[indexPath.row].onTime
        storyBoard.offTime = setTimerArray[indexPath.row].offTime
        storyBoard.setCount = setTimerArray[indexPath.row].setCount
        self.present(storyBoard, animated: true, completion: nil)
    }

}


extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let viewWidth = collectionView.frame.size.width
        return UIEdgeInsets(top: 10 , left: viewWidth * 0.02, bottom: 10, right: viewWidth * 0.02)
    }
    
    // cellのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("DEBUG_PRINT: collectionViewLayout")
        return CGSize(width: 170, height: 170)

    }

}

