import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

class ConnectivityBloc extends Bloc<ConnectivityResult, ConnectivityResult> {
  ConnectivityBloc(ConnectivityResult initialState) : super(initialState) {
    Connectivity().onConnectivityChanged.listen((event) {
      add(event);
    });
  }

  @override
  Stream<ConnectivityResult> mapEventToState(ConnectivityResult event) async* {
    if (event != ConnectivityResult.none) {
      try {
        final result = await http.get('http://example.com/');
        if (result.statusCode != 200) {
          yield ConnectivityResult.none;
        } else {
          yield event;
        }
      } catch (ex) {
        print(ex);
        yield ConnectivityResult.none;
      }
    } else {
      yield event;
    }
  }
}
