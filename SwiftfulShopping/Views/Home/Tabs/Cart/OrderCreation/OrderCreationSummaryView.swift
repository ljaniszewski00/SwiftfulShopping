//
//  OrderCreationSummaryView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 30/07/2022.
//

import SwiftUI

struct OrderCreationSummaryView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var orderCreationViewModel: OrderCreationViewModel
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @StateObject var errorManager = ErrorManager.shared
    
    @State private var isCouponTextFieldFocused: Bool = false
    
    var body: some View {
        VStack {
            StepsView(stepsNumber: 4, activeStep: 3)
                .padding(.vertical)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Consignee Data")
                            .font(.ssTitle2)
                        
                        Text("This will be the delivery addres for package")
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
                        Text("Shipping Method")
                            .font(.ssTitle2)
                        
                        Text(orderCreationViewModel.choosenShippingMethod?.rawValue ?? "")
                            .font(.ssTitle3)
                            .foregroundColor(.accentColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Payment Method")
                            .font(.ssTitle2)
                        
                        Text(orderCreationViewModel.choosenPaymentMethod?.rawValue ?? "")
                            .font(.ssTitle3)
                            .foregroundColor(.accentColor)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Would you like to receive invoice?")
                            .font(.ssTitle2)
                        
                        SingleSelectionToggle(selection: $orderCreationViewModel.toReceiveInvoice)
                            .disabled(true)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Products")
                            .font(.ssTitle2)
                        
                        ForEach(Array(cartViewModel.productsForCart.keys).sorted { $0.id > $1.id}, id: \.self) { product in
                            ProductTileForCartView(product: product, includeButtonsForAmountChange: false)
                                .padding()
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Products in cart:")
                                .font(.ssCallout)
                                .foregroundColor(.ssDarkGray)
                            
                            Text("\(cartViewModel.cartProductsCount)")
                                .font(.ssTitle3)
                                .foregroundColor(.accentColor)
                        }
                        
                        HStack {
                            Text("Total cost:")
                                .font(.ssCallout)
                                .foregroundColor(.ssDarkGray)
                            
                            Text("$\(cartViewModel.cartTotalCost, specifier: "%.2f")")
                                .font(.ssTitle3)
                                .foregroundColor(.accentColor)
                        }
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Do you have coupon code?")
                                .font(.ssTitle2)
                            
                            HStack(alignment: .bottom) {
                                RectangleCustomTextField(textFieldProperty: "Coupon code",
                                                         text: $orderCreationViewModel.discountCode,
                                                         isFocusedParentView:
                                                            $isCouponTextFieldFocused)
                                
                                Button {
                                    if let discount = orderCreationViewModel.applyDiscount() {
                                        cartViewModel.applyDiscount(discount: discount)
                                    } else {
                                        errorManager.generateCustomError(errorType: .discountApplyError)
                                    }
                                } label: {
                                    Text("Apply")
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
                            Text("Total cost with discounts:")
                                .font(.ssCallout)
                                .foregroundColor(.ssDarkGray)
                            
                            Spacer()
                            
                            Text("$\(cartViewModel.cartTotalCostWithAppliedDiscounts, specifier: "%.2f")")
                                .font(.ssTitle3)
                                .foregroundColor(.accentColor)
                        }
                        .padding(.top, 10)
                    }
                }
                .padding()
            }
            
            Button {
                if let desiredAddress = profileViewModel.getAddressFor(addressDescription: orderCreationViewModel.defaultAddress), let profile = profileViewModel.profile {
                    orderCreationViewModel.createOrder(client: profile,
                                                       productsWithQuantity: cartViewModel.productsForCart,
                                                       appliedDiscounts: cartViewModel.sortedAppliedDiscounts,
                                                       totalCost: cartViewModel.cartTotalCost,
                                                       totalCostWithAppliedDiscounts: cartViewModel.cartTotalCostWithAppliedDiscounts,
                                                      shippingAddress: desiredAddress) { result in
                        switch result {
                        case .success:
                            orderCreationViewModel.shouldPresentOrderCreationCompletionView = true
                        case .failure(let error):
                            errorManager.generateCustomError(errorType: .orderCreateError,
                                                             additionalErrorDescription: error.localizedDescription)
                        }
                    }
                }
            } label: {
                Text("Complete")
                    .font(.ssButton)
            }
            .buttonStyle(CustomButton())
            .padding()
            
            NavigationLink(destination: OrderCreationCompletionView()
                                            .environmentObject(orderCreationViewModel)
                                            .onAppear {
                                                tabBarStateManager.hideTabBar()
                                            }
                                            .onDisappear {
                                                tabBarStateManager.showTabBar()
                                            },
                           isActive: $orderCreationViewModel.shouldPresentOrderCreationCompletionView,
                           label: { EmptyView() })
            .isDetailLink(false)
        }
        .navigationTitle("Order Summary")
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
}

struct OrderCreationSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        let authStateManager = AuthStateManager()
        let tabBarStateManager = TabBarStateManager()
        let exploreViewModel = ExploreViewModel()
        let profileViewModel = ProfileViewModel()
        let cartViewModel = CartViewModel()
        let favoritesViewModel = FavoritesViewModel()
        let orderCreationViewModel = OrderCreationViewModel()
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                OrderCreationSummaryView()
                    .environmentObject(authStateManager)
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
                        authStateManager.didLogged(with: .emailPassword)
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
