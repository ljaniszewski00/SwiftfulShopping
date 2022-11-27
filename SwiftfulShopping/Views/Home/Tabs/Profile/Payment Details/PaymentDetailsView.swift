//
//  PaymentDetailsView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 19/06/2022.
//

import SwiftUI
import texterify_ios_sdk

struct PaymentDetailsView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var paymentDetailsViewModel: PaymentDetailsViewModel = PaymentDetailsViewModel()
    @StateObject var errorManager = ErrorManager.shared
    
    @State private var isCardNumberTextFieldFocused: Bool = false
    @State private var isCardHolderNameTextFieldFocused: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 25) {
                Text(TexterifyManager.localisedString(key: .paymentDetailsView(.chooseDefaultPaymentMethod)))
                    .font(.ssTitle1)
                    .fixedSize(horizontal: false, vertical: true)
                
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(PaymentMethod.allCases, id: \.self) { paymentMethod in
                        HStack(spacing: 10) {
                            Button(action: {
                                if profileViewModel.profile?.defaultPaymentMethod != paymentMethod {
                                    paymentDetailsViewModel.showLoadingModal = true
                                    profileViewModel.changeDefaultPaymentMethod(newDefaultPaymentMethod: paymentMethod) { result in
                                        paymentDetailsViewModel.showLoadingModal = false
                                        switch result {
                                        case .success:
                                            break
                                        case .failure(let error):
                                            errorManager.generateCustomError(errorType:
                                                    .changeDefaultPaymentMethodError,
                                                                             additionalErrorDescription: error.localizedDescription)
                                        }
                                    }
                                }
                            }, label: {
                                HStack(spacing: 15) {
                                    if profileViewModel.profile?.defaultPaymentMethod == paymentMethod {
                                        Circle()
                                            .foregroundColor(.accentColor)
                                            .frame(width: 25)
                                    } else {
                                        Circle()
                                            .stroke(lineWidth: 3)
                                            .foregroundColor([.cash, .applePay].contains(paymentMethod) ? .ssDarkGray : .accentColor)
                                            .frame(width: 25)
                                    }
                                    
                                    HStack(spacing: 0) {
                                        Text(paymentMethod.rawValue)
                                            .font(.ssTitle3)
                                            .foregroundColor([.cash, .applePay].contains(paymentMethod) ? .ssDarkGray : (colorScheme == .light ? .black : .ssWhite))
                                        
                                        if paymentMethod == .applePay {
                                            Image(AssetsNames.applePayLogo)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        }
                                    }
                                    
                                    if [.cash, .applePay].contains(paymentMethod) {
                                        Text(TexterifyManager.localisedString(key: .common(.commingSoon)))
                                            .font(.ssCallout)
                                            .padding(5)
                                            .background {
                                                RoundedRectangle(cornerRadius: 4)
                                                    .stroke()
                                                    .foregroundColor(.accentColor)
                                            }
                                    }
                                }
                            })
                            .frame(height: 40)
                            .if([.cash, .applePay].contains(paymentMethod)) {
                                $0
                                    .allowsHitTesting(false)
                            }
                            
                            Spacer()
                        }
                        
                        if paymentMethod == .creditCard && profileViewModel.profile?.defaultPaymentMethod == .creditCard {
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
        .modifier(LoadingIndicatorModal(isPresented:
                                            $paymentDetailsViewModel.showLoadingModal))
        .navigationTitle(TexterifyManager.localisedString(key: .paymentDetailsView(.navigationTitle)))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.accentColor)
                }
            }
        }
        .onAppear {
            profileViewModel.fetchCreditCard()
            if let profile = profileViewModel.profile, let userCard = profile.creditCard {
                paymentDetailsViewModel.cardNumber = userCard.cardNumber
                paymentDetailsViewModel.newDate = Date().getDateFrom(userCard.validThru) ?? Date()
                paymentDetailsViewModel.cardHolderName = userCard.cardholderName
            } else {
                paymentDetailsViewModel.initializeDataForNoCard()
            }
        }
        .onChange(of: paymentDetailsViewModel.cardNumber) { newValue in
            if newValue.count > 16 {
                paymentDetailsViewModel.cardNumber = String(newValue.prefix(16))
            }
        }
    }
    
    @ViewBuilder
    func buildCreditCardSection() -> some View {
        VStack(alignment: .center, spacing: 20) {
            VStack(alignment: .leading) {
                HStack {
                    if let cardCompanyImageName = paymentDetailsViewModel.cardCompanyImageName {
                        Image(cardCompanyImageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 40)
                    }
                    
                    Spacer()
                    
                    Image(AssetsNames.cardChip)
                        .resizable()
                        .frame(width: 40, height: 30)
                }
                .padding(.bottom, 30)
                
                Spacer()
                
                Text(paymentDetailsViewModel.cardNumber.separate(every: 4, with: " "))
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(Color.ssWhite)
                
                Spacer()
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text(TexterifyManager.localisedString(key: .paymentDetailsView(.cardHolder)))
                            .font(.ssCaption1)
                            .foregroundColor(Color.ssGray)
                        Text(paymentDetailsViewModel.cardHolderName)
                            .font(.ssCallout)
                            .foregroundColor(Color.ssWhite)
                        
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text(TexterifyManager.localisedString(key: .paymentDetailsView(.expires)))
                            .font(.ssCaption1)
                            .foregroundColor(Color.ssGray)
                        Text(paymentDetailsViewModel.validThruDate)
                            .font(.ssCallout)
                            .foregroundColor(Color.ssWhite)
                    }
                }
            }
            .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.85, height: 210)
            .padding()
            .background {
                Image(AssetsNames.cardImageName)
                    .resizable()
            }
            .cornerRadius(15)
            
            if paymentDetailsViewModel.editingCardData {
                Button {
                    withAnimation {
                        profileViewModel.editCardData(cardNumber: paymentDetailsViewModel.cardNumber,
                                                      validThru: paymentDetailsViewModel.validThruDate,
                                                      cardHolderName: paymentDetailsViewModel.cardHolderName)
                        paymentDetailsViewModel.editingCardData = false
                    }
                } label: {
                    Text(TexterifyManager.localisedString(key: .paymentDetailsView(.editCardDataSave)))
                        .font(.ssButton)
                }
                .buttonStyle(CustomButton())
                .contentShape(Rectangle())
                .disabled(paymentDetailsViewModel.newCardInfoNotValidated)
            } else {
                Button {
                    withAnimation {
                        paymentDetailsViewModel.editingCardData = true
                    }
                } label: {
                    Text(TexterifyManager.localisedString(key: .paymentDetailsView(.editCardDataEditData)))
                        .font(.ssButton)
                }
                .buttonStyle(CustomButton())
                .contentShape(Rectangle())
            }
            
            
            
            if paymentDetailsViewModel.editingCardData {
                VStack(alignment: .leading, spacing: 15) {
                    RectangleCustomTextField(
                        textFieldProperty: TexterifyManager.localisedString(key: .paymentDetailsView(.cardNumberTextField)),
                        textFieldKeyboardType: .numberPad,
                        text: $paymentDetailsViewModel.cardNumber,
                        isFocusedParentView: $isCardNumberTextFieldFocused)
                    
                    RectangleCustomTextField(
                        textFieldProperty: TexterifyManager.localisedString(key: .paymentDetailsView(.cardHolderNameTextField)),
                        text: $paymentDetailsViewModel.cardHolderName,
                        isFocusedParentView: $isCardHolderNameTextFieldFocused)
                    .padding(.bottom, 10)
                    
                    VStack(alignment: .leading) {
                        Text(TexterifyManager.localisedString(key: .paymentDetailsView(.validThruLabel)))
                            .font(.ssTitle3)
                            .foregroundColor(.accentColor)
                        
                        CustomDatePicker(includeDayPicking: false,
                                         datePicked: $paymentDetailsViewModel.newDate)
                    }
                }
            }
        }
    }
}

struct PaymentDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                PaymentDetailsView()
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
