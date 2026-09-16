import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onTap;

  const OnBoardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Expanded(
              flex: 6,
              child: Image.asset(
                imagePath,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              description,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black54,
                height: 1.35,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 54.h,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50046),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 36.h),
          ],
        ),
      ),
    );
  }
}
