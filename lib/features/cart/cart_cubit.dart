import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlopapp/features/cart/cart_state.dart';
import 'package:otlopapp/models/product_model.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addProduct(ProductModel product) {
    final items = List<CartItem>.from(state.items);

    final index = items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    } else {
      items.add(CartItem(product: product));
    }

    emit(CartState(items: items));
  }

  void increaseQuantity(ProductModel product) {
    addProduct(product);
  }

  void decreaseQuantity(ProductModel product) {
    final items = List<CartItem>.from(state.items);

    final index = items.indexWhere((item) => item.product.id == product.id);

    if (index == -1) return;

    if (items[index].quantity > 1) {
      items[index] = items[index].copyWith(quantity: items[index].quantity - 1);
    } else {
      items.removeAt(index);
    }

    emit(CartState(items: items));
  }

  void removeProduct(ProductModel product) {
    final items = List<CartItem>.from(state.items);

    items.removeWhere((item) => item.product.id == product.id);

    emit(CartState(items: items));
  }

  void clearCart() {
    emit(const CartState());
  }
}
