import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PressAndHoldButton extends StatefulWidget {
  final VoidCallback onCheckout;
  final Duration holdDuration;
  final Color color;
  final Color? progressColor;
  final Widget label;
  final double? width;
  final double height;
  final double radius;

  const PressAndHoldButton({
    Key? key,
    required this.onCheckout,
    required this.label,
    required this.color,
    this.progressColor,
    this.holdDuration = const Duration(milliseconds: 1000),
    this.width,
    this.height = 50,
    this.radius = 20,
  }) : super(key: key);

  @override
  State<PressAndHoldButton> createState() => _PressAndHoldButtonState();
}

class _PressAndHoldButtonState extends State<PressAndHoldButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  AnimationStatus? _animationStatus;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.holdDuration,
    )..addStatusListener((status) {
      _animationStatus = status;
      if (status == AnimationStatus.completed) {
        HapticFeedback.mediumImpact();
        widget.onCheckout();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTapDown: (_) {
        _controller.value = 0;
        _controller.forward(from: 0.0);
      },
      onLongPressEnd: (_) => _controller.animateBack(0.0, duration: const Duration(milliseconds: 200), curve: Curves.easeOut),
      child: AnimatedBuilder(
        animation: _controller,
        child: widget.label,
        builder: (context, child) {
          return SizedBox(
            width: widget.width ?? screenWidth * 0.9,
            height: widget.height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.radius),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: widget.color),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _controller.value, // fills from left to right
                    child: Container(color: widget.progressColor ?? const Color(0x60000000)),
                  ),
                  // label on top (child is built once)
                  Center(child: child),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
