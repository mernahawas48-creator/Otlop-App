import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otlopapp/details_view.dart';
import 'package:otlopapp/features/auth/auth_view.dart';
import 'package:otlopapp/features/presentation/cubit/products_cubit.dart';
import 'package:otlopapp/core/storage/app_preferences.dart';
import 'package:otlopapp/nav_bar_view.dart';
import 'package:otlopapp/on_boarding_view.dart';
import 'package:otlopapp/features/cart/cart_cubit.dart';

class Otlopapp extends StatelessWidget {
  const Otlopapp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      splitScreenMode: true,
      minTextAdapt: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ProductsCubit()..getAllProducts()),

          BlocProvider(create: (context) => CartCubit()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => AppPreferences.hasSeenOnboarding
                ? const AuthView()
                : const OnBoardingView(),
            '/onboarding': (context) => const OnBoardingView(),
            '/auth': (context) {
              final showLogin =
                  ModalRoute.of(context)?.settings.arguments == true;
              return AuthView(initialLogin: showLogin);
            },
            '/nav': (context) => const NavBarView(),
            ProductDetailsView.routeName: (context) => ProductDetailsView(),
          },
          title: 'Otlob',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFE50046),
            ),
            useMaterial3: true,
          ),
        ),
      ),
    );
  }
}
