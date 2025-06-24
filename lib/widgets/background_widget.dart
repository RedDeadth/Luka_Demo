import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;

  const BackgroundWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFF8F8F8), // Fondo gris claro
      child: Stack(
        children: [
          // Vector2 ahora en la posición superior derecha
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/images/vector2.png',
              fit: BoxFit.contain,
            ),
          ),
          
          // Vector1 ahora en la posición inferior izquierda
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/images/vector1.png',
              fit: BoxFit.contain,
            ),
          ),
          
          // Contenido principal
          child,
        ],
      ),
    );
  }
}