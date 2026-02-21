import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_project/CartScreen/Services/CheckoutController.dart';

class AddressFormScreen extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  const AddressFormScreen({super.key, this.initialData});

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late CheckoutController controller;
  bool _hasFetched = false;

  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController postalCodeController;
  late TextEditingController countryController;
  late TextEditingController phoneController;

  bool isDefault = true;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CheckoutController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasFetched && controller.addresses.isEmpty) {
        _hasFetched = true;
        controller.fetchAddresses();
      }
    });

    nameController = TextEditingController(
      text: widget.initialData?['name'] ?? '',
    );
    addressController = TextEditingController(
      text: widget.initialData?['address'] ?? '',
    );
    cityController = TextEditingController(
      text: widget.initialData?['city'] ?? '',
    );
    stateController = TextEditingController(
      text: widget.initialData?['state'] ?? '',
    );
    postalCodeController = TextEditingController(
      text: widget.initialData?['postalCode'] ?? '',
    );
    countryController = TextEditingController(
      text: widget.initialData?['country'] ?? '',
    );
    phoneController = TextEditingController(
      text: widget.initialData?['phone'] ?? '',
    );
    isDefault = widget.initialData?['isDefault'] ?? true;
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialData != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Address' : 'Add Address',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        child: Obx(() {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextField(
                        'Full Name',
                        nameController,
                        capitalization: TextCapitalization.words,
                      ),
                      buildTextField('Address', addressController, maxLines: 2),
                      buildTextField(
                        'City',
                        cityController,
                        capitalization: TextCapitalization.words,
                      ),
                      buildTextField(
                        'State',
                        stateController,
                        capitalization: TextCapitalization.words,
                      ),
                      buildTextField(
                        'Postal Code',
                        postalCodeController,
                        keyboardType: TextInputType.number,
                      ),
                      buildTextField(
                        'Country',
                        countryController,
                        capitalization: TextCapitalization.words,
                      ),
                      buildTextField(
                        'Phone',
                        phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),

                      SwitchListTile(
                        title: const Text('Set as default address'),
                        value: isDefault,
                        activeColor: Colors.white,
                        activeTrackColor: const Color(0xffC17D4A),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey.shade300,
                        onChanged: (val) {
                          setState(() => isDefault = val);
                        },
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffC17D4A),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: controller.isLoading.value
                            ? const SizedBox.shrink()
                            : const Icon(Icons.add, color: Colors.white),
                        label: controller.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                            : Text(
                                isEditing ? 'Update Address' : 'Save Address',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                        onPressed: controller.isLoading.value
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  final data = {
                                    "name": nameController.text.trim(),
                                    "address": addressController.text.trim(),
                                    "city": cityController.text.trim(),
                                    "state": stateController.text.trim(),
                                    "postalCode": postalCodeController.text
                                        .trim(),
                                    "country": countryController.text.trim(),
                                    "phone": phoneController.text.trim(),
                                    "isDefault": isDefault,
                                  };

                                  final success = await controller.addAddress(
                                    name: nameController.text.trim(),
                                    address: addressController.text.trim(),
                                    city: cityController.text.trim(),
                                    state: stateController.text.trim(),
                                    postalCode: postalCodeController.text
                                        .trim(),
                                    country: countryController.text.trim(),
                                    phone: phoneController.text.trim(),
                                    isDefault: isDefault,

                                    addressID: widget.initialData != null
                                        ? widget.initialData!["id"]
                                        : "",
                                  );

                                  if (success && mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Address saved successfully!",
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.pop(context, true);
                                  } else if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          controller.error.value ??
                                              "Failed to save address",
                                        ),
                                        backgroundColor: const Color(
                                          0xffC17D4A,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                      ),
                    ],
                  ),
                ),
              ),

              if (controller.isLoading.value)
                Container(
                  color: Colors.black.withOpacity(0.2),
                  child: const Center(
                    child: CircularProgressIndicator(color: Color(0xffC17D4A)),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization capitalization = TextCapitalization.none,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: capitalization,
        maxLines: maxLines,
        validator: (val) =>
            val == null || val.trim().isEmpty ? '$label required' : null,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xffC17D4A), width: 1.6),
          ),
        ),
      ),
    );
  }
}
