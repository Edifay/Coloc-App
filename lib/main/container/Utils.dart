import 'package:flutter/material.dart';

class SimplifiedFuture<T> {
  SimplifiedFuture();

  Widget build(Future<T> future, Widget Function(BuildContext context, AsyncSnapshot<T> snapshot) func) {
    return FutureBuilder<T>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return func(context, snapshot);
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text("${snapshot.error}");
          }
          return const CircularProgressIndicator();
        });
  }
}
