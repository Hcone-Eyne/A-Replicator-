import 'package:flutter_riverpod/flutter_riverpod.dart';

class Address {
  final String id;
  final String label;
  final String address;
  final bool isDefault;

  const Address({
    required this.id,
    required this.label,
    required this.address,
    this.isDefault = false,
  });

  Address copyWith({
    String? id,
    String? label,
    String? address,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      label: label ?? this.label,
      address: address ?? this.address,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class PaymentMethod {
  final String id;
  final String type;
  final String last4;
  final String expiry;
  final bool isDefault;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.last4,
    required this.expiry,
    this.isDefault = false,
  });

  PaymentMethod copyWith({
    String? id,
    String? type,
    String? last4,
    String? expiry,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      last4: last4 ?? this.last4,
      expiry: expiry ?? this.expiry,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class PrivacyState {
  final bool twoFactorAuth;
  final bool profileVisibility;
  final bool onlineStatus;

  const PrivacyState({
    this.twoFactorAuth = false,
    this.profileVisibility = true,
    this.onlineStatus = true,
  });

  PrivacyState copyWith({
    bool? twoFactorAuth,
    bool? profileVisibility,
    bool? onlineStatus,
  }) {
    return PrivacyState(
      twoFactorAuth: twoFactorAuth ?? this.twoFactorAuth,
      profileVisibility: profileVisibility ?? this.profileVisibility,
      onlineStatus: onlineStatus ?? this.onlineStatus,
    );
  }
}

class SettingsState {
  final List<Address> addresses;
  final List<PaymentMethod> paymentMethods;
  final PrivacyState privacy;

  const SettingsState({
    this.addresses = const [],
    this.paymentMethods = const [],
    this.privacy = const PrivacyState(),
  });

  SettingsState copyWith({
    List<Address>? addresses,
    List<PaymentMethod>? paymentMethods,
    PrivacyState? privacy,
  }) {
    return SettingsState(
      addresses: addresses ?? this.addresses,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      privacy: privacy ?? this.privacy,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier()
      : super(const SettingsState(
          addresses: [
            Address(
              id: '1',
              label: 'Home',
              address: '123 Main Street, Apt 4B, San Francisco, CA 94102',
              isDefault: true,
            ),
            Address(
              id: '2',
              label: 'Work',
              address: '456 Market Street, Suite 200, San Francisco, CA 94105',
            ),
            Address(
              id: '3',
              label: 'Parents',
              address: '789 Oak Avenue, Palo Alto, CA 94301',
            ),
          ],
          paymentMethods: [
            PaymentMethod(
              id: '1',
              type: 'Visa',
              last4: '4242',
              expiry: '12/25',
              isDefault: true,
            ),
            PaymentMethod(
              id: '2',
              type: 'Mastercard',
              last4: '8888',
              expiry: '06/26',
            ),
            PaymentMethod(
              id: '3',
              type: 'Amex',
              last4: '1234',
              expiry: '09/24',
            ),
          ],
        ));

  // --- Addresses ---
  void addAddress(Address address) {
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    state = state.copyWith(
      addresses: [...state.addresses, address.copyWith(id: newId)],
    );
  }

  void updateAddress(Address address) {
    state = state.copyWith(
      addresses: state.addresses
          .map((a) => a.id == address.id ? address : a)
          .toList(),
    );
  }

  void deleteAddress(String id) {
    state = state.copyWith(
      addresses: state.addresses.where((a) => a.id != id).toList(),
    );
  }

  void setDefaultAddress(String id) {
    state = state.copyWith(
      addresses: state.addresses
          .map((a) => a.copyWith(isDefault: a.id == id))
          .toList(),
    );
  }

  // --- Payment Methods ---
  void addPaymentMethod(PaymentMethod method) {
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    state = state.copyWith(
      paymentMethods: [...state.paymentMethods, method.copyWith(id: newId)],
    );
  }

  void deletePaymentMethod(String id) {
    state = state.copyWith(
      paymentMethods: state.paymentMethods.where((m) => m.id != id).toList(),
    );
  }

  void setDefaultPaymentMethod(String id) {
    state = state.copyWith(
      paymentMethods: state.paymentMethods
          .map((m) => m.copyWith(isDefault: m.id == id))
          .toList(),
    );
  }

  // --- Privacy ---
  void toggleTwoFactor(bool value) {
    state = state.copyWith(
      privacy: state.privacy.copyWith(twoFactorAuth: value),
    );
  }

  void toggleProfileVisibility(bool value) {
    state = state.copyWith(
      privacy: state.privacy.copyWith(profileVisibility: value),
    );
  }

  void toggleOnlineStatus(bool value) {
    state = state.copyWith(
      privacy: state.privacy.copyWith(onlineStatus: value),
    );
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(),
);
