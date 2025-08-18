import 'dart:developer';

import 'package:flutter/material.dart';

class DemoSwipePage extends StatelessWidget {
  const DemoSwipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Swipe-to-Reply Demo')),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: SwipeReplyContainer(
            onSwipeLeft: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Swipe LEFT on item $i')));
            },
            onSwipeRight: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Swipe RIGHT on item $i')));
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('Message $i'),
            ),
          ),
        ),
      ),
    );
  }
}

class SwipeReplyContainer extends StatefulWidget {
  const SwipeReplyContainer({
    super.key,
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.swipeThreshold = 80,
    this.maxDrag = 120,
  });

  final Widget child;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final double swipeThreshold;
  final double maxDrag;

  @override
  State<SwipeReplyContainer> createState() => _SwipeReplyContainerState();
}

class _SwipeReplyContainerState extends State<SwipeReplyContainer>
    with SingleTickerProviderStateMixin {
  double _dx = 0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 200),
        )..addListener(() {
          setState(() {
            _dx = Tween<double>(begin: _dx, end: 0).animate(_controller).value;
          });
        });
  }

  void _snapBack() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dx += details.delta.dx;
          _dx = _dx.clamp(-widget.maxDrag, widget.maxDrag);
        });
      },
      onHorizontalDragEnd: (details) {
        if (_dx.abs() > widget.swipeThreshold) {
          if (_dx > 0) {
            log("right swiped");
            widget.onSwipeRight?.call();
          } else {
            log("left swiped");
            widget.onSwipeLeft?.call();
          }
        }
        _snapBack();
      },
      child: Transform.translate(offset: Offset(_dx, 0), child: widget.child),
    );
  }
}
