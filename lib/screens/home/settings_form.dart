import 'package:coffee_preference/services/database.dart';
import 'package:coffee_preference/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:coffee_preference/shared/constants.dart';
import 'package:provider/provider.dart';
import "package:coffee_preference/models/user.dart";

class SettingsForm extends StatefulWidget {
  const SettingsForm({ Key? key }) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0','1','2','3','4'];

  //form values
  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<MyUser?>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user!.uid).userData,
      builder: (context, snapshot) {
        
        if(snapshot.hasData){

          UserData? userdata = snapshot.data;

          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text("Change your Coffee Preferences",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),

                TextFormField(
                  decoration: textInputDecoration,
                  initialValue: userdata?.name,
                  validator: (val) {
                    if(val==null || val.isEmpty){
                      return "Please enter a name";
                    } else{
                      return null;
                    }
                  },
                  onChanged: (val) => setState(() => _currentName = val),
                ),

                //Dropdown
                SizedBox(height: 20),
                DropdownButtonFormField(
                  decoration: textInputDecoration,
                  value: _currentSugars ?? userdata!.sugars,
                  items: sugars.map((i){
                    return DropdownMenuItem(
                      value: i,
                      child: Text("${i} sugars"),
                    );
                  }).toList(),

                  onChanged: (val) => setState(() => _currentSugars = "$val"),
                ),

                //Slider
                SizedBox(height: 20),
                Slider(
                  value: (_currentStrength ?? userdata!.strength)!.toDouble(),
                  activeColor: Colors.brown[_currentStrength ?? userdata!.strength ?? 100],
                  inactiveColor: Colors.brown[_currentStrength ?? userdata!.strength ?? 100],
                  min: 100,
                  max: 900,
                  divisions: 8,
                  onChanged: (val) => setState(() => _currentStrength = val.round()),
                ),

                //Submit
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await DatabaseService(uid: user.uid).updateUserData(
                      _currentSugars ?? "${userdata!.sugars}", 
                      _currentName ?? "${userdata!.name}",
                      _currentStrength ?? userdata!.strength ?? 100, 
                    );
                    Navigator.pop(context);
                  }, 
                  child: Text("Update"),
                  style: ElevatedButton.styleFrom(
                    primary : Colors.pink[400],
                    onPrimary: Colors.white,
                  ),
                )
              ],
            ),
          );
        }
        else{
          return Loading();
        }
      }
    );
  }
}