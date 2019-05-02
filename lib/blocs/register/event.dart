abstract class RegisterEvent {}

class ChangeMobile extends RegisterEvent {
  final String mobile;

  ChangeMobile({this.mobile});
}

class ChangePassword extends RegisterEvent {
  final String password;

  ChangePassword({this.password});
}

class SetUid extends RegisterEvent {
  final String uid;

  SetUid({this.uid});
}

class RegisterDevice extends RegisterEvent {
  Function callback;

  RegisterDevice({this.callback});
}
