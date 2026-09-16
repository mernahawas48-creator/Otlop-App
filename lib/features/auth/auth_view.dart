import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlopapp/core/utils/back_button.dart';
import 'package:otlopapp/features/auth/cubit/sign_in_cubit.dart';
import 'package:otlopapp/features/auth/sign_in.dart';
import 'package:otlopapp/features/auth/sign_up.dart';

class AuthView extends StatefulWidget {
  final bool initialLogin;

  const AuthView({super.key, this.initialLogin = false});

  @override
  State<AuthView> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<AuthView> {
  late bool isLogin;

  @override
  void initState() {
    super.initState();
    isLogin = widget.initialLogin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 442,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/on_boarding_two.png'),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: CustomBackButton(
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.72,
            minChildSize: 0.48,
            maxChildSize: 0.94,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  color: Colors.white,
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        height: 6,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.red.shade200,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _AuthTab(
                          title: 'Create Account',
                          selected: !isLogin,
                          onTap: () => setState(() => isLogin = false),
                        ),
                        _AuthTab(
                          title: 'Login',
                          selected: isLogin,
                          onTap: () => setState(() => isLogin = true),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    if (isLogin)
                      BlocProvider<SignInCubit>(
                        create: (context) => SignInCubit(),
                        child: const SignInForm(),
                      )
                    else
                      const SignUpForm(),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AuthTab extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _AuthTab({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: selected ? const Color(0xFFE50046) : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: title == 'Login' ? 36 : 80,
            height: 2,
            color: selected ? const Color(0xFFE50046) : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
