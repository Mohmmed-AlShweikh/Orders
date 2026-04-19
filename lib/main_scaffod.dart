import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatefulWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).location;

    if (location.startsWith('/profile')) return 1;
    if (location.startsWith('/settings')) return 2;
    return 0;
  }

  void onTap(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/profile');
        break;
      case 2:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final index = getCurrentIndex(context);

    return Scaffold(
      body: widget.child,

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: (i) => onTap(i, context),
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          backgroundColor: const Color(0xff0f172a),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: "Profile",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}
