import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:easy_localization/easy_localization.dart' as e;

import '../../constant/app_color.dart';

class SelectAddressFromMapPage extends StatefulWidget {
  const SelectAddressFromMapPage({super.key,});

  @override
  State<SelectAddressFromMapPage> createState() =>
      _SelectAddressFromMapPageState();

}

class _SelectAddressFromMapPageState extends State<SelectAddressFromMapPage> {
  LatLng? _selectedLocation;
  LatLng? _initialLocation;
  bool _loading = true;

  final ValueNotifier<bool> loadingAddAddress = ValueNotifier(false);

  final Location _locationService = Location();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  String address = '';

  void getUserAddress(LatLng position) async {
    loadingAddAddress.value = true;
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyA2Ve0OWPzPbVuRKCK6UdR7Rrg1ho9bdPw',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      print(responseBody);
      final address = responseBody['results'][0]['formatted_address'];
      this.address = address;
      Navigator.pop(context , this.address);
      loadingAddAddress.value = false;
    }
  }

  Future<void> _getUserLocation() async {
    final permissionGranted = await _locationService.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      // Permission denied, fallback to a default location (e.g., New York)
      setState(() {
        _initialLocation = LatLng(37.785834, -122.406417);
        _selectedLocation = _initialLocation;
        _loading = false;
      });
      return;
    }

    final locationData = await _locationService.getLocation();
    setState(() {
      _initialLocation = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );
      _selectedLocation = _initialLocation;
      _loading = false;
    });
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }

  void _onSave() async {
    if (_selectedLocation != null) {
      getUserAddress(_selectedLocation!);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("رجاء قم باختيار موقع")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColor.primary)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("اختيار موقع"), centerTitle: true),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialLocation!,
          zoom: 15,
        ),
        onTap: _onMapTap,
        markers:
            _selectedLocation == null
                ? {}
                : {
                  Marker(
                    markerId: const MarkerId('selected-location'),
                    position: _selectedLocation!,
                  ),
                },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: loadingAddAddress,
        builder: (context, loading, _) {
          return loading
              ? Center(
                child: CircularProgressIndicator(color: AppColor.primary),
              )
              : FloatingActionButton.extended(
                onPressed: _onSave,
                label: Text("حفظ الموقع"),
                icon: const Icon(Icons.save),
              );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
