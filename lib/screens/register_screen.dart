import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/register/register_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/register/register_event.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/register/register_state.dart';

class RegisterScreen extends StatelessWidget {

    RegisterScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
        if (state is RegisterFailure) {
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
                      color: Colors.white.withAlpha((0.7 * 255).toInt()),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _iconBack(context),
                          _iconPerson(),
                          _textRegister(),
                          _textFieldName(),
                          _textFieldLastname(),
                          _textFieldEmail(),
                          _textFieldPhone(),
                          _textFieldPassword(),
                          _textFieldConfirmPassword(),
                          _buttonRegister(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (state is RegisterLoading)
                Center(child: CircularProgressIndicator()),
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

  Widget _iconBack(BuildContext context) {
    return Positioned(
      top: 20,
      left: 20,
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
      ),
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

  Widget _textRegister() {
    return Text(
      'REGISTRO',
      style: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _textFieldName() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        labelText: 'Nombre',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'El nombre es requerido';
        return null;
      },
    );
  }

  Widget _textFieldLastname() {
    return TextFormField(
      controller: _lastnameController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person_outline),
        labelText: 'Apellido',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'El apellido es requerido';
        return null;
      },
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

  Widget _textFieldPhone() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.phone),
        labelText: 'Teléfono',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'El teléfono es requerido';
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
        if (value.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
        return null;
      },
    );
  }

  Widget _textFieldConfirmPassword() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock_outline),
        labelText: 'Confirmar Contraseña',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'La confirmación de contraseña es requerida';
        if (value != _passwordController.text) return 'Las contraseñas no coinciden';
        return null;
      },
    );
  }

  Widget _buttonRegister(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          context.read<RegisterBloc>().add(
            RegisterButtonPressed(
              nombre: _nameController.text,
              apellido: _lastnameController.text,
              telefono: _phoneController.text,
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        fixedSize: Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        'REGISTRARSE',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

