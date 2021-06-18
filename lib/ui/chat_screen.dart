import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiftr_app/mqtt/mqtt_helper.dart';
import 'package:shiftr_app/providers/message_provider.dart';

class MQTTView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MQTTViewState();
  }
}

class _MQTTViewState extends State<MQTTView> {
  final TextEditingController _hostTextController = TextEditingController();
  final TextEditingController _messageTextController = TextEditingController();
  final TextEditingController _topicTextController = TextEditingController();
  MessageProvider currentAppState;
  MQTTManager manager;
  bool isChangeable = false;

  void _configureAndConnect() {
    String osPrefix = 'Flutter_iOS';
    if (Platform.isAndroid) {
      osPrefix = 'Flutter_Android';
    }
    manager = MQTTManager(
        host: _hostTextController.text,
        topic: _topicTextController.text,
        identifier: osPrefix,
        state: currentAppState);
    manager.initializeMQTTClient();
    manager.connect();
  }

  void _disconnect() {
    manager.disconnect();
  }

  void _publishMessage(String text) {
    String osPrefix = 'Flutter_iOS';
    if (Platform.isAndroid) {
      osPrefix = 'Flutter_Android';
    }
    final String message = osPrefix + ' : ' + text;
    manager.publish(message);
    _messageTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final MessageProvider appState = Provider.of<MessageProvider>(context);
    currentAppState = appState;
    final Scaffold scaffold = Scaffold(
      appBar: AppBar(
        title: Text('Shiftr Chat App'),
        backgroundColor: Colors.green[600],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildConnectionStateText(currentAppState.getAppConnectionState),
            _buildEditableColumn(),
            _buildScrollableTextWith(currentAppState.getHistoryText)
          ],
        ),
      ),
    );
    return scaffold;
  }

  Widget _buildEditableColumn() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _buildTextFieldWith(
              _hostTextController,
              'Enter broker address',
              currentAppState.getAppConnectionState,
              'navybee456.cloud.shiftr.io',
              isMessage: false),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildTextFieldWith(
                    _topicTextController,
                    'Enter any topic to talk about',
                    currentAppState.getAppConnectionState,
                    'akram',
                    isMessage: false),
              ),
              Expanded(child: _buildChangeButton('Change'))
            ],
          ),
          const SizedBox(height: 10),
          _buildPublishMessageRow(),
          const SizedBox(height: 10),
          _buildConnecteButtonFrom(currentAppState.getAppConnectionState)
        ],
      ),
    );
  }

  Widget _buildPublishMessageRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: _buildTextFieldWith(_messageTextController, 'Enter a message',
              currentAppState.getAppConnectionState, '',
              isMessage: true),
        ),
        Expanded(
            child: _buildSendButtonFrom(currentAppState.getAppConnectionState))
      ],
    );
  }

  Widget _buildConnectionStateText(MQTTAppConnectionState state) {
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

  Widget _buildTextFieldWith(TextEditingController controller, String hintText,
      MQTTAppConnectionState state, String labelText,
      {bool isMessage}) {
    bool shouldEnable = false;
    if (controller == _messageTextController &&
        state == MQTTAppConnectionState.connected) {
      shouldEnable = true;
    } else if ((controller == _hostTextController &&
            state == MQTTAppConnectionState.disconnected) ||
        (controller == _topicTextController &&
            state == MQTTAppConnectionState.disconnected)) {
      shouldEnable = true;
    }
    return TextField(
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
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 20.0),
          hintText: labelText != null ? labelText : null),
    );
  }

  Widget _buildScrollableTextWith(String text) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: 400,
        height: 200,
        child: SingleChildScrollView(
          child: Text(text),
        ),
      ),
    );
  }

  Widget _buildConnecteButtonFrom(MQTTAppConnectionState state) {
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
            onPressed: state == MQTTAppConnectionState.connected
                ? _disconnect
                : null, //
          ),
        ),
      ],
    );
  }

  Widget _buildSendButtonFrom(MQTTAppConnectionState state) {
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

  Widget _buildChangeButton(String title) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.orangeAccent,
      ),
      child: Text(title),
      onPressed: () {
        setState(() {
          isChangeable = true;
        });
      }, //
    );
  }
}
