import 'package:flutter/material.dart';
import 'package:shiftr_app/providers/message_provider.dart';

Widget buildConnectionStateText(MQTTAppConnectionState state) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Container(
          color: state == MQTTAppConnectionState.connected
              ? Colors.green
              : state == MQTTAppConnectionState.connected
                  ? Colors.orange
                  : Colors.red,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
                state == MQTTAppConnectionState.connected
                    ? 'Connected'
                    : state == MQTTAppConnectionState.connected
                        ? ' Connecting'
                        : 'Disconnected',
                textAlign: TextAlign.center),
          ),
        ),
      ),
    ],
  );
}

Widget buildTextFieldWith(
    TextEditingController controller,
    String hintText,
    MQTTAppConnectionState state,
    String labelText,
    _messageTextController,
    _hostTextController,
    _topicTextController,
    _nameTextController,
    isChangeable,
    {bool isMessage}) {
  bool shouldEnable = false;
  if (controller == _messageTextController &&
      state == MQTTAppConnectionState.connected) {
    shouldEnable = true;
  } else if ((controller == _hostTextController &&
          state == MQTTAppConnectionState.disconnected) ||
      (controller == _topicTextController &&
          state == MQTTAppConnectionState.disconnected) ||
      (controller == _nameTextController &&
          state == MQTTAppConnectionState.disconnected)) {
    shouldEnable = true;
  }
  return TextField(
    style: TextStyle(color: Colors.black54),
    enabled: shouldEnable && (isChangeable || isMessage),
    controller: controller,
    decoration: InputDecoration(
        floatingLabelBehavior: labelText != null
            ? FloatingLabelBehavior.always
            : FloatingLabelBehavior.never,
        contentPadding:
            const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
        labelText: hintText,
        labelStyle: TextStyle(
            color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 20.0),
        hintText: labelText != null ? labelText : null),
  );
}

Widget buildScrollableTextWith(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Container(
      width: 400,
      height: 250,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.green[500], width: 2)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(text),
        ),
      ),
    ),
  );
}
