import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback onSingnIn;

  const AuthScreen({required this.onSingnIn});

  @override
  State<AuthScreen> createState() => _AuthscreenState();
}

class _AuthscreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _passwort = '';
  bool _isLogIn = true;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        if (_isLogIn) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email,
            password: _passwort,
          );
        } else {}
        widget.onSingnIn();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogIn ? 'Login' : 'Register'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) => value!.isEmpty ? 'Enter an email' : null,
                onSaved: (value) => _email = value!,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) =>
                    value!.length < 6 ? 'Enter a password 6+ chars long' : null,
                onSaved: (value) => _passwort = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: Text(_isLogIn ? 'Login' : 'Register'),
                onPressed: _submitForm,
              ),
              TextButton(
                child: Text(_isLogIn
                    ? 'Need an account? Register'
                    : 'Have an account? Login'),
                onPressed: () {
                  setState(() {
                    _isLogIn = !_isLogIn;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
