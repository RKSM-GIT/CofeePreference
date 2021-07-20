import 'package:coffee_preference/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:coffee_preference/shared/loading.dart';
import "package:coffee_preference/shared/constants.dart";

class Register extends StatefulWidget {
  
  final Function? toggleView;
  Register({this.toggleView});


  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //loading
  bool loading = false;

  //Form States
  String email = "", password = "", error = "";

  @override
  Widget build(BuildContext context) {
    return loading==true? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: const Text("Register"),
        actions: [
          TextButton.icon(
            onPressed: () {
              widget.toggleView!();
            }, 
            icon: Icon(Icons.apps_rounded),
            label: Text("Log in"),
            style: TextButton.styleFrom(
              primary: Colors.black
            ),
          ),
        ],
      ),


      body: Container(
        padding: const EdgeInsets.symmetric(horizontal:50,vertical:20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              //EMAIL
              SizedBox(height:20,),
              TextFormField(
                validator: (val) {
                  if(val == null || val.isEmpty){
                    return "Enter an Email";
                  }
                  else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)){
                    return "Not a valid email";
                  }
                  else{
                    return null;
                  }
                },
                onChanged: (val) {
                  setState(() => {email = val});
                },
                decoration: formDecoration.copyWith(labelText: "Email",prefixIcon: Icon(Icons.person)),
              ),

              //Password
              SizedBox(height:20,),
              TextFormField(
                validator: (val) {
                  if(val == null || val.isEmpty){
                    return "Enter a password";
                  }
                  else if(val.length < 6){
                    return "Password must be atleast 6 characters long";
                  }
                  else
                    return null;
                },
                obscureText: true,
                onChanged: (val) {
                  setState(() => {password = val});
                },
                decoration: formDecoration.copyWith(labelText: "Password",prefixIcon: Icon(Icons.lock)),
              ),

              //Submit
              SizedBox(height:20,),
              ElevatedButton(
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    setState(() => loading = true);
                    dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                    if(result == null){
                      setState(() {
                        error = "Email is invalid or already taken";
                        loading = false;
                      });
                    }
                  }
                },
                child: Text("Register"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.pink,
                  onPrimary: Colors.white,
                ),
              ),


              //Error
              SizedBox(height: 14),
              Text(error,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
            ],
          )
        )
      ),
    );
  }
}