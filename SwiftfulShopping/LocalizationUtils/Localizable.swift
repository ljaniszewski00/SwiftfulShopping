//
//  Localizable.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 30/10/2022.
//

public enum Localizable {
    case loginView(LoginViewLocalizable)
    case forgotPasswordView(ForgotPasswordViewLocalizable)
    case common(CommonLocalizable)
    case firstTimeLoginView(FirstTimeLoginViewLocalizable)
    case registerView(RegisterViewLocalizable)
    case secondRegisterView(SecondRegisterViewLocalizable)
    case sortingAndFilteringSheetView(SortingAndFilteringViewLocalizable)
    case listProductCardTileView(ListProductCardTileViewLocalizable)
    case gridProductCardTileView(GridProductCardTileViewLocalizable)
    case productTileForCartView(ProductTileForCartViewLocalizable)
    case basicProductTile(BasicProductTileLocalizable)
    case productDetailsView(ProductDetailsViewLocalizable)
    case productDetailsRatingsSection(ProductDetailsRatingsSectionLocalizable)
    case productsListView(ProductsListViewLocalizable)
    case exploreView(ExploreViewLocalizable)
    case notificationsView(NotificationsViewLocalizable)
    case favoritesView(FavoritesViewLocalizable)
    case orderCreationShipmentPaymentView(OrderCreationShipmentPaymentViewLocalizable)
    case orderCreationSummaryView(OrderCreationSummaryViewLocalizable)
    case orderCreationCompletionView(OrderCreationCompletionViewLocalizable)
    case orderCreationChangeAddressView(OrderCreationChangeAddressViewLocalizable)
    case cartView(CartViewLocalizable)
    case productRecognizerView(ProductRecognizerViewLocalizable)
    case cameraView(CameraViewLocalizable)
    case searchView(SearchViewLocalizable)
    case searchedProductsListView(SearchedProductsListViewLocalizable)
    case profileView(ProfileViewLocalizable)
    case ordersView(OrdersViewLocalizable)
    case orderDetailsView(OrderDetailsViewLocalizable)
    case orderRateView(OrderRateViewLocalizable)
    case singleProductRatingView(SingleProductRatingViewLocalizable)
    case returnsView(ReturnsViewLocalizable)
    case returnDetailsView(ReturnDetailsViewLocalizable)
    case returnCreationView(ReturnCreationViewLocalizable)
    case secondReturnCreationView(SecondReturnCreationViewLocalizable)
    case thirdReturnCreationView(ThirdReturnCreationViewLocalizable)
    case completionReturnCreationView(CompletionReturnCreationViewLocalizable)
    case personalInfoView(PersonalInfoViewLocalizable)
    case addNewAddressView(AddNewAddressViewLocalizable)
    case editPersonalInfoView(EditPersonalInfoViewLocalizable)
    case paymentDetailsView(PaymentDetailsViewLocalizable)
    case helpView(HelpViewLocalizable)
    case settingsView(SettingsViewLocalizable)
    case changeEmailView(ChangeEmailViewLocalizable)
    case changePasswordView(ChangePasswordViewLocalizable)
    case deleteAccountView(DeleteAccountViewLocalizable)
    case accentColorChangeView(AccentColorChangeViewLocalizable)
    case colorSchemeChangeView(ColorSchemeChangeViewLocalizable)
    case homeView(HomeViewLocalizable)
    case errors(ErrorsLocalizable)
    case labelledDivider(LabelledDividerLocalizable)
    case addToCartButton(AddToCartButtonLocalizable)
}

extension Localizable: LocalizableRawRepresentable {
    var rawValue: String {
        switch self {
        case let .loginView(localizable):
            return localizable.rawValue
        case let .forgotPasswordView(localizable):
            return localizable.rawValue
        case let .common(localizable):
            return localizable.rawValue
        case let .firstTimeLoginView(localizable):
            return localizable.rawValue
        case let .registerView(localizable):
            return localizable.rawValue
        case let .secondRegisterView(localizable):
            return localizable.rawValue
        case let .sortingAndFilteringSheetView(localizable):
            return localizable.rawValue
        case let .listProductCardTileView(localizable):
            return localizable.rawValue
        case let .gridProductCardTileView(localizable):
            return localizable.rawValue
        case let .productTileForCartView(localizable):
            return localizable.rawValue
        case let .basicProductTile(localizable):
            return localizable.rawValue
        case let .productDetailsView(localizable):
            return localizable.rawValue
        case let .productDetailsRatingsSection(localizable):
            return localizable.rawValue
        case let .productsListView(localizable):
            return localizable.rawValue
        case let .exploreView(localizable):
            return localizable.rawValue
        case let .notificationsView(localizable):
            return localizable.rawValue
        case let .favoritesView(localizable):
            return localizable.rawValue
        case let .orderCreationShipmentPaymentView(localizable):
            return localizable.rawValue
        case let .orderCreationSummaryView(localizable):
            return localizable.rawValue
        case let .orderCreationCompletionView(localizable):
            return localizable.rawValue
        case let .orderCreationChangeAddressView(localizable):
            return localizable.rawValue
        case let .cartView(localizable):
            return localizable.rawValue
        case let .productRecognizerView(localizable):
            return localizable.rawValue
        case let .cameraView(localizable):
            return localizable.rawValue
        case let .searchView(localizable):
            return localizable.rawValue
        case let .searchedProductsListView(localizable):
            return localizable.rawValue
        case let .profileView(localizable):
            return localizable.rawValue
        case let .ordersView(localizable):
            return localizable.rawValue
        case let .orderDetailsView(localizable):
            return localizable.rawValue
        case let .orderRateView(localizable):
            return localizable.rawValue
        case let .singleProductRatingView(localizable):
            return localizable.rawValue
        case let .returnsView(localizable):
            return localizable.rawValue
        case let .returnDetailsView(localizable):
            return localizable.rawValue
        case let .returnCreationView(localizable):
            return localizable.rawValue
        case let .secondReturnCreationView(localizable):
            return localizable.rawValue
        case let .thirdReturnCreationView(localizable):
            return localizable.rawValue
        case let .completionReturnCreationView(localizable):
            return localizable.rawValue
        case let .personalInfoView(localizable):
            return localizable.rawValue
        case let .addNewAddressView(localizable):
            return localizable.rawValue
        case let .editPersonalInfoView(localizable):
            return localizable.rawValue
        case let .paymentDetailsView(localizable):
            return localizable.rawValue
        case let .helpView(localizable):
            return localizable.rawValue
        case let .settingsView(localizable):
            return localizable.rawValue
        case let .changeEmailView(localizable):
            return localizable.rawValue
        case let .changePasswordView(localizable):
            return localizable.rawValue
        case let .deleteAccountView(localizable):
            return localizable.rawValue
        case let .accentColorChangeView(localizable):
            return localizable.rawValue
        case let .colorSchemeChangeView(localizable):
            return localizable.rawValue
        case let .homeView(localizable):
            return localizable.rawValue
        case let .errors(localizable):
            return localizable.rawValue
        case let .labelledDivider(localizable):
            return localizable.rawValue
        case let .addToCartButton(localizable):
            return localizable.rawValue
        }
    }
}

protocol LocalizableRawRepresentable {
    var rawValue: String { get }
}
