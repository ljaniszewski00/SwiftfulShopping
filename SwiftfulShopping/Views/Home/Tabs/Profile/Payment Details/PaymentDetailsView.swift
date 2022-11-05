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
                                            .foregroundColor(.accentColor)
                                            .frame(width: 25)
                                    }
                                    
                                    Text(paymentMethod.rawValue)
                                        .font(.ssTitle3)
                                        .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                                    if paymentMethod == .applePay {
                                        Image(AssetsNames.applePayLogo)
                                            .resizable()
                                    }
                                }
                            })
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
            if let profile = profileViewModel.profile, let userCard = profile.creditCard {
                paymentDetailsViewModel.cardNumber = userCard.cardNumber
                paymentDetailsViewModel.newDate = Date().getDateFrom(userCard.validThru) ?? Date()
                paymentDetailsViewModel.cardHolderName = userCard.cardholderName
            } else {
                paymentDetailsViewModel.initializeDataForNoCard()
                profileViewModel.addNewCard(card: paymentDetailsViewModel.createNewCard())
            }
        }
    }
    
    @ViewBuilder
    func buildCreditCardSection() -> some View {
        VStack(alignment: .center, spacing: 20) {
            VStack(alignment: .leading) {
                HStack {
                    Text(paymentDetailsViewModel.cardCompany.rawValue)
                        .font(.ssTitle3)
                        .foregroundColor(.ssWhite)
                    Spacer()
                    Image(AssetsNames.cardChip)
                        .resizable()
                        .frame(width: 40, height: 30)
                }
                .padding(.bottom, 30)
                
                Spacer()
                
                Text(paymentDetailsViewModel.cardNumber)
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
            .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#6BC3AA"),
                                                                   Color(hex: "#A5DFBC")]),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing))
            .cornerRadius(15)
            
            Button {
                withAnimation {
                    paymentDetailsViewModel.editingCardData.toggle()
                }
            } label: {
                Text(paymentDetailsViewModel.editingCardData ? TexterifyManager.localisedString(key: .paymentDetailsView(.editCardDataSave)) : TexterifyManager.localisedString(key: .paymentDetailsView(.editCardDataEditData)))
                    .font(.ssButton)
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
