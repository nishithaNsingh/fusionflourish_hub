import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';
import 'reg_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40), // Adjust the horizontal padding as needed
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/loginpic.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),


                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: _signIn,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigoAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text('Sign In'),
                ),
                const SizedBox(height: 18),
                TextButton(
                  onPressed: () {
                    // Navigate to the sign-in screen when the button is pressed
                    Navigator.of(context)
                        .pushReplacementNamed('/login_screen');
                  },
                  child: const Text("Don't have an account? Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    setState(() {
      _loading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      // Fetch user data from Supabase based on entered email
      final response = await supabase
          .from('clients')
          .select()
          .eq('email', email)
          .single();

      // Check if the user exists and the password matches
      if (response.data != null && response.data!['password'] == password) {
        // Navigate to the HomeScreen if credentials are correct
        Navigator.of(context).pushReplacementNamed('/home_screen');
      } else {
        // Display an error if credentials are incorrect
        _showErrorSnackbar('Invalid email or password');
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

  void _showErrorSnackbar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
