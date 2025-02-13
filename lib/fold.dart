// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/widgets.dart';
// import 'package:flutter/widgets.dart';

enum _FoldState {
  idle,
  loading,
  value,
  error,
}

base class Fold<T, E extends Exception?> {
  final _FoldState _state;
  const Fold(this._state);

  static Fold idle = FoldIdle();
  static Fold loading = FoldLoading();

  static Fold<T, void> value<T>(T result) => FoldValue(result);
  static Fold<void, E> error<E extends Exception>(E result) => FoldError(result);

  FutureOr<void> fold({
    void Function(T result)? onSuccess,
    void Function(E error)? onError,
    void Function()? onIdle,
    void Function()? onLoading,
  }) {
    switch (_state) {
      case _FoldState.idle:
        onIdle?.call();
        return null;
      case _FoldState.loading:
        onLoading?.call();
        return null;
      case _FoldState.value:
        onSuccess?.call((this as FoldValue<T, void>).result);
        return null;
      case _FoldState.error:
        onError?.call((this as FoldError<void, E>).result);
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
      case _FoldState.idle:
        widget = onIdle?.call();
      case _FoldState.loading:
        widget = onLoading?.call();
      case _FoldState.value:
        widget = onSuccess?.call((this as FoldValue<T, void>).result);
      case _FoldState.error:
        widget = onError?.call((this as FoldError<void, E>).result);
    }

    if (widget == null) {
      return placeholder;
    } else {
      return widget;
    }
  }
}

final class FoldValue<T, E extends Exception?> extends Fold<T, E> {
  final T result;

  FoldValue(this.result) : super(_FoldState.value);

  FoldValue.named({required this.result}) : super(_FoldState.value);
}

final class FoldError<T, E extends Exception?> extends Fold<T, E> {
  final E result;

  FoldError(this.result) : super(_FoldState.error);

  FoldError.named({required this.result}) : super(_FoldState.error);
}

final class FoldLoading<T, E extends Exception?> extends Fold<T, E> {
  FoldLoading() : super(_FoldState.loading);
}

final class FoldIdle<T, E extends Exception?> extends Fold<T, E> {
  FoldIdle() : super(_FoldState.idle);
}