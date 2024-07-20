import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';
import 'signin_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryCodeController = TextEditingController(text: '+91');
  final _busnumberController = TextEditingController();
  var _loading = true;

  final _passwordFocusNode = FocusNode();

  Future<void> _getProfile() async {
    setState(() {
      _loading = true;
    });

    try {
      print('Before Supabase query');
      final userId = supabase.auth.currentUser!.id;
      final response = await supabase
          .from('clients')
          .select()
          .eq('user_id', userId)
          .single();
      print('After Supabase query');

      if (response != null) {
        // Handle the response
        _nameController.text = (response['name'] ?? '') as String;
        _emailController.text = (response['email'] ?? '') as String;
        _passwordController.text = (response['password'] ?? '') as String;
        _phoneController.text = (response['phone'] ?? '') as String;
        _countryCodeController.text = (response['country_code'] ?? '+91') as String;
        _busnumberController.text = (response['busnumber'] ?? '') as String;
      } else {
        // Handle the case where no data is returned
        // You might want to set default values or show an error message
        print('No data returned from Supabase query');
      }
    } catch (error) {
      print('Unexpected error: $error');
      // _showErrorSnackbar('Unexpected error occurred');
    } finally {
      print('Finally block');
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _showErrorSnackbar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.black,
      ),
    );

    // Move focus to password field
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });
    final userName = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final user = supabase.auth.currentUser;
    final phone = _phoneController.text.trim();
    final countryCode = _countryCodeController.text.trim();
    final busnumber = _busnumberController.text.trim();
    final updates = {
      'user_id': user!.id,
      'name': userName,
      'email': email,
      'password': password,
      'phone': phone,
      'country_code': countryCode,
      'busnumber': busnumber,
      'created_at': DateTime.now().toIso8601String(),
    };

    if (password.length < 8 ||
        !password.contains(RegExp(r'[A-Z]')) ||
        !password.contains(RegExp(r'[a-z]')) ||
        !password.contains(RegExp(r'[0-9]'))) {
      _showErrorSnackbar('Password must be at least 8 characters long and include an uppercase letter, a lowercase letter, and numbers.');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const RegistrationScreen(),
        ),
      );
      return;
    }

    try {
      await supabase.from('clients').upsert(updates);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully updated profile!'),
          ),
        );

        // After updating, navigate to 'home_screen'
        Navigator.of(context).pushReplacementNamed('/home_screen');
      }
    } on PostgrestException catch (error) {
      _showErrorSnackbar(error.message);
    } catch (error) {
      _showErrorSnackbar('Unexpected error occurred');
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _phoneController.dispose();
    _countryCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 400,
                  width: double.infinity,
                  child: Lottie.asset(
                    'assets/welcom1.json',
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  focusNode: _passwordFocusNode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    } else if (value.length < 8 ||
                        !value.contains(RegExp(r'[A-Z]')) ||
                        !value.contains(RegExp(r'[a-z]')) ||
                        !value.contains(RegExp(r'[0-9]'))) {
                      return 'Password must be at least 8 characters long and include an uppercase letter, a lowercase letter, and numbers.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _countryCodeController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Country Code',
                          hintText: '+91',
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          hintText: 'Enter your phone number',
                          prefixIcon: Icon(Icons.phone_android),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _busnumberController,
                  decoration: InputDecoration(
                    labelText: 'Bus Number',
                    hintText: 'Enter your Bus Number',
                    prefixIcon: Icon(Icons.directions_bus_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bus number is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: _loading ? null : _updateProfile,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigoAccent,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    _loading ? 'Saving...' : 'Update',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
