import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shiftr_app/providers/message_provider.dart';

class MQTTManager {
  final MessageProvider _currentState;
  MqttServerClient _client;
  final String _identifier;
  final String _host;
  final String _topic;

  MQTTManager(
      {@required String host,
      @required String topic,
      @required String identifier,
      @required MessageProvider state})
      : _identifier = identifier,
        _host = host,
        _topic = topic,
        _currentState = state;

  void initializeMQTTClient() {
    _client = MqttServerClient(
        _host.isNotEmpty ? _host : 'navybee456.cloud.shiftr.io', _identifier);
    _client.port = 1883;
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = onDisconnected;
    _client.secure = false;
    _client.logging(on: true);

    _client.onConnected = onConnected;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .withWillTopic(_topic.isNotEmpty
            ? _topic
            : 'akram') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('Mosquitto client connecting....');
    _client.connectionMessage = connMess;
  }

  void connect() async {
    assert(_client != null);
    try {
      print('Mosquitto start client connecting....');
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      await _client.connect('navybee456', 'amk00000');
    } on Exception catch (e) {
      print('Exception : $e');
      disconnect();
    }
  }

  void disconnect() {
    print('Disconnected');
    _client.disconnect();
  }

  void publish(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(_topic.isNotEmpty ? _topic : 'akram',
        MqttQos.exactlyOnce, builder.payload);
  }

  // _client.onSubscribed = onSubscribed;
  // void onSubscribed(String topic) {
  //   print('EXAMPLE::Subscription confirmed for topic $topic');
  // }

  void onDisconnected() {
    print('Client disconnection');
    if (_client.connectionStatus.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      print('OnDisconnected callback is solicited');
    }
    _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
  }

  void onConnected() {
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
    print('Mosquitto client connected....');
    _client.subscribe(
        _topic.isNotEmpty ? _topic : 'akram', MqttQos.atLeastOnce);
    _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      _currentState.setReceivedText(pt);
      print('Topic is <${c[0].topic}>, payload is <-- $pt -->');
    });
    print('Client connection was Successful');
  }
}
