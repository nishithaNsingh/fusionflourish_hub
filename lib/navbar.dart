
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:fusionflourish_hub/screens/homescreen/homesceen.dart';



class NavBarScreen extends StatefulWidget {
  const NavBarScreen({Key? key}) : super(key: key);

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    // Add your different screens here
    HomeScreen(),
    // LearnScreen(),
    // CommunityMain(),
    // StoriesMain(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('FusionFlourish Hub'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Handle the button tap
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text('This is a snackbar')));
            },
          ),

        ],
      ),
      body: _tabs[_selectedIndex], // Display the selected tab content
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.black.withOpacity(0.3),
        color: Colors.black,
        activeColor: Colors.white24,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.book, title: 'Learn'),
          TabItem(icon: Icons.group, title: 'Community'),
          TabItem(icon: Icons.auto_stories, title: 'Stories'),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}