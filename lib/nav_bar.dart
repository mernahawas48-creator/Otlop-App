import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otlopapp/features/presentation/views/home_view.dart';
import 'package:otlopapp/features/cart/cart_view.dart';
import 'package:otlopapp/features/profile/profile_view.dart';

class NavBar extends StatefulWidget {
  NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 0;
  final List<Widget> pages = [
    HomeView(),
    const CartView(),
    const ProfileView(),
    const Center(child: Text('Settings Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          // Clip the BottomNavigationBar to respect the Container's border radius
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: BottomNavigationBar(
              selectedItemColor: Colors.red,
              selectedIconTheme: IconThemeData(color: Colors.red),

              currentIndex: currentIndex,
              onTap: (value) {
                print('Tapped on index: $value');
                currentIndex = value;
                setState(() {});
              },

              backgroundColor: Colors
                  .transparent, // Allow container background/shadow to show
              elevation: 0, // Disable internal shadow so custom BoxShadow works
              // fixedColor: Colors.red,
              type: BottomNavigationBarType
                  .fixed, // Ensure layout scales well with 4 items
              items: [
                BottomNavigationBarItem(
                  // activeIcon: Image.asset(
                  //   'assets/icons/home_icon.png',
                  //   color: Colors.red,
                  // ),
                  icon: Image.asset('assets/icons/home_icon.png'),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('assets/icons/shopping_cart_icon.png'),
                  // activeIcon: Image.asset(
                  //   'assets/icons/shopping_cart_icon.png',
                  //   color: Colors.red,
                  // ),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  activeIcon: Image.asset(
                    'assets/icons/profile_icon.png',
                    color: Colors.red,
                  ),
                  icon: Image.asset('assets/icons/profile_icon.png'),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  activeIcon: Image.asset(
                    'assets/icons/chat_icon.png',
                    color: Colors.red,
                  ),
                  icon: Image.asset('assets/icons/chat_icon.png'),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
      body: pages[currentIndex],
    );
  }
}
