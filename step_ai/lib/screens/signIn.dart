import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Screen import
import 'signUp.dart';

// void main() {
//   runApp(const SignInApp());
// }

class SignInApp extends StatelessWidget {
  const SignInApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: LoginForm(),
        )
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();

}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _uname = '';
  String _pword = '';



  void submit() {
    if (_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      //API request
      print('Username: $_uname, Password: $_pword');
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Step AI',
                style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF172B4D),
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if  (value  == null || value.isEmpty) {
                    return 'You have to enter your username.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _uname = value!;
                },
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding:  const EdgeInsets.only(right: 10.0),
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.indigo,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 11),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if  (value  == null || value.isEmpty) {
                    return 'You have to enter your password.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _pword = value!;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(onPressed: submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF373FA9),
                    overlayColor: Colors.white.withOpacity(0.8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Sign in', style: TextStyle(color: Colors.white))),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New to Step AI? ',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                      onTap: signUpOnTap,
                      child: Text(
                        'Create an account',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.indigo
                        ),
                      )
                  )

                ],
              )
            ],
          )
      ),
    );
    throw UnimplementedError();
  }
  void signUpOnTap() {
    print('Switch to Sign Up screen!');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUpApp()),
    );
  }

  void forgotPasswordOnTap(){
    print('Switch to Forgot Password screen!');
  }
}

