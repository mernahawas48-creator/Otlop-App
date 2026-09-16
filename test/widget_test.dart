import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:otlopapp/core/storage/app_preferences.dart';
import 'package:otlopapp/core/widgets/product_image.dart';
import 'package:otlopapp/details_view.dart';
import 'package:otlopapp/features/auth/auth_view.dart';
import 'package:otlopapp/features/cart/cart_cubit.dart';
import 'package:otlopapp/features/presentation/cubit/products_cubit.dart';
import 'package:otlopapp/features/presentation/views/home_view.dart';
import 'package:otlopapp/models/product_model.dart';
import 'package:otlopapp/nav_bar.dart';
import 'package:otlopapp/on_boarding_view.dart';
import 'package:otlopapp/otlop_app.dart';

class LoadedProducts extends ProductsCubit {
  LoadedProducts(List<ProductModel> products) {
    emit(ProductsSucess(products: products));
  }
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppPreferences.init();
  });

  for (final seen in [false, true]) {
    testWidgets(
      'First frame opens ${seen ? 'auth' : 'onboarding'} without a Flutter splash',
      (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        if (seen) await AppPreferences.setOnboardingCompleted();
        await tester.pumpWidget(const Otlopapp());
        await tester.pump();
        expect(find.byType(seen ? AuthView : OnBoardingView), findsOneWidget);
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Image &&
                widget.image is AssetImage &&
                (widget.image as AssetImage).assetName.contains('splash_image'),
          ),
          findsNothing,
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }

  Widget host(
    ProductsCubit products,
    CartCubit cart, {
    Widget? home,
    double scale = 1,
  }) => MultiBlocProvider(
    providers: [
      BlocProvider.value(value: products),
      BlocProvider.value(value: cart),
    ],
    child: MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          padding: const EdgeInsets.only(top: 30, bottom: 24),
          textScaler: TextScaler.linear(scale),
        ),
        child: child!,
      ),
      home: home ?? const NavBar(),
      routes: {ProductDetailsView.routeName: (_) => const ProductDetailsView()},
    ),
  );

  testWidgets(
    'Market respects status bar, adds quantity, and keeps cart total above navigation',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final product = ProductModel(id: 1, title: 'Test product', price: 12.5);
      final products = LoadedProducts([product]);
      final cart = CartCubit();
      addTearDown(products.close);
      addTearDown(cart.close);
      await tester.pumpWidget(host(products, cart));
      await tester.pumpAndSettle();
      expect(
        tester.getTopLeft(find.text('Market')).dy,
        greaterThanOrEqualTo(30),
      );
      expect(find.text(r'$12.50'), findsOneWidget);
      await tester.tap(find.text('Add to Cart'));
      await tester.pump();
      await tester.tap(find.text('Add to Cart'));
      await tester.pump();
      expect(cart.state.totalQuantity, 2);
      expect(cart.state.totalPrice, 25);
      await tester.tap(find.text('Cart'));
      await tester.pumpAndSettle();
      expect(find.text(r'$25.00'), findsOneWidget);
      expect(
        tester.getBottomLeft(find.text('Proceed to Checkout')).dy,
        lessThan(tester.getTopLeft(find.byType(BottomNavigationBar)).dy),
      );
        await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'Details uses a large contained image, adds to cart and keeps Back visible after scrolling',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final product = ProductModel(
        id: 7,
        title: 'Test product',
        price: 9.5,
        description: List.filled(60, 'Product description.').join(' '),
      );
      final products = LoadedProducts([product]);
      final cart = CartCubit();
      addTearDown(products.close);
      addTearDown(cart.close);
      await tester.pumpWidget(host(products, cart, home: const HomeView()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Test product'));
      await tester.pumpAndSettle();
      final image = find.byType(ProductImage).first;
      expect(tester.widget<ProductImage>(image).fit, BoxFit.contain);
      expect(tester.getSize(image).height, greaterThan(250));
      expect(find.byTooltip('Back'), findsOneWidget);
      await tester.tap(find.text('Add to Cart'));
      await tester.pump();
      expect(cart.state.totalQuantity, 1);
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -450));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Back').hitTestable(), findsOneWidget);
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.text('Market'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('Narrow market with large text does not overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final products = LoadedProducts([
      ProductModel(
        id: 1,
        title: 'A long product name over multiple lines',
        price: 5,
      ),
    ]);
    final cart = CartCubit();
    addTearDown(products.close);
    addTearDown(cart.close);
    await tester.pumpWidget(
      host(products, cart, home: const HomeView(), scale: 2),
    );
    await tester.pumpAndSettle();
    expect(find.text('Add to Cart'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
