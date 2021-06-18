import 'package:flutter/material.dart';
import 'package:shiftr_app/providers/message_provider.dart';

Widget buildChangeButton(MQTTAppConnectionState state, Function callback) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: Colors.orangeAccent,
    ),
    child: Text('Change'),
    onPressed: state == MQTTAppConnectionState.disconnected
        ? () {
            callback();
          }
        : null, //
  );
}

Widget buildSendButtonFrom(MQTTAppConnectionState state, _nameTextController,
    _messageTextController, manager) {
  void _publishMessage(String text) {
    final String message = (_nameTextController.text.isNotEmpty
            ? _nameTextController.text
            : 'akram') +
        ' : ' +
        text;
    manager.publish(message);
    _messageTextController.clear();
  }

  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: Colors.green,
    ),
    child: const Text('Send'),
    onPressed: state == MQTTAppConnectionState.connected
        ? () {
            _publishMessage(_messageTextController.text);
          }
        : null, //
  );
}

Widget buildConnecteButtonFrom(
    MQTTAppConnectionState state,
    isChangeable,
    _hostTextController,
    _topicTextController,
    _nameTextController,
    currentAppState,
    _configureAndConnect,
    _disconnect) {
  return Row(
    children: <Widget>[
      Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          ),
          child: const Text('Connect'),
          onPressed: state == MQTTAppConnectionState.disconnected
              ? _configureAndConnect
              : null, //
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.redAccent,
          ),
          child: const Text('Disconnect'),
          onPressed:
              state == MQTTAppConnectionState.connected ? _disconnect : null, //
        ),
      ),
    ],
  );
}
