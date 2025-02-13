// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:flutter/widgets.dart';

base class Fold<T, E extends Exception> {
  static Idle idle = Idle();
  static Loading loading = Loading();

  static Value<T> value<T>(T result) => Value(result);
  static Error<E> error<E extends Exception>(E result) => Error(result);

  FutureOr<T?> fold({
    void Function(T result)? onSuccess,
    void Function(E error)? onError,
    void Function()? onIdle,
    void Function()? onLoading,
  }) {
    if (this is Idle) {
      onIdle?.call();
      return null;
    } else if (this is Loading) {
      onLoading?.call();
      return null;
    } else if (this is Value) {
      onSuccess?.call((this as Value<T>).result);
      return null;
    } else if (this is Error<E>) {
      onError?.call((this as Error<E>).result);
      return null;
    }
    throw Exception('None of the values matched');
  }

  Widget foldWidget({
    Widget Function(T result)? onSuccess,
    Widget Function(E error)? onError,
    Widget Function()? onIdle,
    Widget Function()? onLoading,
    required Widget placeholder,
  }) {
    Widget? widget;
    if (this is Idle) {
      widget = onIdle?.call();
    } else if (this is Loading) {
      widget = onLoading?.call();
    } else if (this is Value) {
      widget = onSuccess?.call((this as Value<T>).result);
    } else if (this is Error) {
      widget = onError?.call((this as Error<E>).result);
    }
    if (widget == null) {
      return placeholder;
    } else {
      return widget;
    }
  }
}

final class Value<T> extends Fold {
  final T result;

  Value(this.result);

  Value.named({required this.result});
}

final class Error<E extends Exception> extends Fold<void, E> {
  final E result;

  Error(this.result);

  Error.named({required this.result});
}

final class Loading extends Fold {}

final class Idle extends Fold {}