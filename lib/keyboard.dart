import 'package:flutter/material.dart';
import './keyboard_controller.dart';

class OnScreenKeyboard<T> extends StatefulWidget {
  const OnScreenKeyboard({
    super.key,
    required this.onValuesChanged,
    this.focusedValueIndex,
    required this.controller,
  });
  final KeyboardController<T> controller;
  final void Function(List<T?>) onValuesChanged;
  final int? focusedValueIndex;

  @override
  State<OnScreenKeyboard<T>> createState() => _OnScreenKeyboardState<T>();

  static final List<String> chars = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
  // static const specialChar = 'B';
  static const specialChar = '⌫';
}

class _OnScreenKeyboardState<T> extends State<OnScreenKeyboard<T>> {
  final keyboardKey = GlobalKey();

  String? shownKey;
  Offset? shownKeyPosition;
  double? shownTileSize;

  void onShowKey(Offset pos, BuildContext context) {
    final keyContext = keyboardKey.currentContext;
    if (keyContext == null) return;
    if (keyContext.findRenderObject() == null) return;
    final size = (keyContext.findRenderObject()! as RenderBox).size;

    if (pos.dx < 0 ||
        pos.dx > size.width ||
        pos.dy < 0 ||
        pos.dy > size.height) {
      shownKey = null;
      shownKeyPosition = null;
      shownTileSize = null;
      setState(() {});
      return;
    }

    var tileSize = 0.0;

    tileSize = size.width / 11;

    shownTileSize = tileSize;
    final currentColumn = (pos.dx / tileSize).floor();

    shownKey = [...OnScreenKeyboard.chars, OnScreenKeyboard.specialChar].elementAt(currentColumn);
    var x = (currentColumn * tileSize);

    shownKeyPosition = Offset(x, -50);
    setState(() {});
  }

  void onShownKeyChanged(Offset pos, BuildContext context) {
    onShowKey(pos, context);
  }

  bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: DefaultTextStyle(
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xffa02b5f),
          fontSize: 18,
        ),
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Listener(
                onPointerDown: (event) {
                  setState(() {
                    isEnabled = true;
                    onShowKey(event.localPosition, context);
                  });
                },
                onPointerUp: (event) {
                  setState(() {
                    isEnabled = false;
                    if (widget.focusedValueIndex == null) {
                      shownKey = null;
                      shownKeyPosition = null;
                      shownTileSize = null;
                    }
                    if (shownKey == OnScreenKeyboard.specialChar) {
                      widget.controller.onDelete(
                        widget.focusedValueIndex!,
                      );
                      widget.onValuesChanged(widget.controller.values);
                    } 
                    if(OnScreenKeyboard.chars.contains(shownKey)){
                      print('$shownKey index: ${widget.focusedValueIndex}');
                      widget.controller.changeValueAt(
                          widget.focusedValueIndex!, int.parse("$shownKey"));
                      widget.onValuesChanged(widget.controller.values);
                    }
                    shownKey = null;
                    shownKeyPosition = null;
                    shownTileSize = null;
                  });
                },
                child: GestureDetector(
                  key: keyboardKey,
                  onPanUpdate: isEnabled
                      ? (details) =>
                          {onShownKeyChanged(details.localPosition, context)}
                      : (_) {},
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    color: const Color(0xffECE6E9),
                    child: GridView.count(
                      childAspectRatio:
                          (MediaQuery.of(context).size.width / 11) / 48,
                      crossAxisSpacing: 2,
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      crossAxisCount: 11,
                      children: List.generate(
                        11,
                        (index) => KeyboardButton(
                          label: [...OnScreenKeyboard.chars, OnScreenKeyboard.specialChar][index],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (shownKey != null &&
                  shownKeyPosition != null &&
                  shownTileSize != null)
                Builder(
                  builder: (context) {
                    final width = MediaQuery.of(context).size.width;
                    return Positioned(
                      top: 0,
                      left: 0,
                      child: Transform.translate(
                        offset: Offset(
                            shownKey != '⌫'
                                ? shownKeyPosition!.dx
                                : shownKeyPosition!.dx - 75,
                            -75),
                        child: Container(
                          width: shownKey != '⌫' ? (width / 11) * 1.5 : 100,
                          height: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 4,
                                spreadRadius: 1,
                                offset: Offset(2, 2),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xffC4C4C4)),
                            color: const Color(0xffE4E4E4),
                          ),
                          child: Text(
                            shownKey!.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 48,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class KeyboardButton extends StatelessWidget {
  const KeyboardButton({
    super.key,
    required this.label,
    this.value,
    this.iconData,
  });

  final String label;
  final String? value;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white70,
      ),
      child: Center(
        child: iconData == null
            ? Text(label)
            : Icon(
                iconData,
                size: 18,
                color: const Color(
                  0xff415a70,
                ),
              ),
      ),
    );
  }
}
