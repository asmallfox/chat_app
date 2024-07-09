import 'package:flutter/material.dart';

class BottomTabPanel extends StatefulWidget {
  final Function(String)? onSend;
  const BottomTabPanel({
    super.key,
    this.onSend,
  });

  @override
  State<BottomTabPanel> createState() => _BottomTabPanelState();
}

class _BottomTabPanelState extends State<BottomTabPanel> {
  bool showSendButton = false;
  bool showPanel = false;
  double panelHeight = 0.0;

  final TextEditingController _controller = TextEditingController();

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Center(
            child: Text('This is a BottomSheet'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomIconButton(
                icon: Icons.keyboard_voice_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  margin: const EdgeInsets.only(bottom: 4.0),
                  constraints: const BoxConstraints(
                    minHeight: 42,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.0),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Theme.of(context).colorScheme.primary.withAlpha(30),
                        spreadRadius: 3,
                        blurRadius: 25,
                        offset:
                            const Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 8,
                    decoration: null,
                    onChanged: (value) {
                      setState(() {
                        showSendButton = value.isNotEmpty;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CustomIconButton(
                icon: Icons.add,
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  // FocusNode().requestFocus();
                  FocusScope.of(context).requestFocus(FocusNode());

                  // setState(() {
                  //   showPanel = !showPanel;
                  //   // MediaQuery.of(context).size.keyboard
                  //   // FocusScope.of(context).requestFocus(FocusNode());
                  //
                  //   // panelHeight = MediaQuery.of(context).viewInsets.bottom;
                  //   // FocusScope.of(context).requestFocus(FocusNode());
                  //   // print(panelHeight);
                  // });
                },
              ),
              const SizedBox(width: 8),
              Visibility(
                visible: showSendButton,
                child: FilledButton(
                  onPressed: () {
                    if (widget.onSend != null) {
                      widget.onSend!(_controller.text);
                      _controller.text = '';
                    }
                  },
                  style: FilledButton.styleFrom(
                    // backgroundColor: const Color(0xFF34A047),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.all(0),
                  ),
                  child: const Text(
                    '发送',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: showPanel,
            child: Container(
              height: panelHeight,
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 4,
                children: [
                  CustomIconButton(
                    icon: Icons.photo,
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {},
                  ),
                  CustomIconButton(
                    icon: Icons.camera_alt_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {},
                  ),
                  CustomIconButton(
                    icon: Icons.phone,
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {},
                  ),
                  CustomIconButton(
                    icon: Icons.videocam_sharp,
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final double? size;
  final Function()? onPressed;
  const CustomIconButton({
    super.key,
    required this.icon,
    this.color,
    this.backgroundColor,
    this.size = 24.0,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withAlpha(30),
            spreadRadius: 3,
            blurRadius: 25,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: color,
          size: size,
        ),
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all(backgroundColor ?? Colors.white),
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
        ),
      ),
    );
  }
}
