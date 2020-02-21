import 'package:flutter/material.dart';

class ItemFabWith {
  IconData icon;
  String title;
  String heroTag;

  ItemFabWith({this.icon, this.title, this.heroTag});
}

class FabWithIcons extends StatefulWidget {
  FabWithIcons({this.icons, this.onIconTapped});

  final List<ItemFabWith> icons;
  final ValueChanged<int> onIconTapped;

  @override
  State createState() => FabWithIconsState();
}

class FabWithIconsState extends State<FabWithIcons>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: <Widget>[
          ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Interval(0.0, 1.0 - 0 / widget.icons.length / 2.0,
                  curve: Curves.easeOut),
            ),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(widget.icons.length, (int index) {
                      return _buildChild(index);
                    }) /*.toList()
                      ..add(

                      ),*/
                    ),
              ),
            ),
          ),
          _buildFab(),
        ],
      ),
    );
  }

  Widget _buildChild(int index) {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).accentColor;
    return Container(
      height: 70.0,
      alignment: FractionalOffset.centerRight,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(0.0, 1.0 - index / widget.icons.length / 2.0,
              curve: Curves.easeOut),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            /*Text(
              widget.icons[index].title,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  decoration: TextDecoration.none),
            ),*/
            Padding(
              padding: EdgeInsets.all(5),
            ),
            FloatingActionButton(
              heroTag:
                  widget.icons[index].heroTag ?? "item_${index.toString()}",
              backgroundColor: backgroundColor,
              mini: true,
              child: Icon(widget.icons[index].icon, color: foregroundColor),
              onPressed: () => _onTapped(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () {
        if (_controller.isDismissed) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      tooltip: '',
      child: Icon(Icons.add),
      elevation: 1.0,
    );
  }

  void _onTapped(int index) {
    _controller.reverse();
    widget.onIconTapped(index);
  }
}
