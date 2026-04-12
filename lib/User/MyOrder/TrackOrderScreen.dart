import 'package:flutter/material.dart';



class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  final String orderId = "#124";
  final List<Map<String, dynamic>> orderSteps = const [
    {"title": "Order Confirmed", "date": "Wed, 11th Jan", "status": "done"},
    {"title": "Order Dispatched", "date": "Wed, 11th Jan", "status": "done"},
    {"title": "Shipped", "date": "Wed, 11th Jan", "status": "pending"},
    {"title": "Out of Delivery", "date": "Wed, 11th Jan", "status": "pending"},
    {"title": "Delivered", "date": "Wed, 11th Jan", "status": "pending"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Track my Order',
         style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.png'),
              radius: 16,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      

            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: 'Order Id: ',
                style: const TextStyle(color: Colors.black, fontSize: 16),
                children: [
                  TextSpan(
                    text: orderId,
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

          
            ...List.generate(orderSteps.length, (index) {
              final step = orderSteps[index];
              final isDone = step["status"] == "done";
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isDone ? Colors.red : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (index != orderSteps.length - 1)
                        Container(width: 2, height: 40, color: Colors.grey.shade400),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step["title"],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isDone ? Colors.green : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        step["date"],
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                    ],
                  )
                ],
              );
            }),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffF83758),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Done', style: TextStyle(fontSize: 16,color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  
}
