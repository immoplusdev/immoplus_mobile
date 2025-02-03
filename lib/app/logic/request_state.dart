import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/models/remote/configs/commune_model.dart';
import 'package:immoplus/app/data/models/remote/configs/ville_model.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';

part 'request_state.freezed.dart';
part 'request_state.g.dart';

@freezed
class RequestState with _$RequestState {
  factory RequestState() = _RequestState;
  const factory RequestState.initial() = REQUEST_INITIAL;
  const factory RequestState.loading() = REQUEST_LOADING;
  const factory RequestState.success() = REQUEST_SUCCESS;
  const factory RequestState.error({required String error}) = REQUEST_ERROR;
  const factory RequestState.residence({required ResidenceModel data}) =
      REQUEST_RESIDENCE_DATA;
  const factory RequestState.bienImmobilier(
      {required BienImmobilierModel data}) = REQUEST_BIEN_IMMOBILIER_DATA;
  const factory RequestState.residences({required List<ResidenceModel> data}) =
      REQUEST_RESIDENCES_DATA;
  const factory RequestState.villes({required List<VilleModel> data}) =
      REQUEST_VILLES_DATA;

  const factory RequestState.communes({required List<CommuneModel> data}) =
      REQUEST_COMMUNES_DATA;

  factory RequestState.fromJson(Map<String, dynamic> json) =>
      _$RequestStateFromJson(json);
}
