import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fef_mobile_clock/src/components/custom_app_bar.dart';
import 'package:fef_mobile_clock/src/components/custom_bottom_navigation_bar.dart';
import 'package:fef_mobile_clock/src/providers/user_provider.dart';
import 'package:fef_mobile_clock/src/services/config_services.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  ConfigScreenState createState() => ConfigScreenState();
}

class ConfigScreenState extends State<ConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  int _currentIndex = 1;

  void _onBottomNavigationTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleConfig(String employeeToken) async {
    final result = await changePassword(
      employeeToken,
      _passwordController.text,
      _newPasswordController.text,
      _confirmNewPasswordController.text,
    );
    if (result['success']) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result['message'])));
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeeToken =
        Provider.of<UserProvider>(context, listen: false).accessToken;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Configuração'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPasswordField('Senha Atual', _passwordController),
                const SizedBox(height: 16.0),
                _buildPasswordField('Nova Senha', _newPasswordController),
                const SizedBox(height: 16.0),
                _buildPasswordField(
                    'Confirme Nova Senha', _confirmNewPasswordController),
                const SizedBox(height: 24.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _handleConfig(employeeToken!);
                      }
                    },
                    child: const Text('Mudar Senha'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavigationTap,
      ),
    );
  }

  Widget _buildPasswordField(
      String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira a $labelText';
        }
        return null;
      },
      obscureText: true,
    );
  }
}
