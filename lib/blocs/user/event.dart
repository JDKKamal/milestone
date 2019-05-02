import 'package:milestone/models/user.dart';

abstract class UserEvent {}

class UpdateState extends UserEvent {
  final String key;
  final dynamic value;

  UpdateState({this.key, this.value});
}

class GetAuthUser extends UserEvent {}

class UpdateProfile extends UserEvent {
  final Function callback;

  UpdateProfile({this.callback});
}

class SetAuthUser extends UserEvent {
  final User user;

  SetAuthUser({this.user});
}

class SetAuthToken extends UserEvent {
  final String token;

  SetAuthToken({this.token});
}

class RemoveAuth extends UserEvent {}
