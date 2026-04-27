import 'package:dio/dio.dart';
import 'package:immoplus/app/data/models/remote/user_preference/user_preference.dart';
import 'package:immoplus/app/data/models/remote/user_preference/user_preference_options.dart';
import 'package:retrofit/retrofit.dart';

part 'user_preference_provider.g.dart';

@RestApi()
abstract class UserPreferenceProvider {
  factory UserPreferenceProvider(Dio dio, {String baseUrl}) =
      _UserPreferenceProvider;

  @GET('/user-preferences/options')
  Future<UserPreferenceOptionsResponse> getOptions();

  @GET('/user-preferences/me')
  Future<UserPreferenceResponse> getMyPreferences();

  @PUT('/user-preferences/me')
  Future<UserPreferenceResponse> updateMyPreferences(
    @Body() UserPreferenceRequest request,
  );
}
