import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/address_model.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/payment_method_model.dart';
import '../../data/services/address_service.dart';
import 'cart_provider.dart';

/// Address service provider.
final addressServiceProvider = Provider<AddressService>((ref) {
  return AddressService();
});

/// Saved addresses provider.
final savedAddressesProvider =
    AsyncNotifierProvider<SavedAddressesNotifier, List<AddressModel>>(
      SavedAddressesNotifier.new,
    );

class SavedAddressesNotifier extends AsyncNotifier<List<AddressModel>> {
  AddressService get _service => ref.read(addressServiceProvider);

  @override
  Future<List<AddressModel>> build() async {
    return _service.getAddresses();
  }

  /// Refresh saved addresses.
  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => _service.getAddresses());
  }

  /// Alternative refresh method name.
  Future<void> refreshAddresses() async {
    await refresh();
  }

  /// Add a new address.
  Future<void> addAddress(AddressModel address) async {
    await _service.addAddress(address);
    await refresh();
  }

  /// Update an existing address.
  Future<void> updateAddress(AddressModel address) async {
    await _service.updateAddress(address);
    await refresh();
  }

  /// Delete an address.
  Future<void> deleteAddress(String addressId) async {
    await _service.deleteAddress(addressId);
    await refresh();
  }

  /// Set an address as the default address.
  Future<void> setDefaultAddress(String addressId) async {
    await _service.setDefaultAddress(addressId);
    await refresh();
  }
}

/// Currently selected delivery address.
final selectedAddressProvider =
    NotifierProvider<SelectedAddressNotifier, AddressModel?>(
      SelectedAddressNotifier.new,
    );

class SelectedAddressNotifier extends Notifier<AddressModel?> {
  @override
  AddressModel? build() {
    return null;
  }

  void select(AddressModel? address) {
    state = address;
  }
}

/// Currently selected payment method.
final selectedPaymentMethodProvider =
    NotifierProvider<SelectedPaymentMethodNotifier, PaymentMethodType>(
      SelectedPaymentMethodNotifier.new,
    );

class SelectedPaymentMethodNotifier extends Notifier<PaymentMethodType> {
  @override
  PaymentMethodType build() {
    return PaymentMethodType.cashOnDelivery;
  }

  void select(PaymentMethodType method) {
    state = method;
  }
}

/// Checkout shipping fee.
final checkoutShippingFeeProvider = Provider<double>((ref) {
  return 0.0;
});

/// Checkout discount.
final checkoutDiscountProvider = Provider<double>((ref) {
  return 0.0;
});

/// Checkout subtotal calculated from cart items.
final checkoutSubtotalProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cartProvider);

  return cartItems.when(
    data: (items) {
      return items.fold<double>(0.0, (total, item) {
        final cartItem = CartItemModel.fromJson(item);
        return total + cartItem.totalPrice;
      });
    },
    loading: () => 0.0,
    error: (error, stackTrace) => 0.0,
  );
});

/// Final checkout amount.
final checkoutTotalProvider = Provider<double>((ref) {
  final subtotal = ref.watch(checkoutSubtotalProvider);
  final shippingFee = ref.watch(checkoutShippingFeeProvider);
  final discount = ref.watch(checkoutDiscountProvider);

  final total = subtotal + shippingFee - discount;

  return total.clamp(0.0, double.infinity).toDouble();
});
