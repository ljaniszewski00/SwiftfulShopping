//
//  OrderDetailsView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 25/06/2022.
//

import SwiftUI
import texterify_ios_sdk

struct OrderDetailsView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var ordersViewModel: OrdersViewModel
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @StateObject private var orderDetailsViewModel: OrderDetailsViewModel = OrderDetailsViewModel()
    @StateObject private var stripeViewModel: StripeViewModel = StripeViewModel()
    
    @StateObject private var errorManager: ErrorManager = ErrorManager.shared
    
    @State private var showProductsList: Bool = true

    var order: Order
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(TexterifyManager.localisedString(key: .orderDetailsView(.orderDate)))
                            .font(.ssTitle2)
                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                        
                        Text(Date.getDayMonthYearFrom(date: order.orderDate))
                            .font(.ssTitle3)
                            .foregroundColor(.accentColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(TexterifyManager.localisedString(key: .orderDetailsView(.customerInfo)))
                            .font(.ssTitle2)
                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                        
                        Text(order.clientDescription)
                            .font(.ssCallout)
                            .foregroundColor(.accentColor)
                            
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(TexterifyManager.localisedString(key: .orderDetailsView(.addressInfo)))
                            .font(.ssTitle2)
                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                        
                        Text(order.addressDescription)
                            .font(.ssCallout)
                            .foregroundColor(.accentColor)
                            
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(TexterifyManager.localisedString(key: .orderDetailsView(.status)))
                            .font(.ssTitle2)
                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                            
                        Text(order.status.rawValue)
                            .font(.ssTitle3)
                            .foregroundColor(.accentColor)
                    }
                    
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 15) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(TexterifyManager.localisedString(key: .orderDetailsView(.paymentStatus)))
                                    .font(.ssTitle2)
                                    .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                                    
                                Text(order.payed ?
                                     TexterifyManager.localisedString(key: .ordersView(.paymentStatusPayed)) : TexterifyManager.localisedString(key: .ordersView(.paymentStatusNotPayed)))
                                    .font(.ssTitle3)
                                    .foregroundColor(order.payed ? .accentColor : .red)
                            }
                            
                            if order.payed {
                                if let paymentID = order.paymentID {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(TexterifyManager.localisedString(key: .orderDetailsView(.paymentID)))
                                            .font(.ssTitle2)
                                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                                            
                                        Text(paymentID)
                                            .font(.ssTitle3)
                                            .foregroundColor(.accentColor)
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        if !order.payed {
                            Button {
                                guard let profile = profileViewModel.profile,
                                      let currency = orderDetailsViewModel.currencyCode else { return }
                                
                                stripeViewModel.prepareFirebaseForPayment(profileID: profile.id,
                                                                          amount: order.totalCost,
                                                                          currency: currency) { result in
                                    switch result {
                                    case .success:
                                        break
                                    case .failure(let error):
                                        errorManager.generateCustomError(errorType: .paymentFailedError,
                                                                         additionalErrorDescription: error.localizedDescription)
                                    }
                                }
                            } label: {
                                Text(TexterifyManager.localisedString(key: .orderDetailsView(.payButton)))
                            }
                            .buttonStyle(CustomButton())
                            .frame(width: 160)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Button(action: {
                            showProductsList.toggle()
                        }, label: {
                            HStack(spacing: 20) {
                                Text("\(TexterifyManager.localisedString(key: .orderDetailsView(.products))) (\(orderDetailsViewModel.orderAllProductsQuantity ?? 0))")
                                    .font(.ssTitle2)
                                    .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                                Image(systemName: showProductsList ? "chevron.up" : "chevron.down")
                            }
                        })
                        
                        if showProductsList {
                            if let productsWithQuantity = orderDetailsViewModel.orderProductsWithQuantity {
                                VStack(alignment: .center, spacing: 20) {
                                    ForEach(Array(productsWithQuantity.keys).sorted { $0.name < $1.name },
                                            id: \.self) { product in
                                        BasicProductTile(product: product, productQuantity: productsWithQuantity[product])
                                        Divider()
                                    }
                                }
                            }
                        }
                    }
                    
                    if !order.appliedDiscountsCodesWithValue.isEmpty {
                        VStack {
                            ForEach(Array(order.appliedDiscountsCodesWithValue.keys), id: \.self) { discountCode in
                                if let discountValue = order.appliedDiscountsCodesWithValue[discountCode] {
                                    HStack {
                                        Text(discountCode)
                                            .font(.ssCallout)
                                            .foregroundColor(.ssDarkGray)
                                        
                                        Spacer()
                                        
                                        Text("-\(discountValue, specifier: "%.2f")%")
                                            .font(.ssCallout)
                                            .foregroundColor(.accentColor)
                                    }
                                }
                            }
                        }
                    }
                    
                    VStack {
                        HStack {
                            Text(TexterifyManager.localisedString(key: .orderDetailsView(.shippingMethodPrice)))
                                .font(.ssCallout)
                                .foregroundColor(.ssDarkGray)
                            
                            Spacer()
                            
                            Text(LocaleManager.client.formatPrice(price: order.shippingCost) ?? "")
                                .font(.ssTitle3)
                                .foregroundColor(.accentColor)
                        }
                        
                        HStack {
                            Text(TexterifyManager.localisedString(key: .orderDetailsView(.paymentMethodPrice)))
                                .font(.ssCallout)
                                .foregroundColor(.ssDarkGray)
                            
                            Spacer()
                            
                            Text(LocaleManager.client.formatPrice(price: order.paymentCost) ?? "")
                                .font(.ssTitle3)
                                .foregroundColor(.accentColor)
                        }
                    }
                    .padding(.top)
                    
                    HStack {
                        Text(TexterifyManager.localisedString(key: .orderDetailsView(.totalPrice)))
                            .font(.ssTitle2)
                            .foregroundColor(colorScheme == .light ? .black : .ssWhite)
                        
                        Spacer()
                            
                        Text(LocaleManager.client.formatPrice(price: order.totalCost) ?? "")
                            .font(.ssTitle3)
                            .foregroundColor(.accentColor)
                    }
                }
                .padding()
            }
            
            Spacer()
            
            VStack(spacing: 15) {
                Button {
                    withAnimation {
                        profileViewModel.shouldPresentReturnCreationView = true
                    }
                } label: {
                    Text(TexterifyManager.localisedString(key: .orderDetailsView(.returnProductsButton)))
                        .font(.ssButton)
                }
                .buttonStyle(CustomButton())
                .contentShape(Rectangle())
                
                Button {
                    withAnimation {
                        profileViewModel.shouldPresentOrderRateView = true
                    }
                } label: {
                    Text(TexterifyManager.localisedString(key: .orderDetailsView(.rateOrderButton)))
                        .font(.ssButton)
                }
                .buttonStyle(CustomButton(textColor: .accentColor, onlyStroke: true))
                .contentShape(Rectangle())
            }
            .padding()
            
            NavigationLink(destination: OrderRateView(order: order)
                                            .environmentObject(tabBarStateManager)
                                            .environmentObject(profileViewModel),
                           isActive: $profileViewModel.shouldPresentOrderRateView) { EmptyView() }
                .isDetailLink(false)
            
            NavigationLink(destination: ReturnCreationView(order: order)
                                            .environmentObject(tabBarStateManager)
                                            .environmentObject(profileViewModel),
                           isActive: $profileViewModel.shouldPresentReturnCreationView) { EmptyView() }
                .isDetailLink(false)
            
            NavigationLink(destination: OrderPaymentView(profileID: profileViewModel.profile?.id ?? "",
                                                         orderID: order.id )
                                            .environmentObject(tabBarStateManager)
                                            .environmentObject(orderDetailsViewModel)
                                            .environmentObject(stripeViewModel),
                           isActive: $orderDetailsViewModel.shouldPresentOrderPaymentView) { EmptyView() }
                .isDetailLink(false)
            
        }
        .padding(.bottom, tabBarStateManager.screenBottomPaddingForViews)
        .modifier(LoadingIndicatorModal(isPresented: $orderDetailsViewModel.showLoadingModal))
        .modifier(LoadingIndicatorModal(isPresented: $stripeViewModel.showLoadingModal))
        .onChange(of: stripeViewModel.canPresentOrderPaymentView) { canPresentOrderPaymentView in
            if canPresentOrderPaymentView {
                orderDetailsViewModel.shouldPresentOrderPaymentView = true
            }
        }
        .onChange(of: stripeViewModel.paymentData) { paymentData in
            guard let paymentData = paymentData else { return }
            
            if !paymentData.isEmpty {
                stripeViewModel.preparePaymentSheet()
            }
        }
        .navigationTitle("\(TexterifyManager.localisedString(key: .orderDetailsView(.navigationTitle))) \(order.id)")
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
            orderDetailsViewModel.order = order
        }
    }
}

struct OrderDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let profileViewModel = ProfileViewModel()
        let ordersViewModel = OrdersViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                OrderDetailsView(order: Order.demoOrders[1])
                    .environmentObject(tabBarStateManager)
                    .environmentObject(profileViewModel)
                    .environmentObject(ordersViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
