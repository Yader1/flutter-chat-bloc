import 'package:pusher_client/pusher_client.dart';
import 'package:laravel_echo/laravel_echo.dart';

class LaravelEcho {
  static LaravelEcho? _singleton;
  static late Echo _echo;
  final String token;

  LaravelEcho._({
    required this.token,
  }) {
    _echo = createLaravelEcho(token);
  }

  factory LaravelEcho.init({
    required String token,
  }) {
    if (_singleton == null || token != _singleton?.token) {
      _singleton = LaravelEcho._(token: token);
    }

    return _singleton!;
  }

  static Echo get instance => _echo;

  static String get socketId => _echo.socketId() ?? "11111.11111111";
}

class PusherConfig{
  static const appId = "1662450";
  static const key = "700ccaa89f4b4e0fad68";
  static const secret = "a3aae686944d04f6c29e"; 
  static const cluster = "us2";
  static const hostEndPoint = "https://8c74-186-1-41-41.ngrok-free.app";
  static const hostAuthEndPoint = "$hostEndPoint/api/broadcasting/auth";
  static const port = 6001;
}

PusherClient createPusherClient(String token){
  PusherOptions options = PusherOptions(
    wsPort: PusherConfig.port,
    encrypted: true,
    host: PusherConfig.hostEndPoint,
    cluster: PusherConfig.cluster,
    auth: PusherAuth(
      PusherConfig.hostAuthEndPoint,
      headers: {
        'Authorization': "Bearer $token",
        'Content-Type': "application/json",
        'Accept': 'application/json'
      }
    )
  );

  PusherClient pusherClient = PusherClient(
    PusherConfig.key,
    options,
    autoConnect: false,
    enableLogging: true,
  );

  return pusherClient;
}

Echo createLaravelEcho(String token) {
  return Echo(
    client: createPusherClient(token),
    broadcaster: EchoBroadcasterType.Pusher,
  );
}