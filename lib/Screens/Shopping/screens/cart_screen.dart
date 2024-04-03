import 'package:dronaidapp/Screens/Shopping/provider/cart.dart';
import 'package:dronaidapp/Screens/Shopping/screens/confirmDetails.dart';
import 'package:dronaidapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';
import '../Razorpay/razor.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/Cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Text("${cart.totalWeight}Kg/1Kg"),
                  Spacer(),
                  Chip(
                    label: Text(
                      '₹${cart.totalAmount}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    onPressed: () {
                      (cart.totalWeight <= 1.0)
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ConfirmDetails(),
                              )
                              // RazorPayClass(
                              // Amount: (cart.totalAmount).round())),
                              )
                          : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Weight limit for order exceeded")));
                    },
                    child: const Text('ORDER NOW'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, id) => CartItems(
                id: cart.items.values.toList()[id].id,
                productId: cart.items.keys.toList()[id],
                title: cart.items.values.toList()[id].title,
                price: cart.items.values.toList()[id].price,
                quantity: cart.items.values.toList()[id].quantity,
                weight: cart.items.values.toList()[id].weight,
              ),
              itemCount: cart.itemCount,
            ),
          ),
        ],
      ),
    );
  }
}
