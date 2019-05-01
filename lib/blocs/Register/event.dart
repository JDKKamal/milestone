abstract class RegisterEvent {}

class ChangeMobile extends RegisterEvent {
  final String mobile;

  ChangeMobile({this.mobile});
}

class SetUid extends RegisterEvent {
  final String uid;

  SetUid({this.uid});
}

class RegisterDevice extends RegisterEvent {
  Function callback;

  RegisterDevice({this.callback});
}
