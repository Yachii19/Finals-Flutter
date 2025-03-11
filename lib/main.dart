import 'package:flutter/material.dart';
import 'homepage_JRBV.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Color(0xFF121212),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white, 
        elevation: 0,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white70, fontSize: 18),
        titleLarge: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey[300],
        ),
      ),
    ),
      home: Scaffold (
        appBar: AppBar(title: Text('Flutter Demo'),
        ),
        body: Center(

          child: LoginForm(),
        )
      )  
    )
  );
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty){
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Login Successful'))
      // );
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => HomePage_JRBV())
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both username and password'),
        )
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return Column(
     
      children: [

        SizedBox(height: 20),
        
        Image.asset('../assets/axe.png', 
          width: 500,
          height: 400,
         
        ),

        SizedBox(height: 20),

        Text('Sign In', style:TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text('Please enter your details'),

        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: 'UserName',
            hintText: 'Enter your username'
          ),
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
          ),
          obscureText: true,
        ),

        SizedBox(height: 20),

        ElevatedButton(
          onPressed:  _handleLogin,
          child: Text('Login'),
        ),

        SizedBox(height: 20)
      ]
    );
  }
}