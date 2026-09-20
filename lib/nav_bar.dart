import 'package:easy_localization/easy_localization.dart';
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

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeView(),
      const CartView(),
      const ProfileView(),
      SafeArea(child: Center(child: Text('nav.settings_page'.tr()))),
    ];

    return Scaffold(
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
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              label: 'nav.home'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: state.totalQuantity > 0,
                label: Text('${state.totalQuantity}'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              label: 'nav.cart'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              label: 'nav.profile'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.chat_bubble_outline),
              label: 'nav.settings'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
