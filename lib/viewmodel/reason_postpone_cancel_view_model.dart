import 'package:milestone/models/reason.dart';

class ReasonPostPoneCancelViewModel {
  List<Reason> reasonUndeliveredItems;

  ReasonPostPoneCancelViewModel({this.reasonUndeliveredItems});

  getReasonPostPoneCancel() =>
      <Reason>[
        Reason(
          id: 1,
          description: 'ADDRESS CHANGED',
        ),
        Reason(
          id: 2,
          description: 'BACKUP PENDING',
        )
      ];
}
