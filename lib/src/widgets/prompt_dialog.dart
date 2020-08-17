import 'package:flutter/material.dart';

class PromptDialog extends StatefulWidget {
  final String title;
  final String hintText;
  PromptDialog({Key key, this.title, this.hintText}) : super(key: key);
  @override
  _PromptDialogState createState() => _PromptDialogState();
}

class _PromptDialogState extends State<PromptDialog> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.title),
      contentPadding: EdgeInsets.all(16.0),
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
          ),
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context, _controller.text);
          },
        ),
      ],
    );
  }
}
