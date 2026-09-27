import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:immoplus/app/data/models/remote/polls/poll_detail_response.dart';

part 'poll_provider.g.dart';

@RestApi()
abstract class PollProvider {
  factory PollProvider(Dio dio, {String baseUrl}) = _PollProvider;

  @GET('/polls/{pollId}')
  Future<PollDetailResponse> getPoll(
    @Path('pollId') String pollId, {
    @Query('device_id') String? deviceId,
  });

  @POST('/polls/{pollId}/vote')
  Future<HttpResponse> vote(
    @Path('pollId') String pollId,
    @Body() Map<String, dynamic> body,
  );

  /// Reclic sur une autre option qu'un vote déjà existant — remplace le
  /// vote. `400` si pas de vote existant à changer.
  @PATCH('/polls/{pollId}/vote')
  Future<HttpResponse> changeVote(
    @Path('pollId') String pollId,
    @Body() Map<String, dynamic> body,
  );

  /// Reclic sur l'option déjà votée — annule le vote, le sondage redevient
  /// votable. `404` si pas de vote existant à annuler.
  @DELETE('/polls/{pollId}/vote')
  Future<HttpResponse> cancelVote(
    @Path('pollId') String pollId, {
    @Query('device_id') String? deviceId,
  });
}
