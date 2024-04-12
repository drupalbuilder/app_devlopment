import 'package:flutter/material.dart';
import 'infoscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NotificationsScreen(),
    );
  }
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<String> categories = [
    'All Notifications',
    'Product Training',
    'Management Speak',
    'How-Tos',
    'Business Promotions',
    'Business 101',
    'Product',
  ];

  String selectedCategory = 'All Notifications';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.43),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.info),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => InfoScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: 150.0, // Adjust the width as needed
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            border: Border.all(color: Colors.black),
                            color: Colors.white,
                          ),
                          child: DropdownButton<String>(
                            value: selectedCategory,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedCategory = newValue;
                                });
                                // Add logic to filter notifications based on the selected category
                              }
                            },
                            items: categories.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            underline: Container(
                              height: 0, // Remove the underline
                            ),
                            isExpanded: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          const NotificationCard(
            id: 1,
            imageSrc: 'https://rtfapi.modicare.com/img/RoadMapSelected@2x.png',
            title: 'Product Training',
            description: 'Active 80: Cardboard Demo',
            timeAgo: '3 days ago',
          ),

          const NotificationCard(
            id: 2,
            imageSrc: 'https://rtfapi.modicare.com/img/RoadMapSelected@2x.png',
            title: 'Product Training',
            description: 'Active 80: Cardboard Demo',
            timeAgo: '3 days ago',
          ),
          const NotificationCard(
            id: 3,
            imageSrc: 'https://rtfapi.modicare.com/img/RoadMapSelected@2x.png',
            title: 'Product Training',
            description: 'Active 80: Cardboard Demo',
            timeAgo: '4 days ago',
          ),
          const NotificationCard(
            id: 4,
            imageSrc: 'https://rtfapi.modicare.com/img/RoadMapSelected@2x.png',
            title: 'Product Training',
            description: 'Active 80: Cardboard Demo',
            timeAgo: '6 months ago',
          ),
          const NotificationCard(
            id: 5,
            imageSrc: 'https://rtfapi.modicare.com/img/RoadMapSelected@2x.png',
            title: 'Product Training',
            description: 'Active 80: Cardboard Demo',
            timeAgo: '8 days ago',
          ),
          const NotificationCard(
            id: 6,
            imageSrc: 'https://rtfapi.modicare.com/img/RoadMapSelected@2x.png',
            title: 'Product Training',
            description: 'Active 80: Cardboard Demo',
            timeAgo: '15 days ago',
          ),
          const NotificationCard(
            id: 7,
            imageSrc: 'https://rtfapi.modicare.com/img/RoadMapSelected@2x.png',
            title: 'Product Training',
            description: 'Active 80: Cardboard Demo',
            timeAgo: '25 days ago',
          ),
          const NotificationCard(
            id: 8,
            imageSrc: 'https://rtfapi.modicare.com/img/RoadMapSelected@2x.png',
            title: 'Product Training',
            description: 'Active 80: Cardboard Demo',
            timeAgo: '1 months ago',
          ),
          const NotificationCard(
            id: 9,
            imageSrc: 'https://rtfapi.modicare.com/img/RoadMapSelected@2x.png',
            title: 'Product Training',
            description: 'Active 80: Cardboard Demo',
            timeAgo: '1 months ago',
          ),
          const NotificationCard(
            id: 10,
            imageSrc: 'https://rtfapi.modicare.com/img/RoadMapSelected@2x.png',
            title: 'Product Training',
            description: 'Active 80: Cardboard Demo',
            timeAgo: '3 months ago',
          ),
          const NotificationCard(
            id: 11,
            imageSrc: 'https://rtfapi.modicare.com/img/RoadMapSelected@2x.png',
            title: 'Product Training',
            description: 'Active 80: Cardboard Demo',
            timeAgo: '2 months ago',
          ),
          const NotificationCard(
            id: 12,
            imageSrc: 'https://rtfapi.modicare.com/img/RoadMapSelected@2x.png',
            title: 'Product Training',
            description: 'Active 80: Cardboard Demo',
            timeAgo: '3 months ago',
          ),
          const NotificationCard(
            id: 13,
            imageSrc: 'https://rtfapi.modicare.com/img/RoadMapSelected@2x.png',
            title: 'Product Training',
            description: 'Active 80: Cardboard Demo',
            timeAgo: '3 months ago',
          ),
          const NotificationCard(
            id: 14,
            imageSrc: 'https://rtfapi.modicare.com/img/RoadMapSelected@2x.png',
            title: 'Product Training',
            description: 'Active 80: Cardboard Demo',
            timeAgo: '3 months ago',
          ),
          const NotificationCard(
            id: 15,
            imageSrc: 'https://rtfapi.modicare.com/img/RoadMapSelected@2x.png',
            title: 'Product Training',
            description: 'Active 80: Cardboard Demo',
            timeAgo: '3 months ago',
          ),
          const NotificationCard(
            id: 16,
            imageSrc: 'https://rtfapi.modicare.com/img/RoadMapSelected@2x.png',
            title: 'Product Training',
            description: 'Active 80: Cardboard Demo',
            timeAgo: '3 months ago',
          ),
          const NotificationCard(
            id: 17,
            imageSrc: 'https://rtfapi.modicare.com/img/RoadMapSelected@2x.png',
            title: 'Product Training',
            description: 'Active 80: Cardboard Demo',
            timeAgo: '2 months ago',
          ),
          const NotificationCard(
            id: 18,
            imageSrc: 'https://rtfapi.modicare.com/img/RoadMapSelected@2x.png',
            title: 'Product Training',
            description: 'Active 80: Cardboard Demo',
            timeAgo: '2 months ago',
          ),

        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final int id;
  final String imageSrc;
  final String title;
  final String description;
  final String timeAgo;

  const NotificationCard({super.key,
    required this.id,
    required this.imageSrc,
    required this.title,
    required this.description,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFF7B9),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationDetailScreen(id: id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 22.0,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(imageSrc),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(description),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(timeAgo),
                  const SizedBox(height: 8.0),
                  IconButton(
                    icon: Transform.rotate(
                      angle: 272 * (3.141592653589793238462 / 180),
                      child: Image.network(
                        'https://rtfapi.modicare.com/img/CloseButton@3x.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                    onPressed: () {
                      // Handle close button click
                    },
                  ),                ],
              ),
            ],
          ),        ),
      ),
    );
  }
}




class NotificationDetailScreen extends StatelessWidget {
  final int id;

  const NotificationDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    // Fetch notification details based on the id
    String notificationDetails = "Notification Details for ID: $id";

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                color: const Color.fromARGB(255, 255, 255, 255),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.43),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 40, 40, 40)),
                    onPressed: () {
                      Navigator.pop(context); // Navigate back when pressed
                    },
                  ),
                  const Text(
                    'Notification Detail Screen',
                    style: TextStyle(
                      color: Color.fromARGB(255, 40, 40, 40),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Text(notificationDetails),
              ),
            ),
          ],
        ),
      ),
    );
  }
}