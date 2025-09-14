import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  final String message;
  final bool showProgress;

  const LoadingWidget({
    Key? key,
    this.message = 'Loading...',
    this.showProgress = false,
  }) : super(key: key);

  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animation.value * 2.0 * 3.14159,
                  child: Icon(
                    Icons.restaurant,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 24),
          Text(
            widget.message,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8),
          Text(
            'This may take a few moments...',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          if (widget.showProgress) ...[
            SizedBox(height: 16),
            LinearProgressIndicator(),
          ],
        ],
      ),
    );
  }
}