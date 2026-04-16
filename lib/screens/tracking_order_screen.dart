import 'package:flutter/material.dart';
import 'order_screen.dart';

class AppTheme {
  static const Color black    = Color(0xFF0D0D0D);
  static const Color gold     = Color(0xFFC4963D);
  static const Color darkGold = Color(0xFF8C6E3F);
  static const Color darkBg   = Color(0xFF0D0D0D);
  static const Color white    = Colors.white;
}

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          }
                    
        ),
        title: const Text(
          "Track Order",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.black,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order Number",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Order #FD - 2024 - 006",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(color: AppTheme.darkGold, thickness: 0.5),
                  const SizedBox(height: 15),
                  // Delivery Person Info
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppTheme.darkGold.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.person,
                          color: AppTheme.gold,
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Delivery Person",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "Rajesh Kumar",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.gold.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.call,
                          color: AppTheme.gold,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // Tracking Timeline Title
            const Text(
              "Order Status",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Timeline
            _buildTimelineItem(
              title: "Order Placed",
              description: "We have received your order.",
              time: "2 Hours ago",
              isActive: false, 
              isLast: false,
            ),
            _buildTimelineItem(
              title: "Order Processing",
              description: "We are preparing your order.",
              time: "In Progress",
              isActive: true, // Current Step
              isLast: false,
            ),
            _buildTimelineItem(
              title: "Shipped",
              description: "Your order is on the way.",
              time: "Pending",
              isActive: false, // Pending
              isLast: false,
            ),
            _buildTimelineItem(
              title: "Delivered",
              description: "Order has been delivered.",
              time: "Pending",
              isActive: false, // Pending
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String description,
    required String time,
    required bool isActive,
    required bool isLast,
  }) {
    return SizedBox(
      height: 110, // Fixed height for consistent spacing
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Side: Line and Icon
          SizedBox(
            width: 30,
            child: Column(
              children: [
                // Icon Container
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive 
                        ? AppTheme.gold 
                        : AppTheme.darkGold,
                    border: isActive 
                        ? Border.all(color: AppTheme.gold, width: 2)
                        : null,
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppTheme.gold.withOpacity(0.4),
                              spreadRadius: 2,
                              blurRadius: 5,
                            )
                          ]
                        : null,
                  ),
                  child: Center(
                    child: isActive
                        ? const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.check, color: Colors.white, size: 14),
                  ),
                ),
                // Vertical Line
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast 
                        ? Colors.transparent 
                        : (isActive ? AppTheme.gold.withOpacity(0.3) : AppTheme.darkGold.withOpacity(0.3)),
                    margin: const EdgeInsets.only(top: 5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          
          // Right Side: Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? AppTheme.gold : Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive ? AppTheme.gold : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}