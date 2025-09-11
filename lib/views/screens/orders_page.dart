import 'package:clothes_store/blocs/orders_bloc/orders_bloc.dart';
import 'package:clothes_store/views/widgets/loading_indicator/fashion_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constant/app_color.dart';
import 'package:flutter_svg/flutter_svg.dart';


class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {

  @override
  void initState() {
    BlocProvider.of<OrdersBloc>(context).add(GetMyOrdersEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          children: [
            Text(
              'سجل الطلبات',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: AppColor.primarySoft,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: BlocBuilder<OrdersBloc , OrdersState>(builder: (context , state){

        return state.getOrdersStatus == GetOrdersStatus.loading ? Center(child: FashionLoader(),) : ListView.builder(
          itemCount: state.orders.length,
          itemBuilder: (context, index) {
            final order = state.orders[index];
            return Card(
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (order.id != null) Text("رقم الطلب : ${order.id}"),
                    if (order.totalPrice != null) Text("الإجمالي: \$${order.totalPrice}"),
                    if (order.createAt != null)
                      Text("تاريخ الطلب: ${order.createAt!.toLocal().toString().split('.')[0]}"),
                    if (order.shippingAddress != null)
                      Text("عنوان الشحن: ${order.shippingAddress}"),
                    const SizedBox(height: 10),
                    if (order.items != null && order.items!.isNotEmpty)
                      const Text("محتوى الطلب:", style: TextStyle(fontWeight: FontWeight.bold)),
                    ...?order.items?.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (item.productName != null)
                              Text("المنتج: ${item.productName}",
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                            if (item.quantity != null) Text("الكمية: ${item.quantity}"),
                            if (item.price != null) Text("السعر: \$${item.price}"),
                            if (item.discountedPrice != null)
                              Text("السعر المخفض: \$${item.discountedPrice}"),
                            if (item.size != null) Text("القياس: ${item.size}"),
                            if (item.color != null) Text("اللون: ${item.color}"),
                            if (item.imageUrl != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Image.network(
                                  item.imageUrl!,
                                  height: 80,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image),
                                ),
                              ),
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            );
          },
        );
      })
    );
  }
}
