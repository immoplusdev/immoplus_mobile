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
