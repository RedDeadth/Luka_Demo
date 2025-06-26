import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _textColorAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _textColorAnimation = ColorTween(
      begin: Colors.white.withOpacity(0.3),
      end: Colors.white,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 0.8, curve: Curves.easeInOut),
    ));

    _startAnimation();
  }

  void _startAnimation() async {
    await _animationController.forward();
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 600;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1E88E5),
                Color(0xFF42A5F5),
                Color(0xFF90CAF9),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    'assets/images/vector2.png',
                    width: screenWidth * 0.7,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    'assets/images/vector1.png',
                    width: screenWidth * 0.7,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Center( // Añadido widget Center para asegurar el centrado absoluto
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center, // Asegura centrado horizontal
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: isSmallScreen ? 20 : 40),
                              child: Image.asset(
                                'assets/images/logo2.png',
                                width: isSmallScreen ? 80 : 120,
                                height: isSmallScreen ? 80 : 120,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(
                              width: isSmallScreen ? 20 : 30,
                              height: isSmallScreen ? 20 : 30,
                              child: CircularProgressIndicator(
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 3,
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 20 : 40),
                            ConstrainedBox( // Añadido para limitar el ancho del texto
                              constraints: BoxConstraints(
                                maxWidth: screenWidth * 0.8, // Limita el ancho máximo
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20), // Padding consistente
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AnimatedBuilder(
                                      animation: _textColorAnimation,
                                      builder: (context, child) {
                                        return Text(
                                          'Encaminando',
                                          style: TextStyle(
                                            color: _textColorAnimation.value,
                                            fontSize: isSmallScreen ? 20 : 24,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.5,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 10,
                                                color: Colors.black.withOpacity(0.2),
                                                offset: const Offset(2, 2),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        );
                                      },
                                    ),
                                    SizedBox(height: isSmallScreen ? 6 : 8),
                                    AnimatedBuilder(
                                      animation: _textColorAnimation,
                                      builder: (context, child) {
                                        return Text(
                                          'la sostenibilidad',
                                          style: TextStyle(
                                            color: _textColorAnimation.value,
                                            fontSize: isSmallScreen ? 20 : 24,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.5,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 10,
                                                color: Colors.black.withOpacity(0.2),
                                                offset: const Offset(2, 2),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        );
                                      },
                                    ),
                                    SizedBox(height: isSmallScreen ? 6 : 8),
                                    AnimatedBuilder(
                                      animation: _textColorAnimation,
                                      builder: (context, child) {
                                        return Text(
                                          'y la tecnología ...',
                                          style: TextStyle(
                                            color: _textColorAnimation.value,
                                            fontSize: isSmallScreen ? 20 : 24,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.5,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 10,
                                                color: Colors.black.withOpacity(0.2),
                                                offset: const Offset(2, 2),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}