// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/widgets.dart';
// import 'package:flutter/widgets.dart';

enum FoldState {
  idle,
  loading,
  value,
  error,
}

base class Fold<T, E extends Exception?> {
  final FoldState _state;
  const Fold(this._state);

  static Fold idle = Idle();
  static Fold loading = Loading();

  static Fold<T, void> value<T>(T result) => Value(result);
  static Fold<void, E> error<E extends Exception>(E result) => Error(result);

  FutureOr<void> fold({
    void Function(T result)? onSuccess,
    void Function(E error)? onError,
    void Function()? onIdle,
    void Function()? onLoading,
  }) {
    switch (_state) {
      case FoldState.idle:
        onIdle?.call();
        return null;
      case FoldState.loading:
        onLoading?.call();
        return null;
      case FoldState.value:
        onSuccess?.call((this as Value<T, void>).result);
        return null;
      case FoldState.error:
        onError?.call((this as Error<void, E>).result);
        return null;
    }
  }

  Widget foldWidget({
    Widget Function(T result)? onSuccess,
    Widget Function(E error)? onError,
    Widget Function()? onIdle,
    Widget Function()? onLoading,
    required Widget placeholder,
  }) {
    Widget? widget;
    switch (_state) {
      case FoldState.idle:
        widget = onIdle?.call();
      case FoldState.loading:
        widget = onLoading?.call();
      case FoldState.value:
        widget = onSuccess?.call((this as Value<T, void>).result);
      case FoldState.error:
        widget = onError?.call((this as Error<void, E>).result);
    }

    if (widget == null) {
      return placeholder;
    } else {
      return widget;
    }
  }
}

final class Value<T, E extends Exception?> extends Fold<T, E> {
  final T result;

  Value(this.result) : super(FoldState.value);

  Value.named({required this.result}) : super(FoldState.value);
}

final class Error<T, E extends Exception?> extends Fold<T, E> {
  final E result;

  Error(this.result) : super(FoldState.error);

  Error.named({required this.result}) : super(FoldState.error);
}

final class Loading<T, E extends Exception?> extends Fold<T, E> {
  Loading() : super(FoldState.loading);
}

final class Idle<T, E extends Exception?> extends Fold<T, E> {
  Idle() : super(FoldState.idle);
}