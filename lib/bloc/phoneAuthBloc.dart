import 'package:bloc/bloc.dart';

enum PhoneAuthState {
  authenticated,
  codeSent,
  authenticationFailed,
  expired,
  idle
}

class PhoneAuthBloc extends Bloc<PhoneAuthState, PhoneAuthState> {
  PhoneAuthBloc() : super(PhoneAuthState.idle);

  @override
  Stream<PhoneAuthState> mapEventToState(PhoneAuthState event) async* {
    yield event;
  }
}
