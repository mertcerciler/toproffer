import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:login/app/services/auth.dart';
import 'package:login/app/services/database.dart';
import 'package:login/app/sign_in/sign_up_restaurant_bloc.dart';
import 'package:login/common_widgets/platform_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:login/common_widgets/form_submit_button.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';


const kGoogleApiKey = "AIzaSyBDZPq6C95D8PJ9jQqORGMnWOCp_WXSmaY";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class SignUpRestaurantPage extends StatefulWidget {  
  SignUpRestaurantPage({@required this.bloc});
  final SignUpRestaurantBloc bloc;

  static Widget create(BuildContext context){
    final database = Provider.of<DatabaseUser>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<SignUpRestaurantBloc>(
      create: (context) => SignUpRestaurantBloc(auth: auth, database: database),
      child: Consumer<SignUpRestaurantBloc>(
        builder: (context, bloc, _) => SignUpRestaurantPage(bloc: bloc),  
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _SignUpRestaurantPageState createState() => _SignUpRestaurantPageState();
}

class _SignUpRestaurantPageState extends State<SignUpRestaurantPage> {
  TextEditingController restaurantNameInputController;
  TextEditingController usernameInputController;
  TextEditingController passwordInputController;
  TextEditingController passwordConfirmationController;
  TextEditingController emailInputController;
  TextEditingController cityInputController;
  TextEditingController postalCodeInputController;
  TextEditingController addressInputController;


 

  String group = '';

  @override
  void initState() {
    restaurantNameInputController = TextEditingController();
    usernameInputController = TextEditingController();
    passwordInputController = TextEditingController();
    passwordConfirmationController = TextEditingController();
    emailInputController = TextEditingController();
    postalCodeInputController = TextEditingController();
    cityInputController = TextEditingController();
    addressInputController = TextEditingController();
    super.initState();
  } 

Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();    
    }
    catch(e) {
      print(e.toString());
    }
  } 

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout', 
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout'
    ).show(context);
    if (didRequestSignOut == true) {
      print('Mert');
      _signOut(context);
    }
  }
  
  TextField _buildUsernameTextField() {
    return TextField(
      controller: usernameInputController,
      decoration: InputDecoration(
        labelText: 'Username',
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue[900]),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[900]))),
      onChanged: widget.bloc.updateUsername,
    );
  }

  TextField _buildRestaurantNameTextField() {
    return TextField(
      controller: restaurantNameInputController,
      decoration: InputDecoration(
        labelText: 'Restaurant Name',
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue[900]),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color:Colors.blue[900]))),
      onChanged: widget.bloc.updateRestaurantName,
    );
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: passwordInputController,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue[900]),
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
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue[900]),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[900]))),
          obscureText: true,
    );
  }

  TextFormField _buildEmailTextField() {
    return TextFormField(
      controller: emailInputController,
      decoration: InputDecoration(labelText: 'Email',
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue[900]),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[900]))),
          onChanged: widget.bloc.updateEmail,
   );
  }

  TextFormField _buildAddressTextField() {
    return TextFormField(
      controller: addressInputController,
      decoration: InputDecoration(labelText: 'Address',
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue[900]),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[900]))),
          onChanged: widget.bloc.updateAddress,
   );
  }



  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local.findAddressesFromQuery(p.description);

      print(lat);
      print(p.description);
      print(lng);
      widget.bloc.updateLatitude(lat);
      widget.bloc.updateAddress(p.description);
      widget.bloc.updateLongitude(lng);
    }
  }

  RaisedButton _buildAddressPrediction() {
    return RaisedButton(
          onPressed: () async {
            // show input autocomplete with selected mode
            // then get the Prediction selected
            Prediction p = await PlacesAutocomplete.show(
                context: context, apiKey: kGoogleApiKey,
                mode: Mode.overlay,
                language: "tr",
              );
            displayPrediction(p);
          },
          child: Text('Find address'),

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
                        radius:100.0,
                        child: Image.asset("assets/logo.jpeg")
                        ),
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
                        _buildRestaurantNameTextField(),
                        SizedBox(height: 5.0),
                        _buildPasswordTextField(),
                        SizedBox(height: 0.0),
                        _buildConfirmPasswordTextField(),
                        _buildEmailTextField(),                
                        _buildAddressPrediction(),
                        SizedBox(height: 30,),
                        Container(
                          height: 40.0,
                          child: InkWell(
                            onTap: (){
                              Navigator.of(context).pushNamed('/login');//login sayfasının adı gelicek
                            },
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.blue[900],
                            color: Colors.grey[50],
                            elevation: 7.0,
                            child: FormSubmitButton(
                              onPressed: () => widget.bloc.createRestaurant(context),
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
        title: Text("Register Restaurant"),
        actions: <Widget>[ 
          FlatButton(
            child: Text(
              'Logout', 
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body: _buildChildren(context),
    );
  }
  
  
}