import 'package:flutter/material.dart';
import 'package:step_ai/features/authentication/api/sign_up_api.dart';
import 'package:step_ai/main.dart';
import 'package:step_ai/features/authentication/presentation/pages/sign_in_page.dart';

import '../../../chat/presentation/pages/chat_page.dart';

//Note: uname as email

class SignUpPage extends StatelessWidget{
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: SignUpForm(),
      ),
    );
    throw UnimplementedError();
  }
}

class SignUpForm extends StatefulWidget{
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm>{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pwordController = TextEditingController();
  final TextEditingController _cpwordController = TextEditingController();


  String _uname = '';
  String _pword = '';
  String _cpword = '';
  String _email = '';

  //Singleton API
  final signUpApi = SignUpAPI();


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Step AI',
                      style: TextStyle(
                        color: Color(0xFF172B4D),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    //Username field
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Username'),
                      keyboardType: TextInputType.text,
                      validator: (value){
                        if  (value == null || value.isEmpty) {
                          return 'You have to enter your username';
                        }
                        return null;
                      },
                      onSaved: (value){
                        _uname = value!;
                      },

                    ),
                    const SizedBox(height: 16),
                    //Password field
                    TextFormField(
                      controller: _pwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value){
                        if  (value == null || value.isEmpty) {
                          return 'You have to enter your password';
                        }
                        else if (value.length < 6){
                          return 'Password must be at least 6 characters';
                        }

                        return null;
                      },
                      onSaved: (value){
                        _pword = value!;
                      },

                    ),
                    const SizedBox(height: 16),
                    //Confirm password field
                    TextFormField(
                      controller: _cpwordController,
                      decoration: const InputDecoration(labelText: 'Confirm password'),
                      obscureText: true,
                      validator: (value){
                        if  (value == null || value.isEmpty) {
                          return 'You have to confirm your password';
                        }
                        else if (value != _pwordController.text){
                          print('$value, password: ' + _pwordController.text);
                          return 'Password do not match';
                        }
                        return null;
                      },
                      onSaved: (value){
                        _cpword = value!;
                      },
                    ),
                    SizedBox(height: 16),
                    //Email field
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value){
                        if  (value == null || value.isEmpty) {
                          return 'You have to enter your email';
                        }
                        return null;
                      },
                      onSaved: (value){
                        _email = value!;
                      },
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(onPressed: submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF373FA9),
                          foregroundColor: Colors.white,
                          overlayColor: Colors.white.withOpacity(0.8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text('Sign up')),
                    SizedBox(height: 16),
                    //Switch to login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account? ',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => ToLogin(context),
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.indigo,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
    // TODO: implement build
    throw UnimplementedError();
  }

  void submit() async{
    if (_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      //Handle api call for register:
      print('Uname:  $_uname, Password: $_pword, '
          'Confirm Password: $_cpword, Email: $_email');

      signUpApi.call(_email, _pword, _uname).then((message){
        print('Sign up message: $message');
      });

      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatPage())
      );


    }
  }


}



void ToLogin(BuildContext context) {
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (content)=> SignInPage()));
  print("Switch to login page.");
}

