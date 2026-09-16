import 'package:dio/dio.dart' hide Headers;
import 'package:immoplus/app/data/models/remote/relais/relais_cancel_response.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_interest_action_responses.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_interest_requests.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_interests_response.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_list_response.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_matches_response.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_my_interests_response.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_received_interests_response.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_request.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_response.dart';
import 'package:retrofit/retrofit.dart';

part 'relais_provider.g.dart';

@RestApi()
abstract class RelaisProvider {
  factory RelaisProvider(Dio dio, {String baseUrl}) = _RelaisProvider;

  @POST('/relais')
  Future<RelaisResponse> createRelais(@Body() RelaisRequest request);

  @GET('/relais')
  Future<RelaisListResponse> getRelais({
    @Query('status') String? status,
    @Query('page') int page = 1,
    @Query('limit') int limit = 10,
    @Query('sortBy') String sortBy = 'recent',
  });

  @GET('/relais/{id}')
  Future<RelaisResponse> getRelaisById(@Path('id') String id);

  /// Body déjà réduit aux champs non-null par `RelaisRepository.updateRelais()`
  /// (voir `RelaisUpdateRequest` — un champ absent du JSON ne doit pas
  /// écraser la valeur déjà en base).
  @PATCH('/relais/{id}')
  Future<RelaisResponse> updateRelais(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/relais/{id}')
  Future<RelaisCancelResponse> cancelRelais(@Path('id') String id);

  /// Alertes (demandeurs) qui correspondent à ce relais.
  @GET('/relais/{id}/matches')
  Future<RelaisMatchesResponse> getRelaisMatches(@Path('id') String id);

  /// Demandeurs ayant exprimé un intérêt pour ce relais.
  @GET('/relais/{id}/interests')
  Future<RelaisInterestsResponse> getRelaisInterests(@Path('id') String id);

  /// Réponse de l'occupant à un intéressé.
  @PATCH('/relais/{id}/interests/{interestId}')
  Future<RelaisRespondInterestResponse> respondToInterest(
    @Path('id') String id,
    @Path('interestId') String interestId,
    @Body() RelaisInterestResponseRequest request,
  );

  /// Exprimer un intérêt pour le relais d'un autre (côté demandeur).
  @POST('/relais/{id}/interests')
  Future<RelaisExpressInterestResponse> expressInterest(
    @Path('id') String id,
    @Body() RelaisExpressInterestRequest request,
  );

  /// Découverte des relais des autres (jamais les miens), actifs
  /// uniquement, identité anonymisée — même endpoint que `getRelais`,
  /// `scope=marketplace` bascule le comportement côté serveur.
  @GET('/relais')
  Future<RelaisListResponse> getRelaisMarketplace({
    @Query('scope') String scope = 'marketplace',
    @Query('location') String? location,
    @Query('propertyType') String? propertyType,
    @Query('roomsMin') int? roomsMin,
    @Query('roomsMax') int? roomsMax,
    @Query('priceMin') int? priceMin,
    @Query('priceMax') int? priceMax,
    @Query('page') int page = 1,
    @Query('limit') int limit = 10,
    @Query('sortBy') String sortBy = 'recent',
  });

  /// Relais sur lesquels j'ai exprimé un intérêt (côté demandeur).
  @GET('/relais/interests/mine')
  Future<MyRelaisInterestsResponse> getMyRelaisInterests({
    @Query('status') String? status,
    @Query('page') int page = 1,
    @Query('limit') int limit = 10,
  });

  /// Intérêts reçus, agrégés sur tous mes relais (côté occupant).
  @GET('/relais/interests/received')
  Future<ReceivedRelaisInterestsResponse> getReceivedRelaisInterests({
    @Query('status') String? status,
    @Query('page') int page = 1,
    @Query('limit') int limit = 10,
  });
}
