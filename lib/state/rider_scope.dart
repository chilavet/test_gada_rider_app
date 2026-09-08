import 'package:flutter/material.dart';
import 'rider_state.dart';

class RiderScope extends InheritedNotifier<RiderState> {
  const RiderScope({
    super.key,
    required RiderState state,
    required super.child,
  }) : super(notifier: state);

  static RiderState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<RiderScope>();
    assert(scope != null, 'No RiderScope found in context');
    return scope!.notifier!;
  }
}
