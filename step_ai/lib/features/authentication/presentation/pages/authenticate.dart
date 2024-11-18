import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/authentication/api/login_api.dart';
import 'package:step_ai/features/authentication/api/sign_up_api.dart';
import 'package:step_ai/features/authentication/notifier/error_notifier.dart';
import 'package:step_ai/features/authentication/notifier/login_notifier.dart';
import 'package:step_ai/features/authentication/notifier/register_notifier.dart';
import 'package:step_ai/features/authentication/notifier/ui_notifier.dart';

import '../../../../core/di/service_locator.dart';

class AuthenticateScreen extends StatefulWidget {
  AuthenticateScreen({super.key});

  @override
  State<AuthenticateScreen> createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  late AuthenticateUINotifier _authUINotifier;
  late AuthenticateErrorNotifier _errorNotifier;
  late LoginNotifier _loginNotifier;
  late RegisterNotifier _registerNotifier;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    _authUINotifier = Provider.of<AuthenticateUINotifier>(context);
    _errorNotifier = Provider.of<AuthenticateErrorNotifier>(context);
    _loginNotifier = Provider.of<LoginNotifier>(context);
    _registerNotifier = Provider.of<RegisterNotifier>(context);

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  //Build components:-----------------------------------------------------------
  AppBar _buildAppBar(){
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Center(
        child: Text(
          'STEP AI',
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 70),

              _buildToggleButton(),

              const SizedBox(height: 20),

              _authUINotifier.isLogin
                  ? _buildLoginView()
                  : _buildRegisterView(),
            ],
          ),
        ),

        if (_loginNotifier.isLoading || _registerNotifier.isLoading)
          Positioned.fill(child: _buildProgressIndicator()),
      ],
    );
  }


  //Build items:----------------------------------------------------------------

  Widget _buildProgressIndicator(){
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildToggleButton() {
    return LayoutBuilder(builder: (context, constraints) =>
        ToggleButtons(
          constraints: BoxConstraints.expand(
              width: (constraints.maxWidth-16)/2, height: 40),
          fillColor: Colors.blueAccent,
          color: Colors.black,
          selectedColor: Colors.white,

          borderRadius: BorderRadius.circular(8.0),
          isSelected: [_authUINotifier.isLogin, !_authUINotifier.isLogin],
          onPressed: (index) {
            setState(() {
              _authUINotifier.setToSpecific((index == 0));
              resetTextFieldValue();
            });
          },
          children: <Widget>[
            _buildToggleText('Login'),
            _buildToggleText('Register'),
          ],
        )
    );
  }

  Widget _buildToggleText(String text) {
    return Text(text);
  }

  Widget _buildLoginView() {
    return Column(
        children: [
          _buildTextFieldView(
              'Email', 'Enter your email address',
              _loginNotifier.emailError, _emailController, false),

          SizedBox(height: 15),
          _buildPasswordTypeField(
            'Password',
            'Enter your password',
            _loginNotifier.passwordError,
            _passwordController,
            _authUINotifier.isPasswordShowing,
            setStatePassword,
          ),

          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: forgotPasswordPress,
              child: const Text('Forgot password'),
            ),
          ),

          ElevatedButton(
              onPressed: loginValidateSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child: Container(
                height: 50,
                child: Center(
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Do not have account?'),
              TextButton(onPressed: () {
                setState(() {
                  _authUINotifier.setToRegister();
                  resetTextFieldValue();
                });
              }, child: Text('Register')),
            ],
          )
        ]
    );
  }

  Widget _buildRegisterView(){
    return Column(
      children: <Widget>[
        _buildTextFieldView(
            'Email', 'Enter your email address',
            _registerNotifier.emailError,
            _emailController, false),
        const SizedBox(height: 15),

        _buildTextFieldView(
            'Username', 'Enter your username',
            _registerNotifier.usernameError,
            _usernameController, false),
        const SizedBox(height: 15),

        _buildPasswordTypeField(
          'Password',
          'Enter your password',
          _registerNotifier.passwordError,
          _passwordController,
          _authUINotifier.isPasswordShowing,
          setStatePassword,
        ),
        const SizedBox(height: 15),

        _buildPasswordTypeField(
          'Confirm password',
          'Re-enter your password',
          _registerNotifier.confirmError,
          _confirmPwController,
          _authUINotifier.isConfirmPwShowing,
          setStateConfirmPw,
        ),
        const SizedBox(height: 15),

        ElevatedButton(
            onPressed: registerValidateSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
            ),
            child: Container(
              height: 50,
              child: Center(
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Already have account?'),
            TextButton(onPressed: () {
              setState(() {
                _authUINotifier.setToLogin();
                resetTextFieldValue();
              });
            }, child: Text('Login')),
          ],
        )
      ],
    );
  }

  Widget _buildTextFieldView(
      String label,
      String hint,
      String? error,
      TextEditingController controller,
      bool isPasswordType){
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        errorText: error,
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
  
  Widget _buildPasswordTypeField(
      String label,
      String hint,
      String? error,
      TextEditingController controller,
      bool isShowing,
      VoidCallback callback){

    return TextField(
      controller: controller,
      obscureText: !isShowing,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: error,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isShowing? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: callback,
        ),
      ),
    );
  }


  //Other methods:--------------------------------------------------------------
  void forgotPasswordPress(){

  }

  void setStatePassword(){
    _authUINotifier.toggleShowPassword();
  }

  void setStateConfirmPw(){
    _authUINotifier.toggleShowConfirmPassword();
  }

  void loginValidateSubmit() async{
    _loginNotifier.setEmailError(_emailController.text);
    _loginNotifier.setPasswordError(_passwordController.text);

    if (_loginNotifier.isInputValid()) {
      print('OK');
      //Call login API
      bool isLogged = await _loginNotifier.login(
          _emailController.text, _passwordController.text);
      if (isLogged) {

      }
      else {
      }
    }
    else {
      print('Failed');
    }
  }

  void registerValidateSubmit() async{

    _registerNotifier.setEmailError(_emailController.text);
    _registerNotifier.setPasswordError(_passwordController.text);
    _registerNotifier.setConfirmError(
        _confirmPwController.text,
        _passwordController.text
    );
    _registerNotifier.setUsernameError(_usernameController.text);


    if (_registerNotifier.isInputValid()){
      //call API register
      bool isRegistered = await _registerNotifier.register(
          _emailController.text,
          _passwordController.text,
          _usernameController.text
      );
      if (isRegistered){
        print('Logging in');
        //Switch screen
      }
    }
    else {
      print('Failed register');
    }
  }

  String? validateEmail(String email){
    if (email.isEmpty) {
      return "Email can not be empty";
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(email)) {
      return "Email invalid";
    }
    return null;
  }

  String? validatePassword(String password){
    if (password.isEmpty) {
      return "Password can not be empty";
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must include at least one uppercase letter.';
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Password must include at least one lowercase letter.';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must include at least one number.';
    }
    return null;
  }

  String? validateConfirmPw(String confirmPassword, String password){
    if (confirmPassword.isEmpty) {
      return "Confirm password can not be empty";
    }
    if (confirmPassword != password) {
      return "Confirm password mismatch ";
    }
    return null;
  }

  String? validateUsername(String username){
    if (username.isEmpty) {
      return "Username can not be empty";
    }
    return null;
  }

  void resetTextFieldValue(){
    _errorNotifier.reset();

    _emailController.text = '';
    _passwordController.text = '';
    _confirmPwController.text = '';
    _usernameController.text = '';
  }
}

