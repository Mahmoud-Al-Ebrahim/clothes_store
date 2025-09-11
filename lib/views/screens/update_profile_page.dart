import 'dart:io';

import 'package:clothes_store/blocs/auth_bloc/auth_bloc.dart';
import 'package:clothes_store/utils/my_shared_pref.dart';
import 'package:clothes_store/utils/show_message.dart';
import 'package:clothes_store/views/widgets/loading_indicator/fashion_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Perform update profile logic here
      // You can get all values:
      String fullName = _fullNameController.text;
      String username = _usernameController.text.trim();
      String phone = _phoneController.text.trim();
      String email = _emailController.text.trim();
      File? profileImage = _profileImage;

      // Example: print or send to API
      BlocProvider.of<AuthBloc>(context).add(UpdateProfileEvent(
          fullName: fullName,
          userName: username,
          email: email,
          phone: phone,
          image: profileImage));
      print('Full Name: $fullName');
      print('Username: $username');
      print('Phone: $phone');
      print('Email: $email');
      print('Profile image path: ${profileImage?.path}');
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // _fullNameController.text = MySharedPref.getFullName()!;
    // _emailController.text = MySharedPref.getEmail()!;
    // _phoneController.text = MySharedPref.getPhone()!;
    // _usernameController.text = MySharedPref.getUserName()!;

    return Scaffold(
      appBar: AppBar(title: const Text('تحديث الملف الشخصي')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile image with picker
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? const Icon(Icons.camera_alt,
                          size: 50, color: Colors.white70)
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              // Full name
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'الاسم الكامل',
                  border: OutlineInputBorder(),
                ),),
              const SizedBox(height: 16),

              // Username
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'اسم المستخدم',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Phone number
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                  if (value.trim().length != 12) {
                    return "رقم الهاتف مع رمز البلد يحب أن يكون 12 خانة";
                  }
                  if (value.trim().substring(0, 4) != '9639') {
                    return "رقم الهاتف يجب أن يبدأ ب 9639";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'البريد الالكتروني',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                  final emailRegExp = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                  if (!emailRegExp.hasMatch(value.trim())) {
                    return 'هذا البريد الالكتروني غير صالح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Submit button
              BlocConsumer<AuthBloc, AuthState>(
                  listenWhen: (p, c) =>
                      p.updateProfileStatus != c.updateProfileStatus,
                  listener: (context, state) {
                    if (state.updateProfileStatus ==
                        UpdateProfileStatus.success) {
                      showMessage("تم تحديث الملف الشخصي بنجاح");
                      WidgetsBinding.instance.addPostFrameCallback((_){
                        setState(() {

                        });
                      });
                    }
                    if (state.updateProfileStatus ==
                        UpdateProfileStatus.failure) {
                      showMessage(state.errorMessage ?? "حدث خطأ غير معروف");
                    }
                  },
                  builder: (context, state) {
                    return state.updateProfileStatus ==
                            UpdateProfileStatus.loading
                        ? FashionLoader()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submit,
                              child: const Text('تحديث البيانات'),
                            ),
                          );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
