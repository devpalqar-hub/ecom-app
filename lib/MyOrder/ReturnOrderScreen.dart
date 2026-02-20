import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/MyOrder/Model/OrderDetailModel.dart';
import 'package:new_project/MyOrder/Service/OrderController.dart';

class ReturnOrderScreen extends StatefulWidget {
  final OrderDetailModel order;
  const ReturnOrderScreen({super.key, required this.order});

  @override
  State<ReturnOrderScreen> createState() => _ReturnOrderScreenState();
}

class _ReturnOrderScreenState extends State<ReturnOrderScreen> {
  final OrderController ctrl = Get.find<OrderController>();
  final TextEditingController _reasonCtrl = TextEditingController();

  // orderItemId → selected quantity
  final Map<String, int> _selectedItems = {};

  // eligible items = not already returned
  late final List<OrderItem> _eligibleItems;
  int totalItem = 0;

  @override
  void initState() {
    super.initState();
    _eligibleItems = widget.order.items.where((i) => !i.isReturn).toList();
    totalItem = widget.order.items.length;
  }

  @override
  void dispose() {
    _reasonCtrl.dispose();
    super.dispose();
  }

  bool get _allSelected =>
      _eligibleItems.every((i) => _selectedItems.containsKey(i.id));

  String get _returnType =>
      (_selectedItems.length == totalItem) ? "full" : "partial";

  bool get _canSubmit =>
      _selectedItems.isNotEmpty && _reasonCtrl.text.trim().isNotEmpty;

  void _toggleItem(OrderItem item) {
    setState(() {
      if (_selectedItems.containsKey(item.id)) {
        _selectedItems.remove(item.id);
      } else {
        _selectedItems[item.id] = item.quantity; // default = full qty
      }
    });
  }

  void _setQty(String itemId, int qty) {
    setState(() => _selectedItems[itemId] = qty);
  }

  Future<void> _submit() async {
    if (!_canSubmit) {
      Get.snackbar(
        'Incomplete',
        'Select at least one item and enter a reason.',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final items = _selectedItems.entries.map((e) {
      return {
        "orderItemId": e.key,
        "quantity": e.value,
        "reason": _reasonCtrl.text.trim(),
      };
    }).toList();

    final ok = await ctrl.submitReturn(
      orderId: widget.order.id,
      returnType: _returnType,
      reason: _reasonCtrl.text.trim(),
      items: items,
    );

    if (ok) {
      Get.back(); // close ReturnOrderScreen
      Get.snackbar(
        'Return Requested',
        'Your return request has been submitted successfully.',
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade800,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Failed',
        'Could not submit return request. Please try again.',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: Get.back,
        ),
        title: Text(
          "Return Order",
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── info banner ──
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4E6),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Color(0xFFAE933F),
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              "Select the items you want to return. Selecting all items will create a full return. A return charge will be deducted from the item refund amount.",
                              style: GoogleFonts.montserrat(
                                fontSize: 11.sp,
                                color: Color(0xFFAE933F),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // ── return type badge ──
                    if (_selectedItems.isNotEmpty)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: _allSelected
                                ? Colors.green.shade50
                                : Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            _allSelected ? "Full Return" : "Partial Return",
                            style: GoogleFonts.montserrat(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: _allSelected
                                  ? Colors.green.shade700
                                  : Colors.orange.shade700,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 12.h),

                    // ── item list ──
                    Text(
                      "Select Items",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    ..._eligibleItems.map((item) {
                      final isSelected = _selectedItems.containsKey(item.id);
                      final imgUrl = item.product.images.isNotEmpty
                          ? item.product.images.first.url
                          : null;

                      return GestureDetector(
                        onTap: () => _toggleItem(item),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.only(bottom: 12.h),
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFAE933F)
                                  : Colors.grey.shade200,
                              width: isSelected ? 1.5 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // checkbox
                              Container(
                                width: 22.w,
                                height: 22.w,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFAE933F)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFFAE933F)
                                        : Colors.grey.shade400,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: isSelected
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 14.sp,
                                      )
                                    : null,
                              ),
                              SizedBox(width: 10.w),

                              // image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: imgUrl != null
                                    ? Image.network(
                                        imgUrl,
                                        width: 50.w,
                                        height: 50.w,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        width: 50.w,
                                        height: 50.w,
                                        color: Colors.grey.shade100,
                                        child: Icon(
                                          Icons.photo,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                              ),
                              SizedBox(width: 10.w),

                              // name + qty
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      "Available Qty: ${item.quantity}",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.grey,
                                        fontSize: 11.sp,
                                      ),
                                    ),

                                    // quantity selector shown only when selected
                                    // if (isSelected && item.quantity > 1) ...[
                                    //   SizedBox(height: 8.h),
                                    //   Row(
                                    //     children: [
                                    //       Text(
                                    //         "Return Qty:",
                                    //         style: GoogleFonts.montserrat(
                                    //           fontSize: 11.sp,
                                    //           color: Colors.black54,
                                    //         ),
                                    //       ),
                                    //       SizedBox(width: 8.w),
                                    //       _qtyButton(
                                    //         icon: Icons.remove,
                                    //         onTap: () {
                                    //           final cur =
                                    //               _selectedItems[item.id]!;
                                    //           if (cur > 1)
                                    //             _setQty(item.id, cur - 1);
                                    //         },
                                    //       ),
                                    //       SizedBox(width: 8.w),
                                    //       Text(
                                    //         "${_selectedItems[item.id]}",
                                    //         style: GoogleFonts.montserrat(
                                    //           fontSize: 13.sp,
                                    //           fontWeight: FontWeight.w600,
                                    //         ),
                                    //       ),
                                    //       SizedBox(width: 8.w),
                                    //       _qtyButton(
                                    //         icon: Icons.add,
                                    //         onTap: () {
                                    //           final cur =
                                    //               _selectedItems[item.id]!;
                                    //           if (cur < item.quantity)
                                    //             _setQty(item.id, cur + 1);
                                    //         },
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ],
                                  ],
                                ),
                              ),
                              Text(
                                "QAR ${item.product.discountedPrice}",
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    SizedBox(height: 20.h),

                    // ── reason field ──
                    Text(
                      "Reason for Return",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      controller: _reasonCtrl,
                      maxLines: 4,
                      onChanged: (_) => setState(() {}),
                      style: GoogleFonts.montserrat(fontSize: 13.sp),
                      decoration: InputDecoration(
                        hintText:
                            "Describe the reason for returning this order...",
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 12.sp,
                          color: Colors.grey.shade400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: const BorderSide(
                            color: Color(0xFFAE933F),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 12.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // ── selected summary ──
                    if (_selectedItems.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Return Summary",
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            ..._selectedItems.entries.map((e) {
                              final item = _eligibleItems.firstWhere(
                                (i) => i.id == e.key,
                              );
                              return Padding(
                                padding: EdgeInsets.only(bottom: 4.h),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.product.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 11.sp,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Qty: ${e.value}",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFAE933F),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),

            // ── submit button ──
            Obx(
              () => Container(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 30.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _canSubmit
                          ? const Color(0xFFAE933F)
                          : Colors.grey.shade300,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    onPressed: ctrl.isReturnLoading.value ? null : _submit,
                    child: ctrl.isReturnLoading.value
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : Text(
                            "Submit Return Request",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24.w,
        height: 24.w,
        decoration: BoxDecoration(
          color: const Color(0xFFAE933F).withOpacity(0.1),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Icon(icon, size: 14.sp, color: const Color(0xFFAE933F)),
      ),
    );
  }
}
