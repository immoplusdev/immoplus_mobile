import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immoplus/app/data/models/remote/suggest/suggestion_model.dart';
import 'package:immoplus/app/data/repositories/suggest_repository.dart';
import 'package:immoplus/app/features/suggest/logic/suggest_cubit.dart';
import 'package:immoplus/app/features/suggest/logic/suggest_state.dart';

void main() {
  group('Global Suggestions (GET /suggest)', () {
    test('envoie la requête GET /suggest?q=... avec lat/lng sans category',
        () async {
      final recordedRequest = <String, dynamic>{};
      final dio = _dioRecording(recordedRequest);
      final repository = SuggestRepository(dio);

      final response = await repository.getSuggestions(
        query: 'cocody',
        lat: 5.35,
        lng: -4.01,
      );

      expect(recordedRequest['path'], '/suggest');
      expect(recordedRequest['query']['q'], 'cocody');
      expect(recordedRequest['query']['lat'], 5.35);
      expect(recordedRequest['query']['lng'], -4.01);
      expect(recordedRequest['query'].containsKey('category'), isFalse,
          reason: 'category ne doit pas être envoyé dans la requête');

      expect(response.suggestions, hasLength(2));
      expect(response.suggestions[0].type, SuggestionType.residence);
      expect(response.suggestions[1].type, SuggestionType.bien);
    });

    test('SuggestCubit fetches suggestions without category', () async {
      final recordedRequest = <String, dynamic>{};
      final dio = _dioRecording(recordedRequest);
      final repository = SuggestRepository(dio);
      final cubit = SuggestCubit(repository);

      expect(cubit.state, const SuggestState.initial());

      final states = <SuggestState>[];
      cubit.stream.listen(states.add);

      await cubit.fetchSuggestions(
        query: 'abidjan',
        lat: 5.35,
        lng: -4.01,
      );
      await pumpEventQueue();

      expect(recordedRequest['query']['q'], 'abidjan');
      expect(recordedRequest['query'].containsKey('category'), isFalse);
      expect(states, hasLength(2));
      expect(states[0], const SuggestState.loading());
      states[1].maybeWhen(
        success: (suggestions) {
          expect(suggestions, hasLength(2));
        },
        orElse: () => fail('Expected success state'),
      );
    });
  });
}

Dio _dioRecording(Map<String, dynamic> request) {
  return Dio()
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          request['path'] = options.path;
          request['query'] = Map<String, dynamic>.from(options.queryParameters);
          handler.resolve(
            Response<Map<String, dynamic>>(
              requestOptions: options,
              statusCode: 200,
              data: const {
                'query': 'test',
                'suggestions': [
                  {
                    'id': 'res-1',
                    'type': 'residence',
                    'label': 'Résidence Belle Vue',
                  },
                  {
                    'id': 'bien-1',
                    'type': 'bien',
                    'label': 'Villa Cocody',
                  },
                ],
              },
            ),
          );
        },
      ),
    );
}
