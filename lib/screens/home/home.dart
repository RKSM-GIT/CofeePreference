import 'package:coffee_preference/models/coffee.dart';
import 'package:coffee_preference/screens/home/settings_form.dart';
import 'package:coffee_preference/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:coffee_preference/services/database.dart';
import 'package:provider/provider.dart';
import 'coffee_list.dart';

class Home extends StatelessWidget {
  Home({ Key? key }) : super(key: key);

  //Get the _auth
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel(){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
          child: SettingsForm(),
        );
      });
    }

    return StreamProvider<List<Coffee>?>.value(
      initialData: null,
      value : DatabaseService().coffees,
      child: Scaffold(
        
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          title: const Text("Home"),
          elevation: 0.0,
          actions: <Widget>[
            //Signout
            TextButton.icon(
              onPressed: () async {
                await _auth.signOut();
              }, 
              icon: Icon(Icons.person ), 
              label: Text("Sign Out"),
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
            ),

            //Settings
            TextButton.icon(
              icon: Icon(Icons.settings),
              label: Text('Settings'),
              onPressed: () => _showSettingsPanel(),
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
            )
          ],
        ),

        //Body
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/coffee_bg.png"),
              fit: BoxFit.cover,
            )
          ),
          child: CoffeeList()
        ),


      ),
    );
  }
}