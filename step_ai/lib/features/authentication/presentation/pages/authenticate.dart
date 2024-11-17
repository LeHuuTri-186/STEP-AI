import 'package:flutter/material.dart';

class AuthenticateScreen extends StatefulWidget {
  const AuthenticateScreen({super.key});

  @override
  State<AuthenticateScreen> createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  bool isLogin = true;
  bool isPasswordShowing = false;
  bool isConfirmPwShowing = false;
  
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

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

  Widget _buildBody(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 70),

          _buildToggleButton(),

          const SizedBox(height: 20),

          isLogin? _buildLoginView(): _buildRegisterView(),
        ],
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
          isSelected: [isLogin, !isLogin],
          onPressed: (index) {
            setState(() {
              isLogin = (index == 0);
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
              'Email', 'Enter your email address', _emailController, false),

          SizedBox(height: 15),
          _buildPasswordTypeField(
            'Password',
            'Enter your password',
            _passwordController,
            isPasswordShowing,
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
              onPressed: () {},
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
                  isLogin = false;
                });
              }, child: Text('Register')),
            ],
          )
        ]
    );
  }

  Widget _buildRegisterView(){
    return Container();
  }

  Widget _buildTextFieldView(
      String label,
      String hint,
      TextEditingController controller,
      bool isPasswordType){
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
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
      TextEditingController controller,
      bool isShowing,
      VoidCallback callback){

    return TextField(
      controller: controller,
      obscureText: !isShowing,
      decoration: InputDecoration(
        labelText: label,
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


  void forgotPasswordPress(){

  }

  void setStatePassword(){
    setState(() {
      isPasswordShowing = !isPasswordShowing;
    });
  }

  void setStateConfirmPw(){
    setState(() {
      isConfirmPwShowing = !isConfirmPwShowing;
    });
  }
}

