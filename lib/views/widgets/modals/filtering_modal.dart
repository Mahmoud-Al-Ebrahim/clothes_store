import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(
      double minPrice,
      double maxPrice,
      String? style,
      String? color,
      String? size,
      ) onApply;

  const FilterBottomSheet({super.key, required this.onApply});

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // Slider range constants
  static const double minPriceLimit = 50000;
  static const double maxPriceLimit = 1000000;

  RangeValues _currentRangeValues = const RangeValues(minPriceLimit, maxPriceLimit);
  final TextEditingController _styleController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();


  @override
  void dispose() {
    _styleController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // To avoid keyboard overlap and bottom safe area
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "فلترة المنتجات",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Price Range Slider
            Text("مجال السعر:  ${_currentRangeValues.start.toInt()} -${_currentRangeValues.end.toInt()}  ل.س "),
            RangeSlider(
              min: minPriceLimit,
              max: maxPriceLimit,
              divisions: 100,
              labels: RangeLabels(
                "${_currentRangeValues.start.toInt()} ل.س ",
                "${_currentRangeValues.end.toInt()} ل.س ",
              ),
              values: _currentRangeValues,
              onChanged: (RangeValues values) {
                setState(() {
                  _currentRangeValues = values;
                });
              },
            ),
            const SizedBox(height: 16),

            // Style TextField
            TextField(
              controller: _styleController,
              decoration: const InputDecoration(
                labelText: "ستايل",
                border: OutlineInputBorder(),
                hintText: "أدخل ستايل اللباس",
              ),
            ),
            const SizedBox(height: 16),

            // Size TextField
            TextField(
              controller: _sizeController,
              decoration: const InputDecoration(
                labelText: "قياس",
                border: OutlineInputBorder(),
                hintText: "أدخل قياس",
              ),
            ),
            const SizedBox(height: 16),

            // Size TextField
            TextField(
              controller: _colorController,
              decoration: const InputDecoration(
                labelText: "لون",
                border: OutlineInputBorder(),
                hintText: "أدخل لون",
              ),
            ),

            const SizedBox(height: 24),

            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onApply(
                    _currentRangeValues.start,
                    _currentRangeValues.end,
                    _styleController.text.isEmpty ? null : _styleController.text,
                    _colorController.text.isEmpty ? null : _colorController.text,
                    _sizeController.text.isEmpty ? null : _sizeController.text,
                  );
                },
                child: const Text("تطبيق الفلترة"),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
