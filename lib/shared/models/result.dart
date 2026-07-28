sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isError => this is Error<T>;

  T? get data => switch (this) {
        final Success<T> s => s.data,
        Error<T> _ => null,
      };

  String? get errorMessage => switch (this) {
        Success<T> _ => null,
        final Error<T> e => e.message,
      };

  Result<T> onSuccess(void Function(T data) action) {
    if (this is Success<T>) {
      action((this as Success<T>).data);
    }
    return this;
  }

  Result<T> onError(void Function(String message) action) {
    if (this is Error<T>) {
      action((this as Error<T>).message);
    }
    return this;
  }
}

class Success<T> extends Result<T> {
  @override
  final T data;

  const Success(this.data);

  @override
  String toString() => 'Success($data)';
}

class Error<T> extends Result<T> {
  final String message;
  final int? statusCode;

  const Error(this.message, {this.statusCode});

  @override
  String toString() => 'Error($message)';
}
