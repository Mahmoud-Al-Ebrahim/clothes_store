import 'package:clothes_store/blocs/products_bloc/products_bloc.dart';
import 'package:clothes_store/views/widgets/loading_indicator/fashion_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // For formatting dates

class DiscountPage extends StatelessWidget {
  const DiscountPage();

  String formatDate(DateTime? date) {
    if (date == null) return 'غير محدد';
    return DateFormat.yMMMd().format(date);
  }

  Future<Map<String, dynamic>?> showAddDiscountDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final discountController = TextEditingController();
    DateTime? startDate;
    DateTime? endDate;

    return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "إضافة خصم",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: discountController,
                      decoration: const InputDecoration(
                        labelText: "نسبة الخصم (%)",
                        hintText: "مثال: 15.5",
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "يرجى إدخال نسبة الخصم";
                        }
                        final value = double.tryParse(val);
                        if (value == null || value <= 0) {
                          return "النسبة يجب أن تكون رقم موجب";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      title: Text(
                        startDate == null
                            ? "اختر تاريخ البداية"
                            : "تاريخ البداية: ${startDate!.toLocal()}"
                                .split(' ')[0],
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            startDate = picked;
                          });
                        }
                      },''
                    ),
                    ListTile(
                      title: Text(
                        endDate == null
                            ? "اختر تاريخ النهاية"
                            : "تاريخ النهاية: ${endDate!.toLocal()}"
                                .split(' ')[0],
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: startDate ?? DateTime.now(),
                          firstDate: startDate ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            endDate = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (startDate == null || endDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("يرجى اختيار تاريخ البداية والنهاية")),
                    );
                    return;
                  }
                  if (endDate!.isBefore(startDate!)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text("تاريخ النهاية يجب أن يكون بعد البداية")),
                    );
                    return;
                  }

                  Navigator.pop(context, {
                    "discountPercentage": double.parse(discountController.text),
                    "startDate": startDate,
                    "endDate": endDate,
                  });
                }
              },
              child: const Text("حفظ"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('التخفيضات')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Map<String, dynamic>? data = await showAddDiscountDialog(context);
          if (data != null) {
            BlocProvider.of<ProductsBloc>(context).add(AddDiscountEvent(
                discountPercentage: data['discountPercentage'],
                startDate: data['startDate'],
                endDate: data['endDate']));
          }
        },
        child: Icon(Icons.add),
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(builder: (context, state) {
        return state.adminTransactionStatus == AdminTransactionStatus.loading
            ? Center(
                child: FashionLoader(),
              )
            : state.discounts.isEmpty
                ? Center(child: Text('لايوجد تخفيضات حالياً'))
                : ListView.builder(
                    itemCount: state.discounts.length,
                    itemBuilder: (context, index) {
                      final discount = state.discounts[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Icon(Icons.local_offer, color: Colors.green),
                          trailing: InkWell(
                              onTap: () {
                                BlocProvider.of<ProductsBloc>(context)
                                    .add(DeleteDiscountEvent(discount.id!));
                              },
                              child: Icon(Icons.delete, color: Colors.red)),
                          title:
                              Row(
                                spacing: 15,
                                children: [
                                  Text('${discount.discountPercentage ?? 0}% خصم '),
                                  Text('${discount.id!}رقم الخصم '),
                                ],
                              ),
                          subtitle: Text(
                            'من  ${formatDate(discount.startDate)} إلى ${formatDate(discount.endDate)}',
                          ),
                        ),
                      );
                    },
                  );
      }),
    );
  }
}
