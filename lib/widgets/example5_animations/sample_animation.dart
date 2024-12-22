import 'package:flutter/material.dart';

class ComplexAnimationScreen extends StatefulWidget {
  const ComplexAnimationScreen({super.key});

  @override
  State<ComplexAnimationScreen> createState() => _ComplexAnimationScreenState();
}

class _ComplexAnimationScreenState extends State<ComplexAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _borderRadiusAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _widthAnimation = Tween<double>(begin: 50, end: 200)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _colorAnimation = ColorTween(begin: Colors.blue, end: Colors.green).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInCubic));

    _borderRadiusAnimation = Tween<double>(begin: 0.0, end: 50.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _positionAnimation = Tween<Offset>(
            begin: Offset.zero, end: const Offset(1, 1))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Center(
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.translate(
                offset: _positionAnimation.value * 100,
                child: Container(
                  width: _widthAnimation.value,
                  height: _widthAnimation.value,
                  decoration: BoxDecoration(
                    color: _colorAnimation.value,
                    borderRadius:
                        BorderRadius.circular(_borderRadiusAnimation.value),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
