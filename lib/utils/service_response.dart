class ServiceResponse<T> {
  final T? data;
  final String? error;

  ServiceResponse({this.data, this.error});

  bool get isSuccess => error == null;

  bool get isError => !isSuccess;
}
