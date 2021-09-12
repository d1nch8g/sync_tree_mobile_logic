import 'dart:async';

var mainStreamController = StreamController<Trigger>.broadcast();
var mainStream = mainStreamController.stream;

enum Trigger {
  publicNameUpdate,
  mainBalanceUpdate,
  marketBalanceUpdate,
  marketMessagesUpdate,
}

void triggerEvent({
  required Trigger trigger,
}) {
  mainStreamController.add(trigger);
}

Function triggerCreateListener({
  required Trigger trigger,
  required Function onEventAction,
}) {
  return () {
    mainStream.listen((event) {
      if (trigger == event) {
        onEventAction();
      }
    });
  };
}
