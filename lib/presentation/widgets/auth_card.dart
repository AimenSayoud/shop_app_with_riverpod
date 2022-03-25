import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_second/data/services/authantication.dart';
import 'package:shop_app_second/presentation/widgets/image_picker.dart';

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

enum AuthMode { Login, SignUp }

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  String? username;
  String? email;
  String? password;
  var isLoading = false;
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  File? _pickedImage;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.Login ? 260 : 500,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                //add an image
                if (_authMode == AuthMode.SignUp)
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserImagePicker()),
                    ).then(
                      (value) {
                        setState(() {
                          _pickedImage = value;
                        });
                      },
                    ),
                    child: _pickedImage != null
                        ? CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey,
                            backgroundImage: _pickedImage != null
                                ? FileImage(_pickedImage!)
                                : null,
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Add Profile picture'),
                              SizedBox(
                                height: 10,
                              ),
                              Icon(Icons.add),
                            ],
                          ),
                  ),
                if (_authMode == AuthMode.SignUp)
                  SizedBox(
                    height: 4,
                  ),
                if (_authMode == AuthMode.SignUp)
                  //username
                  TextFormField(
                    key: ValueKey('username'),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'User Name',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.deepOrangeAccent.shade400,
                            width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.deepOrangeAccent.shade700,
                            width: 2.0),
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.pink.shade500,
                      ),
                    ),
                    onSaved: (val) => username = val!,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please entre a valid username';
                      }
                      return null;
                    },
                  ),
                if (_authMode == AuthMode.SignUp)
                  SizedBox(
                    height: 4,
                  ),
                //email
                TextFormField(
                  key: ValueKey('email'),
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.deepOrangeAccent.shade400, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.deepOrangeAccent.shade700, width: 2.0),
                    ),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.pink.shade500,
                    ),
                  ),
                  onSaved: (val) => email = val!,
                  validator: (val) {
                    if (val!.isEmpty || !val.contains('@')) {
                      return 'Please entre a valid Email';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 6,
                ),
                //First PassWord
                TextFormField(
                  key: ValueKey('password'),
                  obscureText: true,
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.deepOrangeAccent.shade400, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.deepOrangeAccent.shade700, width: 2.0),
                    ),
                    labelText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.pink.shade500,
                    ),
                  ),
                  onSaved: (valChange) => password = valChange!,
                  validator: (val) {
                    if (val!.isEmpty || val.length < 6) {
                      return 'Please entre a valid password';
                    }
                    return null;
                  },
                ),
                if (_authMode == AuthMode.SignUp)
                  SizedBox(
                    height: 6,
                  ),
                if (_authMode == AuthMode.SignUp)
                  //confirm password
                  TextFormField(
                    key: ValueKey('confirm your password'),
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.deepOrangeAccent.shade400,
                            width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.deepOrangeAccent.shade700,
                            width: 2.0),
                      ),
                      labelText: 'confirm your password',
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.pink.shade500,
                      ),
                    ),
                    validator: (val) {
                      if (val != _passwordController.text) {
                        return 'it is not the same, try again';
                      }
                      return null;
                    },
                  ),
                SizedBox(
                  height: 8,
                ),
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        child: Text(_authMode == AuthMode.Login
                            ? 'sign in'
                            : 'sign up'),
                        onPressed: _submit,
                      ),
                TextButton(
                  onPressed: _switchAuthMod,
                  child: Text(
                    _authMode == AuthMode.Login
                        ? 'create an account '
                        : 'do you have an account ?',
                    style: TextStyle(color: Colors.pink),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _switchAuthMod() {
    if (_authMode == AuthMode.Login) {
      setState(() => _authMode = AuthMode.SignUp);
    } else {
      setState(() => _authMode = AuthMode.Login);
    }
  }

  Future<void> _showSneakBarMessage(String message) async {
    print('start showing the snackBar');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 5),
    ));
    print('end showing the snackBar');
  }

  Future<void> _submit() async {
    final auth = AuthenticationService();
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    if (_pickedImage == null && _authMode == AuthMode.SignUp) {
      await _showSneakBarMessage('you should add an image');
      return;
    }

    _formKey.currentState!.save();
    print(email);
    print(password);
    FocusScope.of(context).unfocus();

    setState(() => isLoading = true);
    try {
      if (_authMode == AuthMode.Login) {
        print('start sign in');
        await auth.signInWithEmailAndPassword(email!, password!);
        print('end sign in');
        //  setState(() => isLoading = false);
      } else {
        print('start sign up');
        await auth.registerWithEmailAndPassword(
            username!, email!, password!, _pickedImage!, Timestamp.now());
        print('end sign up');
        print('end save user information.');
        //  setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showSneakBarMessage(e.toString());
      print(e);
    }
  }
}
