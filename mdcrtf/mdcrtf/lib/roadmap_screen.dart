import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: RoadmapScreen(),
  ));
}

class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key});

  @override
  _RoadmapScreenState createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Your existing content
            Container(
              margin: const EdgeInsets.only(left: 44.0),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://rtfapi.modicare.com/img/tline.png"),
                  repeat: ImageRepeat.repeatY,
                  alignment: Alignment.topLeft,
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.43),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildNavItem("Today", 0),
                      buildNavItem("Upcoming", 1),
                      buildNavItem("Completed", 2),
                      buildNavItem("Overdue", 3),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 49, 0.0, 0.0),
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  buildTodayScreen(),
                  buildUpcomingScreen(),
                  buildCompletedScreen(),
                  buildOverdueScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRoadmapContent(String title, int points, String status,
      String imageUrl, {bool isPending = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0.0),
      child: Column(
        children: [
          Row(
            children: [
              Image.network(
                imageUrl,
                width: 100,
              ),
              const SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow),
                      const SizedBox(width: 4.0),
                      Text("$points pts"),
                      const SizedBox(width: 8.0),
                      if (isPending) ...[
                        const Icon(Icons.alarm, color: Colors.red),
                        const SizedBox(width: 4.0),
                        Text(status),
                      ] else
                        ...[
                          const Icon(Icons.thumb_up, color: Colors.green),
                          const SizedBox(width: 4.0),
                          Text(status),
                        ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTodayScreen() {
    return ListView(
      children: [
        buildRoadmapContent("Task 1", 5, "Completed",
            "https://rtfapi.modicare.com/img/today.png?a=56"),
        buildRoadmapContent("Task 2", 8, "Overdue",
            "https://rtfapi.modicare.com/img/today.png?a=56"),
        buildRoadmapContent("Task 3", 3, "Completed",
            "https://rtfapi.modicare.com/img/today.png?a=56"),
        buildRoadmapContent("Task 4", 6, "Completed",
            "https://rtfapi.modicare.com/img/today.png?a=56"),
        buildRoadmapContent("Task 5", 9, "Completed",
            "https://rtfapi.modicare.com/img/today.png?a=56"),
        buildRoadmapContent("Task 1", 5, "Completed",
            "https://rtfapi.modicare.com/img/today.png?a=56"),
        buildRoadmapContent("Task 2", 8, "Overdue",
            "https://rtfapi.modicare.com/img/today.png?a=56"),
        buildRoadmapContent("Task 3", 3, "Completed",
            "https://rtfapi.modicare.com/img/today.png?a=56"),
        buildRoadmapContent("Task 4", 6, "Completed",
            "https://rtfapi.modicare.com/img/today.png?a=56"),
        buildRoadmapContent("Task 5", 9, "Completed",
            "https://rtfapi.modicare.com/img/today.png?a=56"),
      ],
    );
  }

  Widget buildUpcomingScreen() {
    return ListView(
      children: [
        buildRoadmapContent("Upcoming Task 1", 4, "Upcoming",
            "https://rtfapi.modicare.com/img/upcoming.png?a=2"),
        buildRoadmapContent("Upcoming Task 2", 7, "Upcoming",
            "https://rtfapi.modicare.com/img/upcoming.png?a=2"),
        buildRoadmapContent("Upcoming Task 3", 2, "Upcoming",
            "https://rtfapi.modicare.com/img/upcoming.png?a=2"),
      ],
    );
  }

  Widget buildCompletedScreen() {
    return ListView(
      children: [
        buildRoadmapContent("Completed Task 1", 5, "Completed",
            "https://rtfapi.modicare.com/img/complete.png?a=2"),
        buildRoadmapContent("Completed Task 2", 8, "Completed",
            "https://rtfapi.modicare.com/img/complete.png?a=2"),
        buildRoadmapContent("Completed Task 3", 3, "Completed",
            "https://rtfapi.modicare.com/img/complete.png?a=2"),
      ],
    );
  }

  Widget buildOverdueScreen() {
    return ListView(
      children: [
        buildRoadmapContent("Overdue Task 1", 5, "Overdue",
            "https://rtfapi.modicare.com/img/today.png?a=56"),
        buildRoadmapContent("Overdue Task 2", 8, "Overdue",
            "https://rtfapi.modicare.com/img/today.png?a=56"),
        buildRoadmapContent("Overdue Task 3", 3, "Overdue",
            "https://rtfapi.modicare.com/img/today.png?a=56"),
      ],
    );
  }

  Widget buildNavItem(String text, int index) {
    Color normalColor = const Color(0xFF7B7B7B); // #7b7b7b
    Color selectedColor = const Color(0xFFF7A50A); // #f7a50a

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: () {
          _tabController.animateTo(index);
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          alignment: Alignment.center,
          backgroundColor: _tabController.index == index ? Colors.white : Colors
              .transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _tabController.index == index
                    ? const Color(0xFFF7A50A)
                    : Colors.transparent,
                width: 1,
              ),
            ),
          ),
          padding: const EdgeInsets.only(bottom: 3.0),
          // Adjust the value for the desired gap
          child: Text(
            text,
            style: TextStyle(
              color: _tabController.index == index
                  ? selectedColor
                  : normalColor,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}
