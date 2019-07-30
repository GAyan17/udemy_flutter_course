import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main_model.dart';
import '../models/auth.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  String _emailValue;
  String _passwordValue;
  bool _acceptTerms = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.75), BlendMode.dstATop),
      image: AssetImage('assets/background.jpg'),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'E-Mail Id',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          icon: Icon(
            Icons.email,
            color: Theme.of(context).accentColor,
          )),
      validator: (String value) {
        if (value.trim().isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Invalid email address';
        }
      },
      onSaved: (String value) {
        _emailValue = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          icon: Icon(
            Icons.vpn_key,
            color: Theme.of(context).accentColor,
          )),
      controller: _passwordController,
      validator: (String value) {
        if (value.trim().isEmpty || value.length < 8) {
          return 'Password is too short';
        }
      },
      onSaved: (String value) {
        _passwordValue = value;
      },
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'Confirm Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          icon: Icon(
            Icons.vpn_key,
            color: Theme.of(context).accentColor,
          )),
      validator: (String value) {
        if (_passwordController.text != value) {
          return 'Passwords do not match';
        }
      },
    );
  }

  Widget _buildSwitch() {
    return SwitchListTile(
      value: _acceptTerms,
      onChanged: (bool value) {
        setState(() {
          _acceptTerms = value;
        });
      },
      title: Text('Accept Terms'),
    );
  }

  void _submitForm(Function authentication) async {
    if (!_formKey.currentState.validate() || !_acceptTerms) {
      return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> successInformation =
        await authentication(_emailValue, _passwordValue, _authMode);
    if (successInformation['success']) {
      Navigator.pushReplacementNamed(context, '/productspage');
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('An Error Occurred'),
              content: Text(successInformation['message']),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Okay'))
              ],
            );
          });
    }
  }

  Widget _buildLoginButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? CircularProgressIndicator()
            : RaisedButton(
                child: Text(_authMode == AuthMode.Login ? 'Login' : 'SignUp'),
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                onPressed: () {
                  _submitForm(model.authentication);
                });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _targetWidth =
        _deviceWidth > 760.0 ? 500.0 : _deviceWidth * 0.95;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: _buildBackgroundImage(),
          ),
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: _targetWidth,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _buildEmailTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildPasswordTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _authMode == AuthMode.Signup
                          ? _buildPasswordConfirmTextField()
                          : Container(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildSwitch(),
                      SizedBox(
                        height: 10.0,
                      ),
                      FlatButton(
                          onPressed: () {
                            setState(() {
                              _authMode = _authMode == AuthMode.Login
                                  ? AuthMode.Signup
                                  : AuthMode.Login;
                            });
                          },
                          child: Text(
                              'Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}')),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildLoginButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
