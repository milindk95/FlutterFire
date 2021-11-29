import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SlidingControl extends StatefulWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int>? onIndexChanged;

  const SlidingControl({
    Key? key,
    required this.labels,
    this.selectedIndex = 0,
    this.onIndexChanged,
  }) : super(key: key);

  @override
  _SlidingControlState createState() => _SlidingControlState();
}

class _SlidingControlState extends State<SlidingControl> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: CupertinoSlidingSegmentedControl<int>(
        groupValue: _selectedIndex,
        children: Map.fromIterables(
          widget.labels.asMap().keys,
          widget.labels.map(
            (label) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: widget.labels[_selectedIndex] == label
                      ? FontWeight.bold
                      : null,
                ),
              ),
            ),
          ),
        ),
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        onValueChanged: (index) {
          setState(() => _selectedIndex = index ?? 0);
          widget.onIndexChanged?.call(_selectedIndex);
        },
      ),
    );
  }
}
