import 'package:flutter/material.dart';

/// A loading animation that displays bars moving up and down like a music equalizer
class LoadingWaveAnimation extends StatefulWidget {
  /// Number of bars to display
  final int barCount;

  /// Color of the bars
  final Color color;

  /// Width of each bar
  final double barWidth;

  /// Maximum height of the bars
  final double maxHeight;

  /// Minimum height of the bars
  final double minHeight;

  /// Spacing between bars
  final double spacing;

  const LoadingWaveAnimation({
    super.key,
    this.barCount = 4,
    this.color = Colors.blue,
    this.barWidth = 4.0,
    this.maxHeight = 20.0,
    this.minHeight = 6.0,
    this.spacing = 3.0,
  });

  @override
  State<LoadingWaveAnimation> createState() => _LoadingWaveAnimationState();
}

class _LoadingWaveAnimationState extends State<LoadingWaveAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _controllers = List.generate(
      widget.barCount,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400 + (index * 100)),
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: widget.minHeight,
        end: widget.maxHeight,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );
    }).toList();

    // Start animations with staggered delays
    for (int i = 0; i < widget.barCount; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(widget.barCount, (index) {
        return _WaveBar(
          animation: _animations[index],
          color: widget.color,
          barWidth: widget.barWidth,
          spacing: widget.spacing,
        );
      }),
    );
  }
}

class _WaveBar extends AnimatedWidget {
  final Color color;
  final double barWidth;
  final double spacing;

  const _WaveBar({
    required Animation<double> animation,
    required this.color,
    required this.barWidth,
    required this.spacing,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: spacing / 2),
      width: barWidth,
      height: animation.value,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(barWidth / 2),
      ),
    );
  }
}
