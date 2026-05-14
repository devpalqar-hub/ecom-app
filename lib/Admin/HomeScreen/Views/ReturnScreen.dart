import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_project/Admin/HomeScreen/Model/ReturnOrderModel.dart';
import 'package:new_project/Admin/HomeScreen/Service/DeliveryController.dart';
import 'package:new_project/Admin/HomeScreen/Service/ReturnOrderController.dart';
import 'package:new_project/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ProcessReturnScreen extends StatefulWidget {
  final ReturnOrder returnOrder;

  const ProcessReturnScreen({
    super.key,
    required this.returnOrder,
  });

  @override
  State<ProcessReturnScreen> createState() =>
      _ProcessReturnScreenState();
}

class _ProcessReturnScreenState
    extends State<ProcessReturnScreen> {
  late ReturnOrder _currentReturnOrder;
  late String currentStatus;

  final deliveryController controller = Get.find();

  @override
  void initState() {
    super.initState();
    _currentReturnOrder = widget.returnOrder;
    currentStatus = _currentReturnOrder.status;
  }

  bool get isPendingOrApproved {
    final status = currentStatus.toLowerCase();
    return status == "pending" || status == "approved";
  }

  // ================= CALL CUSTOMER =================

  void _callCustomer(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showAppNotification(
        "Cannot make call to $phone",
        type: AppNotificationType.error,
      );
    }
  }

  // ================= OPEN MAP =================

  void _openMap(String address) async {
    final query = Uri.encodeComponent(address);

    final uri = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=$query",
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showAppNotification(
        "Could not open Google Maps",
        type: AppNotificationType.error,
      );
    }
  }

  // ================= UPDATE STATUS =================

  void _showStatusUpdateSheet() {
    if (Get.isBottomSheetOpen ?? false) return;

    String? selectedStatus;
    String? selectedMethod;

    final TextEditingController reasonController =
        TextEditingController();

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          bool canSubmit = false;

          if (selectedStatus == 'rejected' &&
              reasonController.text.trim().isNotEmpty) {
            canSubmit = true;
          } else if (selectedStatus == 'refunded' &&
              selectedMethod != null &&
              reasonController.text.trim().isNotEmpty) {
            canSubmit = true;
          }

          return SafeArea(
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(22.r),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Text(
                      "Update Return Status",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Row(
                      children: [
                        Expanded(
                          child: _radioOptionTile(
                            title: "Refund",
                            value: "refunded",
                            groupValue: selectedStatus,
                            onTap: () {
                              setModalState(() {
                                selectedStatus = "refunded";
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ),

                        SizedBox(width: 12.w),

                        Expanded(
                          child: _radioOptionTile(
                            title: "Reject",
                            value: "rejected",
                            groupValue: selectedStatus,
                            onTap: () {
                              setModalState(() {
                                selectedStatus = "rejected";
                                selectedMethod = null;
                              });
                            },
                            activeColor: Colors.red,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    if (selectedStatus == 'refunded') ...[
                      _radioOptionTile(
                        title: "Cash",
                        value: "cash",
                        groupValue: selectedMethod,
                        onTap: () {
                          setModalState(() {
                            selectedMethod = "cash";
                          });
                        },
                        activeColor: const Color(0xff1E5CC6),
                      ),

                      SizedBox(height: 10.h),

                      _radioOptionTile(
                        title: "Online",
                        value: "online",
                        groupValue: selectedMethod,
                        onTap: () {
                          setModalState(() {
                            selectedMethod = "online";
                          });
                        },
                        activeColor: const Color(0xff1E5CC6),
                      ),

                      SizedBox(height: 20.h),
                    ],

                    TextField(
                      controller: reasonController,
                      onChanged: (_) {
                        setModalState(() {});
                      },
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Enter notes",
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12.r),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: !canSubmit
                            ? null
                            : () async {
                                controller.returnLoading = true;
                                controller.update();

                                Get.back();

                                String paymentMethod =
                                    selectedStatus == 'refunded'
                                        ? selectedMethod!
                                        : "none";

                                bool success =
                                    await controller
                                        .updateReturnStatus(
                                  returnId:
                                      _currentReturnOrder.id,
                                  status: selectedStatus!,
                                  returnPaymentMethod:
                                      paymentMethod,
                                  adminNotes:
                                      reasonController.text
                                          .trim(),
                                );

                                controller.returnLoading =
                                    false;
                                controller.update();

                                if (!mounted) return;

                                if (success) {
                                  setState(() {
                                    currentStatus =
                                        selectedStatus!;

                                    _currentReturnOrder =
                                        _currentReturnOrder
                                            .copyWith(
                                      status:
                                          selectedStatus,
                                      returnPaymentMethod:
                                          paymentMethod,
                                      adminNotes:
                                          reasonController
                                              .text
                                              .trim(),
                                    );
                                  });

                                  showAppNotification(
                                    "Return updated successfully",
                                    type:
                                        AppNotificationType
                                            .success,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xff1E5CC6),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14.r),
                          ),
                        ),
                        child: Text(
                          "Submit Update",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  // ================= RADIO TILE =================

  Widget _radioOptionTile({
    required String title,
    required String value,
    required String? groupValue,
    required VoidCallback onTap,
    required Color activeColor,
  }) {
    final isSelected = groupValue == value;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? activeColor
                : Colors.grey.shade300,
            width: 1.5,
          ),
          color: isSelected
              ? activeColor.withOpacity(.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? activeColor
                      : const Color(0xff344054),
                ),
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: isSelected
                  ? activeColor
                  : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // ================= DETAIL CHIP =================

  Widget _detailChip({
    required String text,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xffD0D5DD),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xff344054),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shipping =
        _currentReturnOrder.order.shippingAddress;

    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: isPendingOrApproved
          ? SafeArea(
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  16.w,
                  12.h,
                  16.w,
                  22.h,
                ),
                child: SizedBox(
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: _showStatusUpdateSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xff1E5CC6),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Text(
                      "Process Return (QAR ${_currentReturnOrder.refundAmount})",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================

              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back,
                      size: 22.sp,
                    ),
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Process Return",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        SizedBox(height: 2.h),

                        Text(
                          "Order #${_currentReturnOrder.order.orderNumber}",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color:
                                const Color(0xff667085),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 26.h),

              // ================= CUSTOMER =================

              Text(
                "PICKUP LOCATION",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff98A2B3),
                ),
              ),

              SizedBox(height: 14.h),

              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentReturnOrder
                              .customerProfile.name,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),

                        SizedBox(height: 6.h),

                        GestureDetector(
                          onTap: () => _callCustomer(
                            _currentReturnOrder
                                .customerProfile
                                .phone,
                          ),
                          child: Text(
                            _currentReturnOrder
                                .customerProfile
                                .phone,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color:
                                  const Color(0xff2F80ED),
                            ),
                          ),
                        ),

                        SizedBox(height: 6.h),

                        Text(
                          "${shipping?.address ?? ''}, ${shipping?.city ?? ''}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color:
                                const Color(0xff475467),
                          ),
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () => _callCustomer(
                      _currentReturnOrder
                          .customerProfile.phone,
                    ),
                    child: Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: const BoxDecoration(
                        color: Color(0xffEAF2FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.call,
                        color: const Color(0xff2F80ED),
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 22.h),

              // ================= MAP =================

              GestureDetector(
                onTap: () => _openMap(
                  "${shipping?.address ?? ''}, ${shipping?.city ?? ''}",
                ),
                child: Container(
                  height: 160.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(18.r),
                    image: const DecorationImage(
                      image: AssetImage(
                        "assets/map.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // ================= ORDER DETAILS =================
// ================= ORDER DETAILS =================

Text(
  "ORDER DETAILS",
  style: TextStyle(
    fontSize: 14.sp,
    letterSpacing: 1.1,
    fontWeight: FontWeight.w600,
    color: const Color(0xff98A2B3),
  ),
),

SizedBox(height: 14.h),

Column(
  children: _currentReturnOrder.returnItems.map((returnItem) {
    final orderItem = returnItem.orderItem;
    final product = orderItem.product;

    // ================= SAFE VARIATION =================

    ProductVariation? variation;

    final variations = product.variations;

    if (variations.isNotEmpty &&
        (orderItem.productVariationId?.isNotEmpty ?? false)) {
      try {
        variation = variations.firstWhere(
          (e) => e.id == orderItem.productVariationId,
        );
      } catch (_) {
        variation = null;
      }
    }

    final attributes = variation?.attributes;

    final size = attributes?.size ?? "";

    final colorName = attributes?.color?.name ?? "";

    final colorHex = attributes?.color?.hex ?? "";

    // ================= SAFE IMAGE =================

    String imageUrl = "";

    if (product.images.isNotEmpty) {
      imageUrl = product.images.first.url;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Colors.white,
                  image: imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: imageUrl.isEmpty
                    ? Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey.shade400,
                      )
                    : null,
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff101828),
                      ),
                    ),

                    SizedBox(height: 6.h),

                    Text(
                      "Price: QAR ${orderItem.discountedPrice}",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xff475467),
                      ),
                    ),

                    SizedBox(height: 6.h),

                    Wrap(
                      spacing: 8.w,
                      runSpacing: 6.h,
                      crossAxisAlignment:
                          WrapCrossAlignment.center,
                      children: [
                        Text(
                          "Qty: ${orderItem.quantity}",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xff475467),
                          ),
                        ),

                        // ================= SIZE =================

                        if (size.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(
                                6.r,
                              ),
                            ),
                            child: Text(
                              "Size: $size",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight:
                                    FontWeight.w500,
                                color:
                                    const Color(0xff344054),
                              ),
                            ),
                          ),

                        // ================= COLOR =================

                        if (colorName.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(
                                6.r,
                              ),
                            ),
                            child: Row(
                              mainAxisSize:
                                  MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12.w,
                                  height: 12.w,
                                  decoration:
                                      BoxDecoration(
                                    shape:
                                        BoxShape.circle,
                                    color:
                                        colorHex.isNotEmpty
                                            ? Color(
                                                int.parse(
                                                  colorHex
                                                      .replaceAll(
                                                    "#",
                                                    "0xff",
                                                  ),
                                                ),
                                              )
                                            : Colors.grey,
                                    border: Border.all(
                                      color: Colors
                                          .grey.shade300,
                                    ),
                                  ),
                                ),

                                SizedBox(width: 5.w),

                                Text(
                                  colorName,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight:
                                        FontWeight.w500,
                                    color:
                                        const Color(
                                      0xff344054,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Divider(color: Colors.grey.shade300),

          SizedBox(height: 8.h),

          Text(
            "Reason: ${returnItem.reason}",
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xff475467),
            ),
          ),

          SizedBox(height: 10.h),

          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 5.h,
                ),
                decoration: BoxDecoration(
                  color:
                      _currentReturnOrder.status
                                  .toLowerCase() ==
                              'rejected'
                          ? Colors.red.withOpacity(.1)
                          : Colors.green
                              .withOpacity(.1),
                  borderRadius:
                      BorderRadius.circular(20.r),
                ),
                child: Text(
                  _currentReturnOrder.status
                      .toUpperCase(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color:
                        _currentReturnOrder.status
                                    .toLowerCase() ==
                                'rejected'
                            ? Colors.red
                            : Colors.green,
                  ),
                ),
              ),

              const Spacer(),

              Text(
                "Payment: ${_currentReturnOrder.returnPaymentMethod ?? 'N/A'}",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xff344054),
                ),
              ),
            ],
          ),

          // ================= NOTES =================

          if ((_currentReturnOrder.adminNotes ?? "")
              .isNotEmpty) ...[
            SizedBox(height: 10.h),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(10.r),
              ),
              child: Text(
                "Notes: ${_currentReturnOrder.adminNotes}",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xff667085),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }).toList(),
),



            ],
          ),
        ),
      ),
    );
  }
}