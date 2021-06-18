import 'package:flutter/material.dart';
import 'package:shiftr_app/ui/widgets/buttons_widget.dart';
import 'package:shiftr_app/ui/widgets/text_fields_widget.dart';

Widget buildEditableColumn(
    isChangeable,
    Function callback,
    currentAppState,
    _hostTextController,
    _messageTextController,
    _topicTextController,
    _nameTextController,
    manager,
    _configureAndConnect,
    _disconnect) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      children: <Widget>[
        buildTextFieldWith(
            _hostTextController,
            'Enter Broker Address',
            currentAppState.getAppConnectionState,
            'navybee456.cloud.shiftr.io',
            _messageTextController,
            _hostTextController,
            _topicTextController,
            _nameTextController,
            isChangeable,
            isMessage: false),
        const SizedBox(height: 10),
        buildTextFieldWith(
            _topicTextController,
            'Enter any topic to talk about',
            currentAppState.getAppConnectionState,
            'world',
            _messageTextController,
            _hostTextController,
            _topicTextController,
            _nameTextController,
            isChangeable,
            isMessage: false),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: buildTextFieldWith(
                  _nameTextController,
                  'Enter Your Name',
                  currentAppState.getAppConnectionState,
                  'akram',
                  _messageTextController,
                  _hostTextController,
                  _topicTextController,
                  _nameTextController,
                  isChangeable,
                  isMessage: false),
            ),
            Expanded(
              child:
                  buildChangeButton(currentAppState.getAppConnectionState, () {
                callback();
              }),
            ),
          ],
        ),
        const SizedBox(height: 10),
        buildPublishMessageRow(
            currentAppState,
            _messageTextController,
            _hostTextController,
            _topicTextController,
            _nameTextController,
            isChangeable,
            manager),
        const SizedBox(height: 10),
        buildConnecteButtonFrom(
            currentAppState.getAppConnectionState,
            isChangeable,
            _hostTextController,
            _topicTextController,
            _nameTextController,
            currentAppState,
            _configureAndConnect,
            _disconnect)
      ],
    ),
  );
}

Widget buildPublishMessageRow(
    currentAppState,
    _messageTextController,
    _hostTextController,
    _topicTextController,
    _nameTextController,
    isChangeable,
    manager) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      Expanded(
        flex: 3,
        child: buildTextFieldWith(
            _messageTextController,
            'Enter a message',
            currentAppState.getAppConnectionState,
            '',
            _messageTextController,
            _hostTextController,
            _topicTextController,
            _nameTextController,
            isChangeable,
            isMessage: true),
      ),
      Expanded(
          child: buildSendButtonFrom(currentAppState.getAppConnectionState,
              _nameTextController, _messageTextController, manager))
    ],
  );
}
