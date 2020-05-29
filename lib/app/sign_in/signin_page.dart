import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login/app/services/auth.dart';
import 'package:login/app/sign_in/sign_in_manager.dart';
import 'package:login/app/sign_in/sign_up_page.dart';
import 'package:login/common_widgets/platform_exception_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:login/app/sign_in/e-mail_signin_page.dart';
import 'package:login/app/sign_in/sign_in_button.dart';
import 'package:login/app/sign_in/social_sign_in_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.manager, @required this.isLoading}) : super(key: key);
  final SignInManager manager;
  final bool isLoading;

  static Widget create(BuildContext context){
    final auth = Provider.of<AuthBase>(context); 
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),  
          child: Consumer<SignInManager>(
            builder: (context, manager, _) =>  SignInPage(manager: manager, isLoading: isLoading.value),
          )
        ),
      ),
    );
  }
  
  void _showSignInError(BuildContext context, PlatformException exception){
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  // Future<void> _signInWithGoogle(BuildContext context) async {
  //   try {
  //     await manager.signInWithGoogle();
  //   }
  //   on PlatformException catch (e){
  //     if (e.code != 'ERROR_ABORTED_BY_USER'){
  //       _showSignInError(context, e);
  //     }
  //   }
  // }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage()
      ),    
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Toproffer'),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Scaffold(
          body: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Container(
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius:100.0,
                      child: Image.asset("assets/logo.jpeg")
                   )
                  ),
                  SizedBox(height: 5.0),
                  _buildHeader(), 
                  // SizedBox(height: 35.0),
                  // SocialSignInButton(
                  //   assetName: 'assets/google-logo.png',
                  //   text: 'Sign In With Google',
                  //   textColor: Colors.black87,
                  //   color: Colors.white,
                  //   onPressed: isLoading ? null : () =>  _signInWithGoogle(context),
                  // ),
                  SizedBox(height: 15.0),
                  // Text(
                  //   'Or',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 20
                  //   ),
                  // ),
                  SizedBox(height: 15.0),
                  SignInButton(
                    text: 'Sign in with email',
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: isLoading ? null : () => _signInWithEmail(context),
                  ),
                  SizedBox(height: 8.0),
                  FlatButton(
                    child: Text(
                      'Need an account? Register.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    onPressed: () =>  _navigatorToSignUp(context),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,     
                  )
                ],
              ),
            ],
 )),
    );
  }
  Widget _buildHeader() {
    if(isLoading) {
      return Center(child: CircularProgressIndicator(),
      );
    }
    else {
      return Text(
        'Sign In',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

 void _navigatorToSignUp(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => SignUpPage.create(context),
      ),  
    );
  }
}