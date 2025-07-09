import 'supabase_service.dart';

class UserManager {
  static Map<String, dynamic>? _currentUser;
  static Map<String, dynamic>? _currentAccount;

  // Usuario actual
  static Map<String, dynamic>? get currentUser => _currentUser;
  static bool get isLoggedIn => _currentUser != null;
  static int get userId => _currentUser?['id'] ?? 0;
  static String get userName =>
      '${_currentUser?['nombre'] ?? ''} ${_currentUser?['apellido'] ?? ''}'
          .trim();
  static String get userEmail => _currentUser?['email'] ?? '';

  // Cuenta actual
  static Map<String, dynamic>? get currentAccount => _currentAccount;
  static int get accountId => _currentAccount?['id'] ?? 0;
  static double get balance => (_currentAccount?['saldo'] ?? 0.0).toDouble();
  static String get accountNumber => _currentAccount?['numero_cuenta'] ?? '';

  // Setters
  static void setUser(Map<String, dynamic> user) {
    _currentUser = user;
  }

  static void setAccount(Map<String, dynamic> account) {
    _currentAccount = account;
  }

  static void updateBalance(double newBalance) {
    if (_currentAccount != null) {
      _currentAccount!['saldo'] = newBalance;
    }
  }

  // Logout
  static void logout() {
    _currentUser = null;
    _currentAccount = null;
  }

  // Login completo (usuario + cuenta)
  static Future<bool> loginWithEmail(String email, String password) async {
    try {
      // Usar el servicio ya importado
      // Login del usuario
      final user = await SupabaseService.loginUser(email, password);
      if (user == null) return false;

      setUser(user);

      // Obtener la cuenta del usuario
      final account = await SupabaseService.getUserAccount(user['id']);
      if (account != null) {
        setAccount(account);
      }

      return true;
    } catch (e) {
      print('Error en login: $e');
      return false;
    }
  }
}
