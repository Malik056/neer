import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neer/globals/constants.dart';
import 'package:neer/models/serviceProviderModel.dart';

class ServiceProvidersBloc
    extends Bloc<QuerySnapshot, List<ServiceProviderModel>> {
  ServiceProvidersBloc() : super([]) {
    Firestore.instance.collection('providers').snapshots().listen((event) {
      add(event);
    });
  }

  @override
  Stream<List<ServiceProviderModel>> mapEventToState(
      QuerySnapshot event) async* {
    List<ServiceProviderModel> models = [];
    event.documents.forEach(
      (element) {
        ServiceProviderModel providerModel =
            ServiceProviderModel.fromMap(element.data);
        providerModel.id = element.documentID;
        models.add(providerModel);
      },
    );
    serviceProviders = models;
    yield models;
  }
}
