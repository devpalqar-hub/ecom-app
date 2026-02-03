import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:new_project/CartScreen/Services/CheckoutController.dart';
import 'package:new_project/CartScreen/Services/CartController.dart';
import 'package:new_project/CartScreen/Views/OrderPopUpScreen.dart';
import 'package:new_project/CartScreen/Views/OrderSummaryCard.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState
    extends State<OrderConfirmationScreen> {
  final CheckoutController checkoutController =
      Get.find<CheckoutController>();
  final CartController cartController =
      Get.find<CartController>();

  bool isProcessing = false;

  Future<void> _placeOrder() async {
  if (isProcessing) return;
  setState(() => isProcessing = true);

  final address = checkoutController.selectedAddress.value;
  final cart = cartController.cart.value;

  if (address == null || cart == null || cart.data.isEmpty) {
    Get.snackbar("Error", "Invalid cart or address");
    setState(() => isProcessing = false);
    return;
  }

  try {
   
    final amount = cartController.getTotalPrice() -
        cartController.discountAmount.value;

    final response = await checkoutController.createOrder(
      shippingAddressId: address.id!, 
      useCart: true,                 
      paymentMethod: "cash_on_delivery",
    );

  
    final orderNumber =
        response['data']['order']['orderNumber'];

    
    Get.dialog(
      OrderSuccessPopup(
        orderNumber: orderNumber,
        amount: amount,
      ),
      barrierDismissible: false,
    );

    
    await cartController.fetchCart();
  } catch (e, s) {
    debugPrint("ORDER ERROR => $e");
    debugPrint("STACK => $s");

    Get.snackbar(
      "Error",
      "Failed to place order",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    setState(() => isProcessing = false);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Confirm Order"),
      ),
      body: Obx(() {
        final address = checkoutController.selectedAddress.value;

        final total = cartController.getTotalPrice();
        final discount = cartController.discountAmount.value;
        final payable =
            (total - discount).clamp(0, double.infinity).toDouble();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            
              Row(
                children: [
                  Expanded(
                    child: Text(
                      address != null
                          ? '${address.name}, ${address.address}, '
                            '${address.city}, ${address.state}, '
                            '${address.postalCode}'
                          : 'No delivery address selected',
                      style: GoogleFonts.poppins(fontSize: 13),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text(
                      'Change',
                      style: GoogleFonts.poppins(
                        color: const Color(0xffC17D4A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const Divider(height: 30),

            
              Text(
                'Order Summary',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              OrderSummaryCard(
                items: cartController.cart.value!.data
                    .where((e) => (e.quantity ?? 0) > 0)
                    .map((e) => {
                          'title': e.product?.name ?? '',
                          'qty': e.quantity ?? 0,
                          'price':
                              e.product?.discountedPrice ?? 0,
                        })
                    .toList(),
              ),

              const SizedBox(height: 20),

              _row('Total', 'QAR${total.toStringAsFixed(2)}'),
              if (discount > 0)
                _row(
                  'Discount',
                  '-QAR${discount.toStringAsFixed(2)}',
                  color: Colors.green,
                ),
              const Divider(),
              _row(
                'Payable',
                'QAR${payable.toStringAsFixed(2)}',
                bold: true,
              ),

              const Divider(height: 30),

           
              Text(
                'Payment Method',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xffFFF4E6),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: const Color(0xffC17D4A)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.money,
                        color: Color(0xffC17D4A)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Cash on Delivery',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Icon(Icons.check_circle,
                        color: Color(0xffC17D4A)),
                  ],
                ),
              ),

              const SizedBox(height: 30),

         
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed:
                      address == null || isProcessing
                          ? null
                          : _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xffC17D4A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: isProcessing
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Place Order',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _row(String label, String value,
      {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight:
                  bold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight:
                  bold ? FontWeight.w600 : FontWeight.w400,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
