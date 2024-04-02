import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Order with ChangeNotifier {
  final String id;
  final String status;
  final String statusId;
  final Map cart;
  final String address;
  final String location;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Order({required this.address, required this.location, required this.id, this.status = "active", this.statusId = "-1", required this.cart});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'status': this.status,
      'statusId': this.statusId,
      'Cart': this.cart,
      'address': this.address,
      'location': this.location,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      status: map['status'] as String,
      statusId: map['statusId'] as String,
      cart: map['cart'] as Map,
      address: map['address'] as String,
      location: map['location'] as String,
    );
  }
}