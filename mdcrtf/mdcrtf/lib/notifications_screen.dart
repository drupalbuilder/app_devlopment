import 'dart:convert';
import 'package:flutter/material.dart';
import 'infoscreen.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NotificationsScreen(),
    );
  }
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<NotificationData>> notificationsFuture;
  late Future<List<String>> categoriesFuture;
  String selectedCategory = 'All Notifications';

  @override
  void initState() {
    super.initState();
    notificationsFuture = fetchNotifications();
    categoriesFuture = fetchCategories();
  }

  Future<List<NotificationData>> fetchNotifications() async {
    final response = await http.get(Uri.parse('https://mdash.gprlive.com/api/notifications'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<NotificationData> notifications = data.map((json) => NotificationData.fromJson(json)).toList();
      return notifications;
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<List<String>> fetchCategories() async {
    final response = await http.get(Uri.parse('https://mdash.gprlive.com/api/categories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<String> categories = data.map((json) => json['name'] as String).toList();
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SafeArea(child: InfoScreen())),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([notificationsFuture, categoriesFuture]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: LoadingAnimationWidget.waveDots(color: Colors.blue, size: 100));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<NotificationData> notifications = snapshot.data![0];
            List<String> categories = snapshot.data![1];

            if (!categories.contains('All Notifications')) {
              categories.insert(0, 'All Notifications'); // Add 'All Notifications' if it doesn't exist
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft, // Align to the left
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue), // Blue border
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10), // Add padding for better appearance
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue!;
                        });
                      },
                      items: categories.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return NotificationCard(
                        notification: notifications[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationDetailScreen(notification: notifications[index]),
                            ),
                          );
                        },
                      );
                    },
                  ),  SizedBox(height: 0.0),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationData notification;
  final VoidCallback onTap;

  const NotificationCard({Key? key, required this.notification, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFF7B9),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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
                    backgroundImage: NetworkImage(notification.imageSrc),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(notification.timeAgo),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationDetailScreen extends StatelessWidget {
  final NotificationData notification;

  const NotificationDetailScreen({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Detail Screen'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(notification.description),
              const SizedBox(height: 8.0),
              Text('Time Ago: ${notification.timeAgo}'),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationData {
  final int id;
  final String imageSrc;
  final String title;
  final String description;
  final String timeAgo;

  NotificationData({
    required this.id,
    required this.imageSrc,
    required this.title,
    required this.description,
    required this.timeAgo,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'] as int,
      imageSrc: 'https://mdash.gprlive.com/${json['image']}' as String,
      title: json['name'] as String,
      description: json['description'] as String,
      timeAgo: 'Calculated from API data', // You can calculate time ago based on API data
    );
  }

  String get category => ''; // Implement category logic if needed
}
