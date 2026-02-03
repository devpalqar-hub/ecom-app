import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_project/CartScreen/AddressFormScreen.dart';
import 'package:new_project/CartScreen/Services/CheckoutController.dart';
class AddressListScreen extends StatefulWidget {
  const AddressListScreen({super.key});

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  final CheckoutController controller = Get.put(CheckoutController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const BackButton(color: Colors.black),
          title: const Text(
            ' Delivery Address',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: Obx(() {

          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

      
          if (controller.error.value != null) {
            return Center(
              child: Text(
                controller.error.value!,
                style: TextStyle(color: Colors.red, fontSize: 14.sp),
              ),
            );
          }


          if (controller.addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No addresses found',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    width: 160.w,
                    height: 46.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffC47C47),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      onPressed: () async {
                        final added = await Get.to(() => const AddressFormScreen());
                        if (added == true) {
                          controller.fetchAddresses();
                        }
                      },
                      child: Text(
                        'Add Address',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.addresses.length,
            itemBuilder: (context, index) {
              final address = controller.addresses[index];

              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                     color: const Color.fromARGB(255, 248, 238, 229),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 6.r,
                      offset: Offset(0, 3.h),
                    ),
                  ],
                  border: Border.all(color: Color(0xffC47C47)),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  title: Text(
                    address.name,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
                  ),
                  subtitle: Text(
                    '${address.address}, ${address.city}, ${address.state} - ${address.postalCode}',
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                  trailing: address.isDefault
                      ? Icon(Icons.check_circle, color: Colors.green, size: 22.sp)
                      : null,
                  onTap: () {
                    Get.back(result: address.id);
                  },
                ),
              );
            },
          );
        }),
        floatingActionButton: SizedBox(
          width: 56.w,
          height: 56.w,
          child: FloatingActionButton(
            onPressed: () async {
              final added = await Get.to(() => const AddressFormScreen());
              if (added == true) {
                controller.fetchAddresses();
              }
            },
            backgroundColor: const Color(0xffC47C47),
            child: Icon(Icons.add, size: 28.sp, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
