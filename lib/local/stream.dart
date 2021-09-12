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

Function createTriggerListener({
  required Trigger trigger,
  required Function onTriggerEvent,
}) {
  return () {
    mainStream.listen((event) {
      if (trigger == event) {
        onTriggerEvent();
      }
    });
  };
}
