//
//  AssetWriter.swift
//  FACS-Recorder
//
//  Created by 권영진 on 23/11/2018.
//  Copyright © 2018 권영진. All rights reserved.

import UIKit
import Foundation
import AVFoundation
import ReplayKit

class AssetWriter {
    public var frameCounter: Int
    private var assetWriter: AVAssetWriter?
    private var videoInput: AVAssetWriterInput?
    private var audioInput: AVAssetWriterInput?
    private var fileName: String
    private let fileExt: String = "mp4"
    private var filePathUrl: URL!
    private struct Status {
        var status: AVAssetWriter.Status
        func string () -> String{
            switch status{
            case .cancelled:
                return "Cancelled"
            case .unknown:
                return "Unknown"
            case .writing:
                return "Writing"
            case .completed:
                return "Completed"
            case .failed:
                return "Failed"
            }
        }
    }
    
    let writeQueue = DispatchQueue(label: "writeQueue")
    
    init(fileName: String) {
        self.fileName = fileName
        frameCounter = 0
    }
    
    deinit {
        print("Deallocate AssetWriter")
    }
    
    private func getFilePathReady () -> Bool {
        
        let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        //print ("path "+documentDir)
        let documentUrl = NSURL(fileURLWithPath: documentDir)
        if let fullpathUrl = documentUrl.appendingPathComponent(fileName)?.appendingPathExtension(fileExt) {
            if FileManager.default.fileExists(atPath: fullpathUrl.path) {
                //print("FILE Exists")
                do {
                    try FileManager.default.removeItem(atPath: fullpathUrl.path)
                } catch {
                    print("Failed to remove existing file: "+fullpathUrl.path)
                    return false
                }
                print("Successfully removed "+fullpathUrl.path)
                
            }
            filePathUrl = fullpathUrl
            return true
        }
        return false
    }
    
    private func setupWriter(buffer: CMSampleBuffer) -> Bool{
            
        // Get file path url, and makes sure there's no same named file exists.
        if !getFilePathReady(){
            return false
        }
        // Initialize Asset Writer
        self.assetWriter = try? AVAssetWriter(outputURL: filePathUrl, fileType: AVFileType.mp4)
        
        // Prepare Video Output settings
        let videoOutputSettings = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: UIScreen.main.bounds.width,
            AVVideoHeightKey: UIScreen.main.bounds.height,
            ] as [String : Any]
        self.videoInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: videoOutputSettings)
        self.videoInput?.expectsMediaDataInRealTime = true
        
        // Get Audio Buffer
        guard let format = CMSampleBufferGetFormatDescription(buffer),
            let stream = CMAudioFormatDescriptionGetStreamBasicDescription(format) else {
                print("Failed to setup audioInput")
                return false
        }
        // Prepare Audio Output Setting
        let audioOutputSettings = [
            AVFormatIDKey : kAudioFormatMPEG4AAC,
            AVNumberOfChannelsKey : stream.pointee.mChannelsPerFrame,
            AVSampleRateKey : stream.pointee.mSampleRate,
            AVEncoderBitRateKey : 64000
            ] as [String : Any]
        self.audioInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: audioOutputSettings)
        self.audioInput?.expectsMediaDataInRealTime = true
        
        // Pipe in Video & Audio Inputs to Writer
        if let videoInput = self.videoInput, (self.assetWriter?.canAdd(videoInput))! {
            self.assetWriter?.add(videoInput)
        }else{
            print("Failed to add video inpu")
            return false
        }
        
        if  let audioInput = self.audioInput, (self.assetWriter?.canAdd(audioInput))! {
            self.assetWriter?.add(audioInput)
        }
        else{
            print("Failed to add audio inpu")
            return false
        }
        // All went through OK?  Then return a OK sign.
        return true
    }
    
    func write(buffer: CMSampleBuffer, bufferType: RPSampleBufferType) {
        writeQueue.sync {
            if assetWriter == nil {
                if bufferType == .audioMic {
                    if !setupWriter(buffer: buffer){
                        return
                    }
                }
            }
            
            // Start a Writing Session
            let stat = Status(status: self.assetWriter!.status)
            if stat.status == .unknown {
                print("Start writing")
                frameCounter = 0
                let startTime = CMSampleBufferGetPresentationTimeStamp(buffer)
                self.assetWriter?.startWriting()
                self.assetWriter?.startSession(atSourceTime: startTime)
            } else if stat.status == .failed {
                print("assetWriter status: failed error: \(String(describing: self.assetWriter?.error))")
                return
            }
            
            // Append Video & Audio Input Buffer
            if CMSampleBufferDataIsReady(buffer) == true {
                if bufferType == .video {
                    if let videoInput = self.videoInput, videoInput.isReadyForMoreMediaData {
                        videoInput.append(buffer)
                        
                        // Stamp the current time
                        gCurrentTime = CMSampleBufferGetPresentationTimeStamp(buffer).seconds
                        frameCounter += 1
                    }
                } else if bufferType == .audioMic {
                    if let audioInput = self.audioInput, audioInput.isReadyForMoreMediaData {
                        audioInput.append(buffer)
                    }
                }
            }
        }
    }

//    func getCurrentTimeStamp(_ sampleBuffer: CMSampleBuffer) -> Double {
//        let timestampSeconds = CMSampleBufferGetPresentationTimeStamp(sampleBuffer) // Float64
//        return timestampSeconds.seconds // to Double
//    }
    
    // MARK - Finish
    
    public func finishWriting() {
        writeQueue.sync {
            let stat = Status(status: self.assetWriter!.status)
            print("AVASSET DEBUG: finishWriting  Before > status == "+stat.string())
            self.assetWriter?.finishWriting(completionHandler: {
                print("Finished writing movie file: "+self.filePathUrl.path)
                //UISaveVideoAtPathToSavedPhotosAlbum(self.filePath, nil, nil, nil)
            })
            // deallocate memory to re-run
            self.assetWriter = nil
        }
    }
}
