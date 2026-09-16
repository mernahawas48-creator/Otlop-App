import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlopapp/features/cart/cart_cubit.dart';
import 'package:otlopapp/features/cart/cart_state.dart';
import 'package:otlopapp/features/cart/cart_view.dart';
import 'package:otlopapp/features/presentation/views/home_view.dart';
import 'package:otlopapp/features/profile/profile_view.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 0;
  final List<Widget> pages = [
    const HomeView(),
    const CartView(),
    const ProfileView(),
    const SafeArea(child: Center(child: Text('Settings Page'))),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: currentIndex, children: pages),
    bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
      builder: (context, state) => BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xffD61355),
        unselectedItemColor: const Color(0xffF39DAE),
        currentIndex: currentIndex,
        onTap: (value) => setState(() => currentIndex = value),
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: state.totalQuantity > 0,
              label: Text('${state.totalQuantity}'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Settings',
          ),
        ],
      ),
    ),
  );
}
