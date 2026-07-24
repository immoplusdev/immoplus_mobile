# ci

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Build Runner
`flutter pub run build_runner build --delete-conflicting-outputs`
`flutter pub run build_runner watch --delete-conflicting-outputs`

## Règles de Développement & Bonnes Pratiques
### Routage / Navigation
* **Pas de chemins codés en dur dans les pages :** Évitez d'écrire des chemins bruts directement lors de la navigation (ex. `context.push('/hotels/${hotel.id}/booking?roomId=${room.id}')`).
* **Utilisation de getters de route statiques :** Chaque page (ex. `HotelDetailPage`, `HotelBookingSelectionPage`) doit implémenter une méthode de génération de route statique pour construire ses URLs de manière centralisée :
  ```dart
  static String route(String id) => '/hotels/$id';
  ```
  Et la navigation doit l'utiliser de la sorte : `context.push(HotelDetailPage.route(id))`.

### Composants UI
* **Pas de widgets natifs basiques (comme ElevatedButton, TextField, etc.) si des équivalents personnalisés existent :** Utilisez toujours les widgets réutilisables du projet (ex: `CustomButtom`, `CustomTextField`, `CustomRoundedTextField`, etc.) pour maintenir la cohérence visuelle.

### Performance & Optimisation Réseau (Fluidité et Vitesse)
* **Éviter les appels réseau redondants :** Lors du passage d'une vue parente à une vue enfant (ex. de `HotelDetailPage` à `HotelRoomDetailPage`), passez l'intégralité du modèle de données déjà chargé (ex. `HotelDetailModel`) via l'argument `extra` de GoRouter. Ne rechargez le modèle depuis le réseau qu'en secours (fallback) si le modèle reçu est nul (ex. lors d'un accès par lien profond / deep link). Cela garantit des transitions d'écran instantanées, fluides et économise la bande passante.

### Notifications / Toasts
* **Utilisation systématique de `ToastUtils` :** Évitez d'utiliser `ScaffoldMessenger.of(context).showSnackBar`. Utilisez toujours la classe utilitaire centralisée `ToastUtils` (ex. `ToastUtils.showError(...)`, `ToastUtils.warning(...)`) pour l'affichage des retours visuels à l'utilisateur afin de garantir un style et des animations unifiés.

## To Do (Known Issues)
* **Bug Navigation GoRouter (AuthRedirectService) :** L'utilisation de `context.push` directement à l'intérieur du `callback` de `AuthRedirectService` (comme dans `HotelBookingSelectionPage`) corrompt l'état interne de `GoRouter` après un `popUntil` lors de la connexion. Pour l'instant, le bloc `context.push(HotelBookingSummaryPage.route(...))` a été commenté dans `HotelBookingSelectionPage` en guise de palliatif. **Il faudra trouver une solution propre pour restaurer cette redirection automatique sans casser la pile de navigation de GoRouter (ex: utiliser l'API globale du routeur ou un délai).**

## Outils & Commandes Pratiques

### Simuler un Deep Link (Lien profond)
Pour tester l'ouverture d'un lien profond / lien universel lorsque l'application tourne sur le **simulateur iOS (Xcode)**, utilisez la commande suivante dans le terminal :

```bash
xcrun simctl openurl booted "https://votre-domaine.com/votre-chemin"

xcrun simctl openurl booted "https://app.immoplus.ci/hotels/7e498f07-3b76-445f-93d4-e074c42707da/chambres/22512472-2718-430c-a5f9-7fc0e4eb0f46"

```
*(Remplacez l'URL par le lien exact que vous souhaitez tester).*

### Simuler un clic sur une Notification Push (Simulateur iOS)
Un dossier `notification_tests` a été créé à la racine du projet contenant plusieurs fichiers `.apns` pour simuler des clics sur des notifications push.

**Comment lancer un test :**
1. Lancez l'application sur un **Simulateur iOS**.
2. **Glisser-Déposer :** Prenez l'un des fichiers `.apns` depuis le Finder (par ex: `notification_tests/test_rating.apns`) et glissez-déposez le sur la fenêtre du simulateur.
3. **Ou via Terminal :** 
   ```bash
   xcrun simctl push booted notification_tests/test_rating.apns
   ```
4. Cliquez sur la notification qui apparaît pour déclencher la redirection.

**Tests disponibles :**
- `test_rating.apns` : Ouvre la Bottom Sheet d'évaluation d'un séjour.
- `test_mktg_preferences.apns` : Redirige vers la sélection des préférences (`cliOnb02`).
- `test_mktg_imatch.apns` : Redirige vers la vue des matchs (`cliOnb04`).
- `test_mktg_visit.apns` : Redirige vers l'historique des visites expresses (`cliOnb05`).
- `test_mktg_residence.apns` : Redirige vers la page de suggestion/résidence (`cliNurt01`).
- `test_mktg_alert.apns` : Redirige vers la liste des alertes (`cliNurtAl01`).

## Gestion des Timeouts et des Re-tentatives (Retries)

Pour éviter les erreurs de type `DioError: The request connection took longer than 0:00:10.000000 and it was aborted` (très courantes lors du chargement simultané de multiples sections réseau sur des connexions mobiles instables) :

1. **Timeouts Globaux Augmentés** : Dans [dio_config.dart](file:///Users/kitoko/Documents/applications/immoplus/lib/app/core/network/dio_config.dart), la configuration des paramètres `connectTimeout` et `receiveTimeout` a été élevée de 10 à **30 secondes** pour laisser aux requêtes lentes le temps de s'établir.
2. **RetryInterceptor (Re-tentatives Automatiques)** : Un interceptor personnalisé [RetryInterceptor](file:///Users/kitoko/Documents/applications/immoplus/lib/app/core/network/interceptors/retry_interceptor.dart) a été ajouté au client global Dio. Il intercepte automatiquement les exceptions réseau de type timeout ou erreur de connexion et relance la requête jusqu'à **3 fois** avec un délai de reprise exponentiel (`2s`, `4s`, `6s`).
   - **Sécurité des requêtes non-idempotentes** : L'intercepteur ne réessaie les requêtes `POST`/`PUT`/`DELETE` que si l'erreur survient lors de l'établissement initial de la connexion (avant envoi de la charge utile). Les requêtes de type `GET` sont toujours réessayées en cas de timeout de réception.
