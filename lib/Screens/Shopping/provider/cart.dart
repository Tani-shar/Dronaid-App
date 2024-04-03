import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final int price;
  final double weight;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.weight,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'quantity': this.quantity,
      'price': this.price,
      'weight': weight,
    };
  }

  factory CartItem.fromMap(Map<dynamic, dynamic> map) {
    return CartItem(
      id: map['id'] as String,
      title: map['title'] as String,
      quantity: map['quantity'] as int,
      price: map['price'] as int,
      weight: map['weight'] as double,
    );
  }
}

class Cart with ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser!.uid;

  Map<String, CartItem> _items = {};

  // void loadItems(){
  //  _items = FirebaseDatabase.instance.ref().child("USERS/${user}/cart/cart").get() as Map<String, CartItem>;
  // }

  void fetchCartItems() async {
    await FirebaseDatabase.instance
        .ref("USERS/${user}/cart")
        .get()
        .then((value) {
      Map data = value.value as Map;
      print(data);

      data.forEach((key, value) {
        _items.putIfAbsent(key, () => CartItem.fromMap(value));
      });

      print(_items);

      // for(var i =0; i< data.length;i++){
      //   _items.putIfAbsent(data., () => null)
      // }
    });
  }

  Map<String, CartItem> get items {
    return {..._items};
  }

  Map get itemsToMap {
    Map cartData = {};
    _items.forEach((key, value) {
      cartData[key] = value.toMap();
    });

    return cartData;
  }

  int get itemCount {
    return _items == null ? 0 : _items.length;
  }

  void addItem(String productId, int price, String title, int quantity, double weight) {
    if (_items.containsKey(productId)) {
      // Chhange the quantity
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: quantity,
                weight: existingCartItem.weight,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: quantity,
                weight: weight,
              ));
    }
    updateCart();
    notifyListeners();
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  double get totalWeight {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.weight * value.quantity;
    });
    return total;
  }

  void remove(String productId) {
    _items.remove(productId);
    updateCart();
    notifyListeners();
  }

  void updateCart() async {
    print(_items);

    // _items.forEach((key, item) {
    //   if (item != null) {
    //     FirebaseDatabase.instance.ref("USERS/${user}/cart").set({
    //       item.toMap(),
    //     });
    //   }
    // });

    Map cartData = {};

    _items.forEach((key, value) {
      cartData[key] = value.toMap();
    });

    print(cartData);

    await FirebaseDatabase.instance.ref("USERS/${user}/cart").set(cartData);
  }
}
