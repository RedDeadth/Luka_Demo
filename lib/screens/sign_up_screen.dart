import 'package:flutter/material.dart';
import '../widgets/background_widget.dart';
import 'email_verification_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isStudent = true;
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  // Logo
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Título
                  const Text(
                    'Registro de cuenta',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  const Text(
                    'Primero creemos tu cuenta',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  const Text(
                    'Ya tienes cuenta? Inicia sesión',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Campos del formulario
                  _buildTextField('Nombre', _nameController, Icons.person_outline),
                  const SizedBox(height: 16),
                  
                  _buildTextField('Apellido', _lastNameController, Icons.person_outline),
                  const SizedBox(height: 16),
                  
                  _buildTextField('Correo', _emailController, Icons.email_outlined),
                  const SizedBox(height: 16),
                  
                  _buildTextField('Contraseña', _passwordController, Icons.lock_outline, isPassword: true),
                  const SizedBox(height: 16),
                  
                  _buildTextField('Confirma contraseña', _confirmPasswordController, Icons.lock_outline, isPassword: true),
                  
                  const SizedBox(height: 24),
                  
                  // Toggle Estudiante/Empresa
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isStudent = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _isStudent ? Colors.black : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Text(
                              'ESTUDIANTE',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _isStudent ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isStudent = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_isStudent ? Colors.black : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Text(
                              'EMPRESA',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: !_isStudent ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildTextField('CIUDAD', TextEditingController(), Icons.location_on_outlined),
                  
                  const SizedBox(height: 24),
                  
                  // Checkbox términos
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        onChanged: (value) => setState(() => _acceptTerms = value ?? false),
                      ),
                      const Expanded(
                        child: Text(
                          'Create Account, you agree to the Terms of Use and Privacy Policy',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Botón Crear Account
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _acceptTerms ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EmailVerificationScreen()),
                        );
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(icon, color: Colors.grey),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                hintText: label,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}