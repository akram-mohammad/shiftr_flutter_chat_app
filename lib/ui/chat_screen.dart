import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiftr_app/mqtt/mqtt_helper.dart';
import 'package:shiftr_app/providers/message_provider.dart';
import 'package:shiftr_app/ui/widgets/editing_column_widget.dart';
import 'package:shiftr_app/ui/widgets/text_fields_widget.dart';

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
  final TextEditingController _nameTextController = TextEditingController();
  MessageProvider currentAppState;
  bool isChangeable = false;
  MQTTManager manager;

  void _configureAndConnect() {
    isChangeable = false;
    manager = MQTTManager(
        host: _hostTextController.text,
        topic: _topicTextController.text,
        identifier: _nameTextController.text,
        state: currentAppState);
    manager.initializeMQTTClient();
    manager.connect();
  }

  void _disconnect() {
    isChangeable = false;
    manager.disconnect();
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
            buildConnectionStateText(currentAppState.getAppConnectionState),
            buildEditableColumn(isChangeable, () {
              setState(() {
                isChangeable = true;
              });
            },
                currentAppState,
                _hostTextController,
                _messageTextController,
                _topicTextController,
                _nameTextController,
                manager,
                _configureAndConnect,
                _disconnect),
            buildScrollableTextWith(currentAppState.getHistoryText)
          ],
        ),
      ),
    );
    return scaffold;
  }
}
