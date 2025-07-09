import 'package:flutter/material.dart';
import '../widgets/background_widget.dart';
import '../services/supabase_service.dart';
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
  final _cityController = TextEditingController();
  final _studentCodeController = TextEditingController();
  bool _isStudent = true;
  bool _acceptTerms = false;
  bool _isLoading = false;

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
                    'Solo estudiantes pueden registrarse',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Ya tienes cuenta? Inicia sesión',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Campos del formulario
                  _buildTextField('Nombre', _nameController, Icons.person_outline),
                  const SizedBox(height: 16),
                  
                  _buildTextField('Apellido', _lastNameController, Icons.person_outline),
                  const SizedBox(height: 16),
                  
                  _buildTextField('Correo electrónico', _emailController, Icons.email_outlined),
                  const SizedBox(height: 16),
                  
                  _buildTextField('Código de estudiante', _studentCodeController, Icons.school_outlined),
                  const SizedBox(height: 16),
                  
                  _buildTextField('Contraseña', _passwordController, Icons.lock_outline, isPassword: true),
                  const SizedBox(height: 16),
                  
                  _buildTextField('Confirma contraseña', _confirmPasswordController, Icons.lock_outline, isPassword: true),
                  
                  const SizedBox(height: 16),
                  
                  _buildTextField('Ciudad', _cityController, Icons.location_on_outlined),
                  
                  const SizedBox(height: 24),
                  
                  // Solo estudiantes permitidos
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade300),
                    ),
                    child: const Text(
                      'ESTUDIANTE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Información de bienvenida
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/luka_moneda.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Recibirás 10 LUKAS de bienvenida al registrarte',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Checkbox términos
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        onChanged: (value) => setState(() => _acceptTerms = value ?? false),
                        activeColor: Colors.blue,
                      ),
                      const Expanded(
                        child: Text(
                          'Acepto los términos y condiciones de uso',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Botón Crear Account - FUNCIONAL
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_acceptTerms && !_isLoading) ? _handleRegister : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Crear Cuenta',
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

  Future<void> _handleRegister() async {
    if (!_validateInputs()) return;

    setState(() => _isLoading = true);

    try {
      // Registrar usuario en la base de datos
      final success = await SupabaseService.registerUser(
        nombre: _nameController.text.trim(),
        apellido: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        empresa: 'TecSup', // Por defecto para estudiantes
        universidad: 'TecSup', // Por defecto para estudiantes
        codigoEstudiante: _studentCodeController.text.trim(),
      );

      if (success) {
        // Crear cuenta con saldo inicial de 10 LUKAS
        await _createInitialAccount();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Cuenta creada exitosamente! Recibirás 10 LUKAS de bienvenida.'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Navegar a verificación de email
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EmailVerificationScreen()),
          );
        }
      } else {
        _showMessage('Error al crear la cuenta. Verifica que el email no esté registrado.');
      }
    } catch (e) {
      _showMessage('Error de conexión: $e');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _createInitialAccount() async {
    try {
      // Buscar el usuario recién creado
      final users = await SupabaseService.client
          .from('users')
          .select('id')
          .eq('email', _emailController.text.trim())
          .limit(1);

      if (users.isNotEmpty) {
        final userId = users.first['id'];
        
        // Crear cuenta con saldo inicial
        await SupabaseService.client.from('cuentas').insert({
          'user_id': userId,
          'saldo': 10.0, // 10 LUKAS de bienvenida
          'estado': 'activa',
        });
      }
    } catch (e) {
      print('Error creando cuenta inicial: $e');
    }
  }

  bool _validateInputs() {
    if (_nameController.text.trim().isEmpty) {
      _showMessage('Por favor ingresa tu nombre');
      return false;
    }
    
    if (_lastNameController.text.trim().isEmpty) {
      _showMessage('Por favor ingresa tu apellido');
      return false;
    }
    
    if (_emailController.text.trim().isEmpty || !_emailController.text.contains('@')) {
      _showMessage('Por favor ingresa un email válido');
      return false;
    }
    
    if (_studentCodeController.text.trim().isEmpty) {
      _showMessage('Por favor ingresa tu código de estudiante');
      return false;
    }
    
    if (_passwordController.text.length < 6) {
      _showMessage('La contraseña debe tener al menos 6 caracteres');
      return false;
    }
    
    if (_passwordController.text != _confirmPasswordController.text) {
      _showMessage('Las contraseñas no coinciden');
      return false;
    }
    
    if (_cityController.text.trim().isEmpty) {
      _showMessage('Por favor ingresa tu ciudad');
      return false;
    }
    
    return true;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}