import 'package:flutter/material.dart';
import 'package:login/app/services/auth.dart';
import 'package:login/app/sign_in/e-mail_sign_in_bloc.dart';
import 'package:login/app/sign_in/e-mail_sign_in_model.dart';
import 'package:login/common_widgets/platform_exception_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:login/common_widgets/form_submit_button.dart';
import 'package:flutter/services.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  EmailSignInFormBlocBased({@required this.bloc});
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context){
    final AuthBase auth = Provider.of<AuthBase>(context);
    return Provider<EmailSignInBloc>(
      create: (context) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (context, bloc, _) => EmailSignInFormBlocBased(bloc: bloc),  
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInFormBlocBased> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passswordFocusNode = FocusNode();

  Future<void> _submit(BuildContext context) async {
    try {
      await widget.bloc.submit(context);
    }
    on PlatformException catch (e) {
      PlatformExceptionAlertDialog(title: 'Sign In Failed',
        exception: e
        ).show(context);
    } 
  }
  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus = model.emailValidator.isValid(model.email)
      ? _passswordFocusNode
      : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }
  
  TextField _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: model.emailErrorText,
        enabled: model.isLoading == false,
        labelStyle: TextStyle(fontWeight: FontWeight.bold,
          color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.green))
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: widget.bloc.updateEmail, 
      onEditingComplete: () => _emailEditingComplete(model),
    );
  }
  TextField _buildPasswordTextField(EmailSignInModel model) {
    return TextField(
      controller: _passwordController,
      focusNode: _passswordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.green))
      ),
      obscureText: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      onChanged: widget.bloc.updatePassword,
      onEditingComplete:() =>  _submit(context),
    );
  }
  
  List<Widget> _buildChildren(BuildContext context, EmailSignInModel model) {
    return [
      _buildEmailTextField(model),
      SizedBox(height: 8.0),
      _buildPasswordTextField(model),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: 'Sign In',
        onPressed: () => model.canSubmit ? _submit(context) : null,
      ),
      SizedBox(height: 8.0),
      ];  
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot) {
        final EmailSignInModel model = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buildChildren(context, model),
          ),
        );
      }
    );
  }
}