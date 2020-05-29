import 'package:flutter/material.dart';
import 'package:login/app/services/auth.dart';
import 'package:login/app/services/database.dart';
import 'package:login/app/sign_in/sign_up_bloc.dart';
import 'package:provider/provider.dart';
import 'package:login/common_widgets/form_submit_button.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({@required this.bloc});
  final SignUpBloc bloc;

  static Widget create(BuildContext context) {
    final database = Provider.of<DatabaseUser>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<SignUpBloc>(
      create: (context) => SignUpBloc(auth: auth, database: database),
      child: Consumer<SignUpBloc>(
        builder: (context, bloc, _) => SignUpPage(bloc: bloc),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController fullNameInputController;
  TextEditingController usernameInputController;
  TextEditingController passwordInputController;
  TextEditingController passwordConfirmationController;
  TextEditingController emailInputController;
  TextEditingController dayController;
  TextEditingController monthController;
  TextEditingController yearController;

  String group = '';

  @override
  void initState() {
    fullNameInputController = TextEditingController();
    usernameInputController = TextEditingController();
    passwordInputController = TextEditingController();
    passwordConfirmationController = TextEditingController();
    emailInputController = TextEditingController();
    dayController = TextEditingController();
    monthController = TextEditingController();
    yearController = TextEditingController();
    super.initState();
  }

  TextField _buildUsernameTextField() {
    return TextField(
      controller: usernameInputController,
      decoration: InputDecoration(
          labelText: 'Username',
          labelStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue[900]))),
      onChanged: widget.bloc.updateUsername,
    );
  }

  TextField _buildFullNameTextField() {
    return TextField(
      controller: fullNameInputController,
      decoration: InputDecoration(
          labelText: 'Full Name',
          labelStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue[900]))),
      onChanged: widget.bloc.updateFullName,
    );
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: passwordInputController,
      decoration: InputDecoration(
          labelText: 'Password',
          labelStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue[900]))),
      obscureText: true,
      onChanged: widget.bloc.updatePassword,
    );
  }

  TextField _buildConfirmPasswordTextField() {
    return TextField(
      controller: passwordConfirmationController,
      decoration: InputDecoration(
          labelText: 'Confirm Password',
          labelStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue[900]))),
      obscureText: true,
    );
  }

  TextFormField _buildEmailTextField() {
    return TextFormField(
      controller: emailInputController,
      decoration: InputDecoration(
          labelText: 'Email',
          labelStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue[900]))),
      onChanged: widget.bloc.updateEmail,
    );
  }

  Container _genderSelection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(2, 15, 50, 00),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Gender',
            style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Male',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                  )),
              Radio(
                value: 'Male',
                groupValue: group,
                onChanged: (T) {
                  print(T);
                  widget.bloc.updateGender('Male');
                  setState(() {
                    group = T;
                  });
                },
              ),
              Text('Female',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                  )),
              Radio(
                  value: 'Female',
                  groupValue: group,
                  onChanged: (T) {
                    print(T);
                    widget.bloc.updateGender('Female');
                    setState(() {
                      group = T;
                    });
                  })
            ],
          ),
        ],
      ),
    );
  }

  Row _birthdaySelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          width: 50,
          child: TextField(
            decoration: InputDecoration(labelText: 'Day'),
            controller: dayController,
            keyboardType: TextInputType.numberWithOptions(
              decimal: false,
              signed: false,
            ),
            onChanged: (_) => widget.bloc.checkDate(),
          ),
        ),
        Container(
          width: 50,
          child: TextField(
            decoration: InputDecoration(labelText: 'Month'),
            controller: monthController,
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
              signed: false,
            ),
            onChanged: (_) => widget.bloc.checkDate(),
          ),
        ),
        Container(
          width: 50,
          child: TextField(
            decoration: InputDecoration(labelText: 'Year'),
            controller: yearController,
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
              signed: false,
            ),
            onChanged: (_) => widget.bloc.checkDate(),
          ),
        ),
      ],
    );
  }

  Widget _buildChildren(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 100.0,
                        child: Image.asset("assets/logo.jpeg")),
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    _buildUsernameTextField(),
                    SizedBox(height: 0.0),
                    _buildFullNameTextField(),
                    SizedBox(height: 5.0),
                    _buildPasswordTextField(),
                    SizedBox(height: 0.0),
                    _buildConfirmPasswordTextField(),
                    _buildEmailTextField(),
                    _genderSelection(),
                    _birthdaySelection(),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 40.0,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              '/login'); //login sayfasının adı gelicek
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.blue[900],
                          color: Colors.grey[50],
                          elevation: 7.0,
                          child: FormSubmitButton(
                            onPressed: () => widget.bloc.createUser(context),
                            text: 'Sign up',
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Already have an account ?',
                ),
                SizedBox(width: 5.0),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: _buildChildren(context),
    );
  }
}
