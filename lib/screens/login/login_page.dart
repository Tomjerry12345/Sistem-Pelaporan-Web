import 'package:admin/values/screen_utils.dart';
import 'package:flutter/material.dart';

import 'logic.dart';

class LoginPage extends StatefulWidget {
  final void Function(dynamic isLogin)? onClickLogin;
  const LoginPage({Key? key, this.onClickLogin}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFf5f5f5),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 8,
            vertical: MediaQuery.of(context).size.height / 8),
        children: [Body(widget.onClickLogin)],
      ),
    );
  }
}

// ignore: must_be_immutable
class Body extends StatelessWidget {
  final l = Logic();
  void Function(dynamic isLogin)? onClickLogin;

  Body(void Function(dynamic isLogin)? onClickLogin) {
    this.onClickLogin = onClickLogin;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 0.3.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Login Admin Terlebih Dahulu',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Image.asset(
                'images/illustration-2.png',
                width: 300,
              ),
            ],
          ),
        ),

        Image.asset(
          'images/illustration-1.png',
          width: 0.2.w,
        ),
        // MediaQuery.of(context).size.width >= 1300 //Responsive
        //     ? Image.asset(
        //         'images/illustration-1.png',
        //         width: 300,
        //       )
        //     : SizedBox(),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 6),
          child: Container(
            width: 0.24.w,
            child: _formLogin(context, onClickLogin),
          ),
        )
      ],
    );
  }

  Widget _formLogin(
      BuildContext context, void Function(dynamic isLogin)? onClickLogin) {
    return Column(
      children: [
        TextField(
          controller: l.username,
          decoration: InputDecoration(
            hintText: 'Username',
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            // fillColor: Colors.blueGrey[50],
            labelStyle: TextStyle(fontSize: 12),
            contentPadding: EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(height: 30),
        TextField(
          controller: l.password,
          decoration: InputDecoration(
            hintText: 'Password',
            // counterText: 'Forgot password?',
            suffixIcon: Icon(
              Icons.visibility_off_outlined,
              color: Colors.grey,
            ),
            filled: true,
            // fillColor: Colors.blueGrey[50],
            labelStyle: TextStyle(fontSize: 12),
            contentPadding: EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple,
                spreadRadius: 10,
                blurRadius: 20,
              ),
            ],
          ),
          child: ElevatedButton(
            child: Container(
                width: double.infinity,
                height: 50,
                child: Center(child: Text("Login"))),
            onPressed: () {
              l.onLogin(context, onClickLogin);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        SizedBox(height: 40),
        Row(children: [
          Expanded(
            child: Divider(
              color: Colors.grey[300],
              height: 50,
            ),
          ),
        ]),
      ],
    );
  }
}
