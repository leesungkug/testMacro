//
//  ScanPDFView.swift
//  testhaptic
//
//  Created by sungkug_apple_developer_ac on 9/29/24.
//

import SwiftUI
import UIKit
import PDFKit
import QuickLook

struct ScanPDFView: View {
    @State private var showImagePicker = false
    @State private var image: UIImage?
    @State private var pdfURL: URL?
    @State private var showQuickLook = false

    var body: some View {
        VStack {
            // 촬영한 이미지 보여주기
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                
                // PDF로 변환 버튼
                Button("Convert to PDF") {
                    convertToPDF(image: image)
                }
                .padding()
            }
            
            // 사진 촬영 버튼
            Button("사진 촬영") {
                showImagePicker = true
            }
            .padding()
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $image)
            }
            
            // PDF 보기
            if let pdfURL = pdfURL {
                Text("PDF created at: \(pdfURL.path)")
                Button("View PDF") {
                    showQuickLook.toggle()
                }
                .padding()
                .sheet(isPresented: $showQuickLook) {
                    QuickLookPreview(url: pdfURL)
                }
            }
        }
    }
    
    // 이미지 PDF로 변환하기
    func convertToPDF(image: UIImage) {
        let pdfData = NSMutableData()
        let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData)!
        
        // PDF 페이지 크기 설정 (A4 크기)
        let pdfPageBounds = CGRect(x: 0, y: 0, width: 595, height: 842)
        var mediaBox = pdfPageBounds
        
        guard let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil) else { return }
        
        pdfContext.beginPDFPage(nil)
        pdfContext.draw(image.cgImage!, in: pdfPageBounds)
        pdfContext.endPDFPage()
        pdfContext.closePDF()
        
        // 파일 저장 경로 설정
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("output.pdf")
        pdfData.write(to: fileURL, atomically: true)
        
        pdfURL = fileURL
    }
}

struct QuickLookPreview: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, url: url)
    }
    
    class Coordinator: NSObject, QLPreviewControllerDataSource {
        let parent: QuickLookPreview
        let url: URL
        
        init(_ parent: QuickLookPreview, url: URL) {
            self.parent = parent
            self.url = url
        }
        
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }
        
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return url as QLPreviewItem
        }
    }
}

// ImagePicker 구현: 사진 촬영 및 선택
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let picker = UIImagePickerController()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.image = selectedImage
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
#Preview {
    ScanPDFView()
}
