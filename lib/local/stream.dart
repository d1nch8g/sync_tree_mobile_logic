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

createTriggerSubscription({
  required Trigger trigger,
  required Function onTriggerEvent,
}) {
  mainStream.listen((event) {
    if (trigger == event) {
      onTriggerEvent();
    }
  });
}
