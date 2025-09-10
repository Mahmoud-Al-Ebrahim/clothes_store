
import 'package:clothes_store/views/widgets/loading_indicator/fashion_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaypalPage extends StatefulWidget {
  const PaypalPage({super.key, required this.total, required this.items ,  this.placeOrder});

  final double total;
  final List<Map<String , dynamic>> items;
  final void Function()? placeOrder;

  @override
  State<PaypalPage> createState() => _PaypalPageState();
}

class _PaypalPageState extends State<PaypalPage> {


@override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 10) , () => show.value = true,);
  }

  final ValueNotifier<bool> show = ValueNotifier(false);

  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1.sw,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: PaypalCheckoutView(
            sandboxMode: true,
            loadingIndicator: FashionLoader(),
            clientId: "AYdS2SSBOhwSKspJsqXGhm9vL_azI8ZWLkalrik_5ZVhKZTedFNA_7NrwM6Pz28ful9bcQmQbGZ_TNMJ",
            secretKey: "EFu2u1VvriXJ7nGh6_BaUituWTAePqRZf9FU8cpkoXvu9AIjbgTJtU5dWypJ_6-xxhmS0gOO3sTEyH7M",
            transactions: [
              {
                "amount": {
                  "total": '${widget.total}',
                  "currency": "USD",
                  "details": {
                    "subtotal": '${widget.total}',
                    "shipping": '0',
                    "shipping_discount": 0
                  }
                },
                "description": "The payment transaction description.",
                // "payment_options": {
                //   "allowed_payment_method":
                //       "INSTANT_FUNDING_SOURCE"
                // },
                "item_list": {
                  "items": widget.items
          
                  // shipping address is not required though
                  //   "shipping_address": {
                  //     "recipient_name": "tharwat",
                  //     "line1": "Alexandria",
                  //     "line2": "",
                  //     "city": "Alexandria",
                  //     "country_code": "EG",
                  //     "postal_code": "21505",
                  //     "phone": "+00000000",
                  //     "state": "Alexandria"
                  //  },
                }
              }
            ],
            note: "Contact us for any questions on your order.",
          
            onSuccess: (Map params) {
          
              print("onSuccess: $params");
              
            },
            onError: (error) {
              print("onError: $error");
              Navigator.pop(context);
            },
            onCancel: () {
              print('cancelled:');
            },
          
          ),
      ),
    );
  }
}
