//
//  OrderCreationSummaryView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 30/07/2022.
//

import SwiftUI
import texterify_ios_sdk

struct OrderCreationSummaryView: View {
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var orderCreationViewModel: OrderCreationViewModel
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @StateObject private var stripeViewModel: StripeViewModel = StripeViewModel()
    @StateObject var errorManager = ErrorManager.shared
    
    @State private var isCouponTextFieldFocused: Bool = false
    
    var body: some View {
        VStack {
            StepsView(stepsNumber: 4, activeStep: 3)
                .padding(.vertical)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(TexterifyManager.localisedString(key: .orderCreationSummaryView(.consigneeData)))
                            .font(.ssTitle2)
                        
                        Text(TexterifyManager.localisedString(key: .orderCreationSummaryView(.thisWillBeTheDeliveryAddress)))
                            .font(.ssCallout)
                            .foregroundColor(.ssDarkGray)
                            .padding(.bottom, 15)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(profileViewModel.profile?.fullName ?? "")
                                .font(.ssTitle3)
                            Text(orderCreationViewModel.defaultAddress)
                                .font(.ssCallout).fontWeight(.regular)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text(TexterifyManager.localisedString(key: .orderCreationSummaryView(.shippingMethod)))
                            .font(.ssTitle2)
                        
                        HStack {
                            Text(orderCreationViewModel.choosenShippingMethod?.rawValue ?? "")
                                .font(.ssTitle3)
                                .foregroundColor(.accentColor)
                            
                            if let formattedShippingMethodPrice = orderCreationViewModel.formattedShippingPrice {
                                Text(formattedShippingMethodPrice)
                                    .font(.ssCallout)
                                    .foregroundColor(.ssDarkGray)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text(TexterifyManager.localisedString(key: .orderCreationSummaryView(.paymentMethod)))
                            .font(.ssTitle2)
                        
                        HStack {
                            Text(orderCreationViewModel.choosenPaymentMethod?.rawValue ?? "")
                                .font(.ssTitle3)
                                .foregroundColor(.accentColor)
                            
                            if let formattedPaymentMethodPrice = orderCreationViewModel.formattedPaymentPrice {
                                Text(formattedPaymentMethodPrice)
                                    .font(.ssCallout)
                                    .foregroundColor(.ssDarkGray)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text(TexterifyManager.localisedString(key: .orderCreationSummaryView(.wouldYouLikeToReceiveInvoice)))
                            .font(.ssTitle2)
                        
                        SingleSelectionToggle(selection: $orderCreationViewModel.toReceiveInvoice)
                            .disabled(true)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("\(TexterifyManager.localisedString(key: .orderCreationSummaryView(.products))) (\(cartViewModel.cartAllProductsQuantityCount))")
                            .font(.ssTitle2)
                        
                        ForEach(Array(cartViewModel.productsForCart.keys).sorted { $0.id > $1.id}, id: \.self) { product in
                            BasicProductTile(product: product, productQuantity: cartViewModel.productsForCart[product])
                            Divider()
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(TexterifyManager.localisedString(key: .orderCreationSummaryView(.productsInCart)))
                                .font(.ssCallout)
                                .foregroundColor(.ssDarkGray)
                            
                            Text("\(cartViewModel.cartAllProductsQuantityCount)")
                                .font(.ssTitle3)
                                .foregroundColor(.accentColor)
                        }
                        
                        HStack {
                            Text(TexterifyManager.localisedString(key: .orderCreationSummaryView(.totalCost)))
                                .font(.ssCallout)
                                .foregroundColor(.ssDarkGray)
                            
                            Text("$\(cartViewModel.cartTotalCost, specifier: "%.2f")")
                                .font(.ssTitle3)
                                .foregroundColor(.accentColor)
                        }
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text(TexterifyManager.localisedString(key: .orderCreationSummaryView(.doYouHaveCouponCode)))
                                .font(.ssTitle2)
                            
                            HStack(alignment: .bottom) {
                                RectangleCustomTextField(textFieldProperty: TexterifyManager.localisedString(key: .orderCreationSummaryView(.couponCodeTextField)),
                                                         text: $orderCreationViewModel.discountCode,
                                                         isFocusedParentView:
                                                            $isCouponTextFieldFocused)
                                
                                Button {
                                    let success = cartViewModel.applyDiscount(discountCode: orderCreationViewModel.discountCode)
                                    if !success {
                                        errorManager.generateCustomError(errorType: .discountApplyError, additionalErrorDescription: TexterifyManager.localisedString(key: .orderCreationSummaryView(.applyDiscountErrorDescription)))
                                    }
                                    orderCreationViewModel.applyDiscount()
                                } label: {
                                    Text(TexterifyManager.localisedString(key: .orderCreationSummaryView(.applyCouponCodeButton)))
                                        .font(.ssButton)
                                }
                                .buttonStyle(CustomButton())
                                .disabled(orderCreationViewModel.discountCode.isEmpty)
                                .frame(width: ScreenBoundsSupplier.shared.getScreenWidth() * 0.25)
                            }
                        }
                        .padding(.vertical, 15)
                        
                        if !cartViewModel.appliedDiscounts.isEmpty {
                            ForEach(Array(cartViewModel.appliedDiscounts).sorted { $0.discountValuePercent > $1.discountValuePercent }, id: \.self) { appliedDiscount in
                                HStack {
                                    Button {
                                        cartViewModel.removeDiscount(discount: appliedDiscount)
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                    }
                                    
                                    Text("\(appliedDiscount.discountCode):")
                                        .font(.ssCallout)
                                        .foregroundColor(.ssDarkGray)
                                    
                                    Spacer()
                                    
                                    Text("-\(appliedDiscount.discountValuePercent, specifier: "%.2f")%")
                                        .font(.ssCallout)
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                        
                        HStack {
                            Text(TexterifyManager.localisedString(key: .orderCreationSummaryView(.totalCostWithDiscounts)))
                                .font(.ssCallout)
                                .foregroundColor(.ssDarkGray)
                            
                            Spacer()
                            
                            if let totalCartPrice = cartViewModel.cartTotalCostWithAppliedDiscounts,
                               let shippingPaymentPrice = orderCreationViewModel.shippingPaymentPrice {
                                Text(LocaleManager.client.formatPrice(price: totalCartPrice + shippingPaymentPrice) ?? "")
                                    .font(.ssTitle3)
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .padding(.top, 10)
                    }
                }
                .padding()
            }
            
            VStack(alignment: .leading, spacing: 10) {
                completeOrderButton
                Text(TexterifyManager.localisedString(key: .orderCreationSummaryView(.submitWarning)))
                    .font(.ssCallout)
                    .foregroundColor(.ssDarkGray)
            }
            .padding()
            
            NavigationLink(destination: OrderCreationCompletionView()
                                            .environmentObject(orderCreationViewModel)
                                            .environmentObject(stripeViewModel)
                                            .onAppear {
                                                tabBarStateManager.hideTabBar()
                                            },
                           isActive: $orderCreationViewModel.shouldPresentOrderCreationCompletionView,
                           label: { EmptyView() })
            .isDetailLink(false)
        }
        .onChange(of: stripeViewModel.paymentData) { paymentData in
            if let paymentData = paymentData {
                if !paymentData.isEmpty {
                    stripeViewModel.preparePaymentSheet()

                    guard let profile = profileViewModel.profile,
                          let shippingAddress = profileViewModel.getAddressFor(addressDescription: orderCreationViewModel.defaultAddress) else { return }

                    orderCreationViewModel.createOrder(client: profile,
                                                       productsWithQuantity: cartViewModel.productsForCart,
                                                       appliedDiscounts: cartViewModel.sortedAppliedDiscounts,
                                                       productsCost: cartViewModel.cartTotalCost,
                                                       totalCostWithAppliedDiscounts: cartViewModel.cartTotalCostWithAppliedDiscounts,
                                                       shippingAddress: shippingAddress) { result in
                        switch result {
                        case .success(_):
                            orderCreationViewModel.shouldPresentOrderCreationCompletionView = true
                        case .failure(let error):
                            errorManager.generateCustomError(errorType: .orderCreateError,
                                                             additionalErrorDescription: error.localizedDescription)
                        }
                    }
                }
            }
        }
        .onAppear {
            tabBarStateManager.showTabBar()
        }
        .modifier(LoadingIndicatorModal(isPresented:
                                            $orderCreationViewModel.showLoadingModal))
        .modifier(LoadingIndicatorModal(isPresented:
                                            $stripeViewModel.showLoadingModal))
        .modifier(LoadingIndicatorModal(isPresented:
                                            $cartViewModel.showLoadingModal))
        .navigationTitle(TexterifyManager.localisedString(key: .orderCreationSummaryView(.navigationTitle)))
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
    }
    
    var completeOrderButton: some View {
        Button {
            if let profile = profileViewModel.profile {
                cartViewModel.checkProductAvailability(productsWithQuantity: cartViewModel.productsForCart) { result in
                    switch result {
                    case .success(let notAvailableProductsIDs):
                        if notAvailableProductsIDs.isEmpty {
                            if let amount = orderCreationViewModel.getOrderTotalCost(totalCostWithAppliedDiscounts: cartViewModel.cartTotalCostWithAppliedDiscounts),
                               let currency = orderCreationViewModel.currencyCode {
                                stripeViewModel.prepareFirebaseForPayment(profileID: profile.id,
                                                                          amount: amount,
                                                                          currency: currency) { result in
                                    switch result {
                                    case .success:
                                        break
                                    case .failure(let error):
                                        errorManager.generateCustomError(errorType: .paymentFailedError,
                                                                         additionalErrorDescription: error.localizedDescription)
                                    }
                                }
                            }
                        } else {
                            errorManager.generateCustomError(errorType: .productNotAvailableError,
                                                             additionalErrorDescription: cartViewModel.getNamesOfProductsNotAvailableForError(productsIDs: notAvailableProductsIDs))
                        }
                        
                    case .failure(let error):
                        errorManager.generateCustomError(errorType: .productNotAvailableError,
                                                         additionalErrorDescription: error.localizedDescription)
                    }
            }
        }
        } label: {
            Text(TexterifyManager.localisedString(key: .orderCreationSummaryView(.submitButton)))
                .font(.ssButton)
        }
        .buttonStyle(CustomButton())
    }
}

struct OrderCreationSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        let cartViewModel = CartViewModel()
        let favoritesViewModel = FavoritesViewModel()
        let orderCreationViewModel = OrderCreationViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                OrderCreationSummaryView()
                    .environmentObject(tabBarStateManager)
                    .environmentObject(exploreViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(cartViewModel)
                    .environmentObject(favoritesViewModel)
                    .environmentObject(orderCreationViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
                    .onAppear {
                        orderCreationViewModel.choosenShippingMethod = .parcel
                        orderCreationViewModel.defaultAddress = Address.demoAddress.description
                        orderCreationViewModel.choosenPaymentMethod = PaymentMethod.creditCard
                        orderCreationViewModel.createdOrder = Order.demoOrders[0]
                        cartViewModel.productsForCart = [Product.demoProducts[0]: 2,
                                                         Product.demoProducts[1]: 1,
                                                         Product.demoProducts[2]: 3,
                                                         Product.demoProducts[3]: 1]
                        cartViewModel.appliedDiscounts.insert(Discount.demoDiscounts[0])
                        cartViewModel.appliedDiscounts.insert(Discount.demoDiscounts[1])
                    }
            }
        }
    }
}
