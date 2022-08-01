//
//  PaymentDetailsView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import SwiftUI

struct PaymentDetailsView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    @StateObject private var paymentDetailsViewModel: PaymentDetailsViewModel = PaymentDetailsViewModel()
    
    @State private var editCardData: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            List {
                ForEach(PaymentMethod.allCases, id: \.self) { paymentMethod in
                    Section(header: Text(paymentMethod.rawValue)
                        .font(.system(size: 22, weight: .bold, design: .rounded))) {
                            if paymentMethod == .cash {
                                
                            } else if paymentMethod == .creditCard {
                                HStack {
                                    Spacer()
                                    VStack(alignment: .center) {
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text(paymentDetailsViewModel.cardCompany.rawValue)
                                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                                    .foregroundColor(.white)
                                                Spacer()
                                                Image("card_chip")
                                                    .resizable()
                                                    .frame(width: 40, height: 30)
                                            }
                                            .padding(.bottom, 30)
                                            
                                            if editCardData {
                                                TextField(paymentDetailsViewModel.newCardNumber, text: $paymentDetailsViewModel.newCardNumber)
                                                    .textFieldStyle(.roundedBorder)
                                            } else {
                                                Text(paymentDetailsViewModel.newCardNumber)
                                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                                    .foregroundColor(.white)
                                                    .padding(.bottom, 5)
                                            }
                                            
                                            HStack {
                                                Text("Valid Thru")
                                                    .font(.system(size: 14, design: .rounded))
                                                    .fixedSize(horizontal: false, vertical: true)
                                                    .frame(width: 50)
                                                    .foregroundColor(.white)
                                                if editCardData {
                                                    TextField(paymentDetailsViewModel.newValidThruDate, text: $paymentDetailsViewModel.newValidThruDate)
                                                        .textFieldStyle(.roundedBorder)
                                                } else {
                                                    Text(paymentDetailsViewModel.newValidThruDate)
                                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                                        .foregroundColor(.white)
                                                }
                                            }
                                            .padding(.bottom, 10)
                                            
                                            if editCardData {
                                                TextField(paymentDetailsViewModel.newCardholderName, text: $paymentDetailsViewModel.newCardholderName)
                                                    .textFieldStyle(.roundedBorder)
                                            } else {
                                                Text(paymentDetailsViewModel.newCardholderName)
                                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                                    .foregroundColor(.white)
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding(.all, 20)
                                        .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.86, height: ScreenBoundsSupplier.shared.getScreenHeight() * 0.24)
                                        .background(LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color(uiColor: UIColor(rgb: 0x7CEA9C))]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .cornerRadius(15)
                                        .padding(.bottom, 20)
                                        
                                        if editCardData {
                                            Button {
                                                withAnimation {
                                                    if profileViewModel.profile.creditCard == nil {
                                                        profileViewModel.addNewCard(card: paymentDetailsViewModel.createNewCard())
                                                    } else {
                                                        profileViewModel.editCardData(cardNumber: paymentDetailsViewModel.newCardNumber, validThru: paymentDetailsViewModel.newValidThruDate, cardholderName: paymentDetailsViewModel.newCardholderName)
                                                    }
                                                    editCardData.toggle()
                                                }
                                            } label: {
                                                Text("Finish")
                                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                            }
                                            .buttonStyle(CustomButton(buttonWidthMultiplier: 0.86))
                                            .contentShape(Rectangle())
                                            .disabled(paymentDetailsViewModel.newCardInfoNotValidated)
                                        } else {
                                            Button {
                                                withAnimation {
                                                    editCardData.toggle()
                                                }
                                            } label: {
                                                Text("Edit Card Data")
                                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                            }
                                            .buttonStyle(CustomButton(buttonWidthMultiplier: 0.86))
                                            .contentShape(Rectangle())
                                        }
                                    }
                                    
                                    Spacer()
                                }
                            } else if paymentMethod == .applePay {
                                HStack {
                                    Image("apple_pay_logo")
                                        .resizable()
                                        .frame(width: 280, height: 150)
                                    Spacer()
                                }
                            }
                            
                            Button {
                                withAnimation {
                                    profileViewModel.changeDefaultPaymentMethod(newDefaultPaymentMethod: paymentMethod)
                                }
                            } label: {
                                Text("Choose as default")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                            }
                            .buttonStyle(CustomButton(textColor: profileViewModel.profile.defaultPaymentMethod == paymentMethod ? .white : .accentColor,
                                                      onlyStroke: profileViewModel.profile.defaultPaymentMethod != paymentMethod,
                                                      buttonWidthMultiplier: 0.86))
                            .contentShape(Rectangle())
                            .padding(.leading, 8)
                    }
                }
            }
            .listStyle(.sidebar)
        }
        .navigationTitle("Payment Details")
        .scrollOnOverflow(showScrollIndicators: false)
        .onAppear {
            if let userCard = profileViewModel.profile.creditCard {
                paymentDetailsViewModel.newCardNumber = userCard.cardNumber
                paymentDetailsViewModel.newValidThruDate = userCard.validThru
                paymentDetailsViewModel.newCardholderName = userCard.cardholderName
            } else {
                paymentDetailsViewModel.initializeDataForNoCard()
            }
        }
    }
}

struct PaymentDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager(isGuestDefault: true)
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                PaymentDetailsView()
                    .environmentObject(authStateManager)
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
                        authStateManager.isGuest = false
                        authStateManager.isLogged = true
                    }
            }
        }
    }
}
