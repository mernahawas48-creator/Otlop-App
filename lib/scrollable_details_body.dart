import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otlopapp/models/product_model.dart';
import 'package:otlopapp/product_details_body.dart';

class ScrollableDetailsBody extends StatelessWidget {
  const ScrollableDetailsBody({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Transform.translate(
        offset: const Offset(0, -20), // Slides the sheet up over the image
        child: Container(
          // Creates overlapping sheet effect
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Scroll Drag Indicator
                Center(child: Image.asset('assets/icons/Scroll_tool.png')),
                SizedBox(height: 25.h),

                // Action Row (Popular tag + Icons)
                Row(
                  children: [
                    Container(
                      width: 76.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffFFE6E6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Popular",
                          style: TextStyle(
                            color: Color(0xffD61355),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffFFE6E6),
                      ),
                      child: Center(
                        child: Image.asset('assets/icons/location.png'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: Center(
                        child: Image.asset('assets/icons/love.png'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Title
                ProductDetailsBody(
                  product: product,
                ), // Extra space at bottom for scrolling comfort
              ],
            ),
          ),
        ),
      ),
    );
  }
}
