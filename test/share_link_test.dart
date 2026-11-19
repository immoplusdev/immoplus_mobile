import 'package:flutter_test/flutter_test.dart';
import 'package:immoplus/app/data/models/remote/share_link/share_link_open_model.dart';
import 'package:immoplus/app/data/repositories/share_link_repository.dart';

void main() {
  group('ShareLinkRepository.tokenFromPath', () {
    test('extrait le token après /rt', () {
      expect(
        ShareLinkRepository.tokenFromPath(
            '/rtM-dHaaAEQO4iuX3uXkH2x75bPj2h16wJ'),
        'M-dHaaAEQO4iuX3uXkH2x75bPj2h16wJ',
      );
      expect(ShareLinkRepository.tokenFromPath('/rtabc/'), 'abc');
    });

    test('ignore les autres chemins', () {
      expect(ShareLinkRepository.tokenFromPath('/rt'), isNull);
      expect(ShareLinkRepository.tokenFromPath('/residence_detail/1'), isNull);
      expect(ShareLinkRepository.tokenFromPath('/rtabc/def'), isNull);
      expect(ShareLinkRepository.tokenFromPath('/'), isNull);
    });
  });

  group('ShareLinkOpenModel', () {
    test('lit l\'enveloppe data', () {
      final model = ShareLinkOpenModel.fromJson({
        'data': {
          'residenceId': 'r1',
          'sessionId': 's1',
          'redirectUrl': 'https://app.immoplus.ci/residence_detail/r1',
        },
      });
      expect(model.residenceId, 'r1');
      expect(model.sessionId, 's1');
    });

    test('tolère les champs absents', () {
      final model = ShareLinkOpenModel.fromJson({});
      expect(model.residenceId, '');
      expect(model.sessionId, isNull);
    });
  });
}
