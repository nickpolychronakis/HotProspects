//
//  MeView.swift
//  HotProspects
//
//  Created by NICK POLYCHRONAKIS on 15/12/19.
//  Copyright © 2019 NICK POLYCHRONAKIS. All rights reserved.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct MeView: View {
    
    @State private var name = "Anonymous"
    @State private var emailAddress = "you@yoursite.com"
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        let nameWrapped = Binding(
            get: {
                self.name
            }, set: {
                UserDefaults.standard.set($0, forKey: "UserName")
                self.name = $0
            })
        let emailWrapped = Binding(
            get: {
                self.emailAddress
            }, set: {
                UserDefaults.standard.set($0, forKey: "UserEmail")
                self.emailAddress = $0
            })
        return VStack {
            TextField("Name", text: nameWrapped)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textContentType(.name)
                .font(.title)
                .padding(.horizontal)
            
            TextField("Email address", text: emailWrapped)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textContentType(.emailAddress)
                .font(.title)
                .padding([.horizontal,.bottom])
            
            Image(uiImage: generateQRCode(from: "\(name)\n\(emailAddress)"))
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                
            
            Spacer()
        }
        .navigationBarTitle("Your code")
        .onAppear {
            self.name = UserDefaults.standard.string(forKey: "UserName") ?? ""
            self.emailAddress = UserDefaults.standard.string(forKey: "UserEmail") ?? ""
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
