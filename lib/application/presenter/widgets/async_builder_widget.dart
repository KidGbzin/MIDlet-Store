import 'package:flutter/material.dart';
import 'package:midlet_store/application/presenter/widgets/loading_widget.dart';

import '../../../logger.dart';

/// A reusable widget that simplifies the use of [FutureBuilder] by handling loading, success, error, and empty states.
///
/// [AsyncBuilder] is a thin wrapper around [FutureBuilder], and it uses its features to provide a simpler API.
/// It is designed to be used as a drop-in replacement for [FutureBuilder] when you need to handle multiple states.
class AsyncBuilder<T> extends StatelessWidget {

  /// The asynchronous operation to be executed.
  final Future<T> future;

  /// Called when the future completes successfully with data.
  final Widget Function(BuildContext context, T data) onSuccess;

  /// Widget to display if an error occurs during the future.
  final Widget? onError;

  /// Widget to display while the future is loading.
  final Widget? onLoading;

  /// Widget to display if the future completes with no data.
  final Widget? onEmpty;

  const AsyncBuilder({
    super.key,
    required this.future,
    required this.onSuccess,
    this.onError,
    this.onLoading,
    this.onEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return onEmpty ?? const Placeholder();

          case ConnectionState.waiting:
            return onLoading ?? const Center(
              child: LoadingAnimation(),
            );

          case ConnectionState.done:
            if (snapshot.hasError) {
              Logger.error(
                snapshot.error.toString(),
                stackTrace: snapshot.stackTrace,
              );

              return onError ?? const Placeholder();
            }
            else if (snapshot.hasData) {
              return onSuccess(context, snapshot.data as T);
            }
            else {
              return onEmpty ?? const Placeholder();
            }

          default:
            return onEmpty ?? const Placeholder();
        }
      },
    );
  }
}