import 'package:flutter/material.dart';

import '../../core/utils/validators.dart';
import '../../data/models/address_model.dart';

class AddressScreen extends StatefulWidget {
  final List<AddressModel> addresses;
  final ValueChanged<AddressModel>? onSaveAddress;
  final ValueChanged<AddressModel>? onSelectAddress;

  const AddressScreen({
    super.key,
    this.addresses = const [],
    this.onSaveAddress,
    this.onSelectAddress,
  });

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  static const Color primaryOrange = Color(0xFFE68A45);
  static const Color darkOrange = Color(0xFFB95F2D);
  static const Color lightOrange = Color(0xFFFFF0E3);

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController(text: 'Pakistan');
  final _detailsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (!_formKey.currentState!.validate()) return;

    final address = AddressModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      streetAddress: _streetController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      postalCode: _postalCodeController.text.trim(),
      country: _countryController.text.trim(),
      additionalDetails: _detailsController.text.trim(),
      isDefault: widget.addresses.isEmpty,
    );

    widget.onSaveAddress?.call(address);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Address saved successfully.'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    _formKey.currentState!.reset();

    for (final controller in [
      _nameController,
      _phoneController,
      _streetController,
      _cityController,
      _stateController,
      _postalCodeController,
      _detailsController,
    ]) {
      controller.clear();
    }

    _countryController.text = 'Pakistan';
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().length < 7) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  Widget _sectionTitle(String title, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          filled: true,
          fillColor: isDark ? const Color(0xFF29231F) : const Color(0xFFFFF9F4),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 17,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primaryOrange, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: theme.colorScheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _savedAddressCard(AddressModel address) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => widget.onSelectAddress?.call(address),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? primaryOrange.withValues(alpha: 0.15)
                          : lightOrange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: primaryOrange,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            address.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (address.isDefault)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: primaryOrange.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Default',
                              style: TextStyle(
                                color: darkOrange,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      address.formattedAddress,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      address.phone,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delivery Address',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: darkOrange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [darkOrange, primaryOrange, Color(0xFFF2A96B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: darkOrange.withValues(alpha: 0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.local_shipping_outlined,
                  color: Colors.white,
                  size: 34,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Where should we deliver?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Choose a saved address or add a new one.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          if (widget.addresses.isNotEmpty) ...[
            _sectionTitle(
              'Saved Addresses',
              subtitle: 'Select an address for your delivery.',
            ),
            const SizedBox(height: 14),
            ...widget.addresses.map(_savedAddressCard),
            const SizedBox(height: 18),
          ],

          _sectionTitle(
            'Add New Address',
            subtitle: 'Enter your delivery details below.',
          ),
          const SizedBox(height: 17),

          Form(
            key: _formKey,
            child: Column(
              children: [
                _field(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: Icons.person_outline,
                  validator: Validators.validateName,
                ),
                _field(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: _phoneValidator,
                ),
                _field(
                  controller: _streetController,
                  label: 'Street Address',
                  icon: Icons.home_outlined,
                  validator: _requiredValidator,
                ),
                _field(
                  controller: _cityController,
                  label: 'City',
                  icon: Icons.location_city_outlined,
                  validator: _requiredValidator,
                ),
                _field(
                  controller: _stateController,
                  label: 'State / Province',
                  icon: Icons.map_outlined,
                  validator: _requiredValidator,
                ),
                _field(
                  controller: _postalCodeController,
                  label: 'Postal Code',
                  icon: Icons.markunread_mailbox_outlined,
                  keyboardType: TextInputType.number,
                  validator: _requiredValidator,
                ),
                _field(
                  controller: _countryController,
                  label: 'Country',
                  icon: Icons.public_outlined,
                  validator: _requiredValidator,
                ),
                _field(
                  controller: _detailsController,
                  label: 'Delivery Instructions (Optional)',
                  icon: Icons.notes_outlined,
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: _saveAddress,
                    icon: const Icon(Icons.add_location_alt_outlined),
                    label: const Text(
                      'Save Address',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryOrange,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: primaryOrange.withValues(alpha: 0.25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Text(
            'Your address information is used for order delivery.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
