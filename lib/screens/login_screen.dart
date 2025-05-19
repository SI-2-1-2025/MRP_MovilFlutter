import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/auth/auth_state.dart';
import 'package:mrp_aplicacion_movil_flutter/screens/home_screen.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          print('Estado: AuthSuccess');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: BlocProvider.of<AuthBloc>(context),
                child: HomeScreen(),
              ),
            ),
          );
        }
        if (state is AuthFailure) {
          print('Error: ${state.error}');
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              _imageBackground(),
              Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _iconPerson(),
                          _textLogin(),
                          _textFieldEmail(),
                          _textFieldPassword(),
                          _buttonLogin(context),
                          _textDontHaveAccount(),
                          _buttonGoToRegister(context),

                        ],
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        );
      },
    );
  }

  Widget _imageBackground() {
    return Image.asset(
      'assets/img/background3.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      color: Color.fromRGBO(0, 0, 0, 0.6),
      colorBlendMode: BlendMode.darken,
    );
  }

  Widget _iconPerson() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.white,
        child: Icon(Icons.person, size: 60, color: Colors.grey),
      ),
    );
  }

  Widget _textLogin() {
    return Text(
      'LOGIN',
      style: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _textFieldEmail() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        labelText: 'Correo electrónico',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'El correo es requerido';
        return null;
      },
    );
  }

  Widget _textFieldPassword() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        labelText: 'Contraseña',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'La contraseña es requerida';
        return null;
      },
    );
  }

  Widget _buttonLogin(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        //if (_formKey.currentState!.validate()) {
          context.read<AuthBloc>().add(
            LoginButtonPressed(
              email: _emailController.text,
              password: _passwordController.text,
              //email: 'ww@gmail.com',
              //password: '123456789',
            ),
          );
        //}//
      },

      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        fixedSize: Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        'INICIAR SESIÓN',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),

    );
  }

  Widget _textDontHaveAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 1,
          color: Colors.grey,
        ),
        SizedBox(width: 10),
        Text(
          '¿No tienes cuenta?',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        SizedBox(width: 10),
        Container(
          width: 60,
          height: 1,
          color: Colors.grey,
        ),
      ],
    );
  }
 //me lleva a la otra vista
  Widget _buttonGoToRegister(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, '/register'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        fixedSize: Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        'REGISTRATE',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}