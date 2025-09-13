import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clothes_store/models/products_response_model.dart';
import 'package:flutter/material.dart';

import '../../../blocs/products_bloc/products_bloc.dart';
import '../../../constant/app_color.dart';
import '../../widgets/category_card.dart';
import '../../widgets/loading_indicator/fashion_loader.dart';

class AddEditProductPage extends StatefulWidget {
  final ProductsResponseModel? product;

  const AddEditProductPage({super.key, this.product});

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late TextEditingController _discountController;
  late TextEditingController _sizeController;
  late final ValueNotifier<int> currentSelected;


  Color selectedColor = Colors.blue;
  String rgbHex = '#000000'; // Default


  String colorToHex(Color color) {
    return '#${color.red.toRadixString(16).padLeft(2, '0')}'
        '${color.green.toRadixString(16).padLeft(2, '0')}'
        '${color.blue.toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }

  void pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('اختر لون'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: selectedColor,
            onColorChanged: (Color color) {
              setState(() {
                selectedColor = color;
                rgbHex = colorToHex(color); // Save as #RRGGBB
                print('hhhh $rgbHex');
              });
            },
            enableAlpha: false, // No transparency
            displayThumbColor: true,
          ),
        ),
        actions: [
          TextButton(
            child: Text('تم'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  File? _imageFile;
  String? _gender;
  String? _season;
  String? _styleCloth;
  String? _type;

  final types = ["Sport", "Formal"];
  final genders = ["Male", "Female"];
  final seasons = ["Winter", "Summer", "Spring", "Autumn"];
  final styles = ["Casual", "Evening Wear", "Sport", "Formal"];

  @override
  void initState() {
    super.initState();
    currentSelected = ValueNotifier(1);
    _nameController = TextEditingController(text: widget.product?.name ?? "");

    _quantityController =
        TextEditingController(text: widget.product?.name ?? "");
    _discountController =  TextEditingController();
    _sizeController =  TextEditingController();
    _descriptionController =
        TextEditingController(text: widget.product?.description ?? "");
    _priceController =
        TextEditingController(text: (widget.product?.price ?? "").toString());
  }

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  void _saveProduct() {
    if (_imageFile == null && widget.product == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("رجاء قم بإرفاق صورة!")),
      );
      return;
    }
    if (_formKey.currentState!.validate() && widget.product == null) {
      BlocProvider.of<ProductsBloc>(context).add(AddProductEvent(
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0,
        categoryId: currentSelected.value,
        quantity: int.tryParse(_quantityController.text) ?? 0,
        image: _imageFile!,
        gender: _gender ?? "",
        season: _season ?? "",
        type: _type ?? "",
        color: rgbHex,
        size: _sizeController.text,
        styleCloth: _styleCloth ?? "",
      ));
    }else{
      BlocProvider.of<ProductsBloc>(context).add(EditProductEvent(
        imageUrl: widget.product!.imageUrl!,
        id: widget.product!.id!,
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0,
        categoryId: currentSelected.value,
        quantity: int.tryParse(_quantityController.text) ?? 0,
        image: _imageFile,
        gender: _gender ?? "",
        season: _season ?? "",
        type: _type ?? "",
        styleCloth: _styleCloth ?? "",
      ));


    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: Text(widget.product == null ? "إضافة منتج" : "تعديل منتج",
            style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _imageFile == null
                    ? Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                            color: AppColor.primary.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Icon(
                          Icons.add_a_photo,
                          size: 40,
                          color: Colors.white,
                        ),
                      )
                    : Image.file(_imageFile!,
                        width: 120, height: 120, fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),
              if (widget.product == null) ...{
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: AppColor.primary,
                  padding: EdgeInsets.only(top: 12, bottom: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'اختر فئة المنتج',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Category list
                      ValueListenableBuilder(
                        valueListenable: currentSelected,
                        builder: (context, value, child) {
                          return BlocBuilder<ProductsBloc, ProductsState>(
                            builder: (context, state) {
                              return state.getProductCategoriesStatus ==
                                      GetProductCategoriesStatus.loading
                                  ? FashionLoader(
                                      color: Colors.white,
                                    )
                                  : Container(
                                      margin: EdgeInsets.only(top: 12),
                                      height: 96,
                                      child: ListView.separated(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        itemCount: state
                                                .productCategoriesResponseModel
                                                ?.length ??
                                            0,
                                        physics: BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(width: 16);
                                        },
                                        itemBuilder: (context, index) {
                                          return CategoryCard(
                                            selected: value ==
                                                state
                                                    .productCategoriesResponseModel![
                                                        index]
                                                    .id,
                                            data: state
                                                    .productCategoriesResponseModel![
                                                index],
                                            onTap: () {
                                              currentSelected.value = state
                                                  .productCategoriesResponseModel![
                                                      index]
                                                  .id!;
                                              BlocProvider.of<ProductsBloc>(
                                                context,
                                              ).add(
                                                GetProductsByCategoryEvent(
                                                  categoryId: state
                                                      .productCategoriesResponseModel![
                                                          index]
                                                      .id!,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "اسم المنتج"),
                  validator: (val) => val!.isEmpty ? "Required" : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "وصف المنتج"),
                  maxLines: 2,
                ),
              },
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "السعر"),
                keyboardType: TextInputType.number,
              ),

              TextFormField(
                controller: _discountController,
                decoration: const InputDecoration(labelText: "الخصم"),
                keyboardType: TextInputType.number,
              ),

              if (widget.product == null) ...{
                ElevatedButton(
                  onPressed: pickColor,
                  child: Text('اختر لون'),
                ),
                TextFormField(
                  controller: _sizeController,
                  decoration: const InputDecoration(labelText: "القياس"),
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(labelText: "الكمية"),
                  keyboardType: TextInputType.number,
                ),
                // TextFormField(
                //   controller: _discountController,
                //   decoration: const InputDecoration(labelText: "Discount Setting ID"),
                //   keyboardType: TextInputType.number,
                // ),
                // TextFormField(
                //   controller: _ratingController,
                //   decoration: const InputDecoration(labelText: "Rating"),
                //   keyboardType: TextInputType.number,
                // ),

                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: const InputDecoration(labelText: "النوع"),
                  items: genders
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (val) => setState(() => _gender = val),
                ),

                DropdownButtonFormField<String>(
                  value: _season,
                  decoration: const InputDecoration(labelText: "الفصل"),
                  items: seasons
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) => setState(() => _season = val),
                ),
                DropdownButtonFormField<String>(
                  value: _type,
                  decoration: const InputDecoration(labelText: "النوع"),
                  items: types
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) => setState(() => _type = val),
                ),

                DropdownButtonFormField<String>(
                  value: _styleCloth,
                  decoration: const InputDecoration(labelText: "الستايل"),
                  items: styles
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) => setState(() => _styleCloth = val),
                ),
              },
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text(widget.product == null ? "إضافة" : "تعديل"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
