//
//  QRScanVC.swift
//  MovieTime
//
//  Created by כפיר פנירי on 18/08/2020.
//  Copyright © 2020 Kfir. All rights reserved.
//

import UIKit
import AVFoundation


protocol QRCodeScannerDelegate {
    func didScanNewMovie(movie:MovieCore)
}

class QRScanVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    
    @IBOutlet weak var qrScanView: UIView!
    
         var delegate:QRCodeScannerDelegate?
         var captureSession:AVCaptureSession!
         var videoPreviewLayer:AVCaptureVideoPreviewLayer!
         var qrCodeFrameView:UIView?
         
         let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                   AVMetadataObject.ObjectType.code39,
                                   AVMetadataObject.ObjectType.code39Mod43,
                                   AVMetadataObject.ObjectType.code93,
                                   AVMetadataObject.ObjectType.code128,
                                   AVMetadataObject.ObjectType.ean8,
                                   AVMetadataObject.ObjectType.ean13,
                                   AVMetadataObject.ObjectType.aztec,
                                   AVMetadataObject.ObjectType.pdf417,
                                   AVMetadataObject.ObjectType.qr]
         
         //MARK: - LIFECYCLE -
         override func viewDidLoad() {
             super.viewDidLoad()
             
             initCaptureDeviceToQRCodeReader()
         }
         override func viewWillAppear(_ animated: Bool) {
             super.viewWillAppear(animated)
             
             if (captureSession?.isRunning == false) {
                 captureSession.startRunning()
             }
         }
         
         override func viewWillDisappear(_ animated: Bool) {
             super.viewWillDisappear(animated)
             
             if (captureSession?.isRunning == true) {
                 captureSession.stopRunning()//VERY SLOW ON SIMULATOR
             }
         }
         
         //MARK: - CONTROLLER FUNCTIONS -
         
         func initCaptureDeviceToQRCodeReader(){
             
             captureSession = AVCaptureSession()
             
             guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
             let videoInput: AVCaptureDeviceInput
             
             do {
                 videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
             } catch {
                 return
             }
             
             if (captureSession.canAddInput(videoInput)) {
                 captureSession.addInput(videoInput)
             } else {
                 self.presentSystemAlert(title: "Oops", message: "Your device does not support camera", btnTitle: "OK", action: {})
                 return
             }
             
             let metadataOutput = AVCaptureMetadataOutput()
             
             if (captureSession.canAddOutput(metadataOutput)) {
                 captureSession.addOutput(metadataOutput)
                 
                 metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                 metadataOutput.metadataObjectTypes = [.qr]
             } else {
                 self.presentSystemAlert(title: "Oops", message: "Your device does not support camera", btnTitle: "OK", action: {})
                 return
             }
             
             // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
             videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
             videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
             videoPreviewLayer.frame = view.layer.bounds
             
             qrScanView.layer.addSublayer(videoPreviewLayer)
             
             // Start video capture.
             captureSession.startRunning()
             
             // Initialize QR Code Frame to highlight the QR code
             qrCodeFrameView = UIView()
             
             if let qrCodeFrameView = qrCodeFrameView {
                 qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                 qrCodeFrameView.layer.borderWidth = 2
                 qrScanView.addSubview(qrCodeFrameView)
                 qrScanView.bringSubviewToFront(qrCodeFrameView)
             }
         }
         
         private func presentUncompatibleQRCodeAlert(){
             self.presentSystemAlert(title: "Oops", message: "QR code not compatible with Movies", btnTitle: "OK", action: {
                 self.refreshQRScanner()
             })
             
         }
         private func refreshQRScanner(){
             self.qrCodeFrameView?.frame = CGRect.zero
             self.captureSession?.startRunning()
         }
         
         // MARK: - AVCaptureMetadataOutputObjectsDelegate -
         func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
             
             print("hi")
             // Check if the metadataObjects array is not nil and it contains at least one object.
             if metadataObjects.count == 0 {
                 qrCodeFrameView?.frame = CGRect.zero
                 // Stop video capture.
                 captureSession?.stopRunning()
                 
                 presentUncompatibleQRCodeAlert()
                 return
             }
             
             // Get the metadata object.
             let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
             
             if supportedCodeTypes.contains(metadataObj.type) {
                 // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
                 let barCodeObject = videoPreviewLayer.transformedMetadataObject(for: metadataObj)
                 qrCodeFrameView?.frame = barCodeObject!.bounds
                 
                 if metadataObj.stringValue != nil {
                     // Stop video capture.
                     captureSession?.stopRunning()
                     
                     if let json = metadataObj.stringValue?.convertToDictionary(){
                         
                         let context = CoreDataManager.shared.context
                         
                         let movie = MovieCore(json: json)

                             //save movie in database
                             try? context.save()
                             //pop current vc
                             DispatchQueue.main.async {
                                 self.presentSystemAlert(title: "Congratulations", message: "\(movie.title!) Added to your collection", btnTitle: "OK", action: {
                                     //new movie scanned, add it to a collection
                                     self.delegate?.didScanNewMovie(movie: movie)
                                     self.navigationController?.popViewController(animated: true)
                                 })
                             }
                             return
                     }
                     return
                         
                         //cannot get context
                         presentUncompatibleQRCodeAlert()
                 }
                 //cannot convert string to dictionary
                 presentUncompatibleQRCodeAlert()
                 
                 print("QR=\(String(describing: metadataObj.stringValue))")
             }
         }
     }


     extension UIViewController{
         func presentSystemAlert(title:String, message:String, btnTitle:String, action:@escaping ()->()){
             let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
             alert.addAction(UIAlertAction.init(title: btnTitle, style: .default, handler: { (UIAlertAction) in
                 action()
             }))
             self.present(alert, animated: true, completion: nil)
             
         }
     }

     extension String{
         func convertToDictionary() -> [String: Any]? {
             if let data = self.data(using: .utf8) {
                 do {
                     return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                 } catch {
                     print(error.localizedDescription)
                 }
             }
             return nil
         }
     }
