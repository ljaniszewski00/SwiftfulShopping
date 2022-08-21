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
    
    @State private var isCardNumberTextFieldFocused: Bool = false
    @State private var isCardHolderNameTextFieldFocused: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                Text("Choose default payment method:")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(PaymentMethod.allCases, id: \.self) { paymentMethod in
                        HStack(spacing: 10) {
                            Button(action: {
                                profileViewModel.changeDefaultPaymentMethod(newDefaultPaymentMethod: paymentMethod)
                            }, label: {
                                if profileViewModel.profile.defaultPaymentMethod == paymentMethod {
                                    Circle()
                                        .foregroundColor(.accentColor)
                                        .frame(width: 25)
                                } else {
                                    Circle()
                                        .stroke(lineWidth: 3)
                                        .foregroundColor(.accentColor)
                                        .frame(width: 25)
                                }
                            })
                            
                            HStack {
                                Text(paymentMethod.rawValue)
                                    .font(.system(size: 20, weight: .regular, design: .rounded))
                                if paymentMethod == .applePay {
                                    Image("apple_pay_logo")
                                        .resizable()
                                }
                            }
                        }
                        
                        if paymentMethod == .creditCard && profileViewModel.profile.defaultPaymentMethod == .creditCard {
                            buildCreditCardSection()
                                .padding(.bottom)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .padding(.bottom, 40)
        }
        .navigationTitle("Payment Details")
        .onAppear {
            if let userCard = profileViewModel.profile.creditCard {
                paymentDetailsViewModel.cardNumber = userCard.cardNumber
                paymentDetailsViewModel.newDate = Date().getDateFrom(userCard.validThru) ?? Date()
                paymentDetailsViewModel.cardHolderName = userCard.cardholderName
            } else {
                paymentDetailsViewModel.initializeDataForNoCard()
                profileViewModel.profile.creditCard = paymentDetailsViewModel.createNewCard()
            }
        }
    }
    
    @ViewBuilder
    func buildCreditCardSection() -> some View {
        VStack(alignment: .center, spacing: 20) {
            VStack(alignment: .leading) {
                HStack {
                    Text(paymentDetailsViewModel.cardCompany.rawValue)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                    Image("card_chip")
                        .resizable()
                        .frame(width: 40, height: 30)
                }
                .padding(.bottom, 30)
                
                Spacer()
                
                Text(paymentDetailsViewModel.cardNumber)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(Color.white)
                
                Spacer()
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text("CARD HOLDER")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(Color.gray)
                        
                        Text(paymentDetailsViewModel.cardHolderName)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(Color.white)
                        
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("EXPIRES")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(Color.gray)
                        Text(paymentDetailsViewModel.validThruDate)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(Color.white)
                    }
                }
            }
            .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.85, height: 210)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5481430292, green: 0, blue: 0.4720868468, alpha: 1)), Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(15)
            
            Button {
                withAnimation {
                    paymentDetailsViewModel.editingCardData.toggle()
                }
            } label: {
                Text(paymentDetailsViewModel.editingCardData ? "Save" : "Edit Card Data")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
            }
            .buttonStyle(CustomButton())
            .contentShape(Rectangle())
            .if(paymentDetailsViewModel.editingCardData) {
                $0
                    .disabled(paymentDetailsViewModel.newCardInfoNotValidated)
            }
            
            if paymentDetailsViewModel.editingCardData {
                VStack(alignment: .leading, spacing: 15) {
                    RectangleCustomTextField(
                        textFieldProperty: "Card Number",
                        textFieldKeyboardType: .numberPad,
                        text: $paymentDetailsViewModel.cardNumber,
                        isFocusedParentView: $isCardNumberTextFieldFocused)
                    
                    RectangleCustomTextField(
                        textFieldProperty: "Card Holder Name",
                        text: $paymentDetailsViewModel.cardHolderName,
                        isFocusedParentView: $isCardHolderNameTextFieldFocused)
                    .padding(.bottom, 10)
                    
                    VStack(alignment: .leading) {
                        Text("Valid Thru")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.accentColor)
                        
                        DatePicker(
                            "",
                            selection: $paymentDetailsViewModel.newDate,
                            in: paymentDetailsViewModel.pickerDateRange,
                            displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                    }
                }
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
