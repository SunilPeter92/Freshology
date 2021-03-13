import 'package:flutter/material.dart';
import 'package:freshology/models/userModel.dart';

class ProfileSettingsDialog extends StatefulWidget {
  User user;
  VoidCallback onChanged;

  ProfileSettingsDialog({Key key, this.user, this.onChanged}) : super(key: key);

  @override
  _ProfileSettingsDialogState createState() => _ProfileSettingsDialogState();
}

class _ProfileSettingsDialogState extends State<ProfileSettingsDialog> {
  GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  titlePadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  title: Row(
                    children: <Widget>[
                      Icon(Icons.person),
                      SizedBox(width: 10),
                      Text(
                        "Profile Settings",
                        style: Theme.of(context).textTheme.body2,
                      )
                    ],
                  ),
                  children: <Widget>[
                    Form(
                      key: _profileSettingsFormKey,
                      child: Column(
                        children: <Widget>[
                          new TextFormField(
                            style:
                                TextStyle(color: Theme.of(context).hintColor),
                            keyboardType: TextInputType.text,
                            decoration: getInputDecoration(
                                hintText: "Jhon doe", labelText: "Full name"),
                            initialValue: widget.user.name,
                            validator: (input) =>
                                input.trim().length < 3 ? "Invalid name" : null,
                            onSaved: (input) => widget.user.name = input,
                          ),
                          // new TextFormField(
                          //   style:
                          //       TextStyle(color: Theme.of(context).hintColor),
                          //   keyboardType: TextInputType.emailAddress,
                          //   decoration: getInputDecoration(
                          //       hintText: 'johndo@gmail.com',
                          //       labelText: "Invalid email"),
                          //   initialValue: widget.user.email,
                          //   validator: (input) =>
                          //       !input.contains('@') ? "Invalid email" : null,
                          //   onSaved: (input) => widget.user.email = input,
                          // ),
                          new TextFormField(
                            style:
                                TextStyle(color: Theme.of(context).hintColor),
                            keyboardType: TextInputType.text,
                            decoration: getInputDecoration(
                                hintText: '+136 269 9765',
                                labelText: "Phone number"),
                            initialValue: widget.user.phone,
                            validator: (input) => input.trim().length < 3
                                ? "Invalid phone number"
                                : null,
                            onSaved: (input) => widget.user.phone = input,
                          ),
                          new TextFormField(
                            style:
                                TextStyle(color: Theme.of(context).hintColor),
                            keyboardType: TextInputType.text,
                            decoration: getInputDecoration(
                                hintText: "Bio", labelText: "About"),
                            initialValue: widget.user.bio,
                            validator: (input) => input.trim().length < 3
                                ? "Not a valid bio"
                                : null,
                            onSaved: (input) => widget.user.bio = input,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel"),
                        ),
                        MaterialButton(
                          onPressed: _submit,
                          child: Text(
                            "Save",
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                    SizedBox(height: 10),
                  ],
                );
              });
        },
        child: Container(
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ));
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.body1.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      hasFloatingPlaceholder: true,
      labelStyle: Theme.of(context).textTheme.body1.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void _submit() {
    if (_profileSettingsFormKey.currentState.validate()) {
      _profileSettingsFormKey.currentState.save();
      widget.onChanged();
      Navigator.pop(context);
    }
  }
}
