import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final void Function()? onTap;
  CustomBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 238, 130, 130),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset('assets/icons/back_btn.png'),
      ),
    );
  }
}
