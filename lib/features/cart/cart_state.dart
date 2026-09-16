import 'package:otlopapp/models/product_model.dart';

class CartItem {
  final ProductModel product;
  final int quantity;

  CartItem({required this.product, this.quantity = 1});

  CartItem copyWith({int? quantity}) {
    return CartItem(product: product, quantity: quantity ?? this.quantity);
  }
}

class CartState {
  final List<CartItem> items;

  const CartState({this.items = const []});

  double get totalPrice {
    double total = 0;

    for (final item in items) {
      total += (item.product.price?.toDouble() ?? 0) * item.quantity;
    }

    return total;
  }

  int get totalQuantity {
    return items.fold(0, (total, item) => total + item.quantity);
  }
}
