# Audit — format des numéros de téléphone (apps Client et Pro)

Audit en lecture seule du code des deux applications :

- App Client : `immoplus_mobile`
- App Pro : `immoplus_pro_mobile`

Rien n'a été exécuté ni modifié. Les formats réellement renvoyés par le backend n'ont pas été observés : les points qui en dépendent sont marqués **à confirmer**.

---

## 1. Mécanisme commun aux deux apps

### Formateur

`PhoneNumberHandler.formatPhoneNumber` (Client : `lib/app/utils/phone_number_handler.dart`, Pro : `lib/utils/phone_number_handler.dart`) ne garde que les chiffres et retire le `+` ou le `00` initial.

Exemple : `+225 07 87 61 07 16` devient `2250787610716`.

L'app Client a en plus `removeDialCode`, et une seconde fonction `Utils.formatPhoneNumber` (basée sur `intl_phone_number_input`) qui insère un tiret après l'indicatif.

### Intercepteur Dio (filet de sécurité)

`PhoneNumberInterceptor` est identique dans les deux apps. Limites :

- il ne regarde que les clés **racines** `phoneNumber` et `phone_number` ;
- il n'agit que si la valeur **commence par `+`** : les espaces ne sont jamais retirés ;
- il ignore les objets imbriqués, les paramètres d'URL et les clés comme `clientPhoneNumber`, `telephone`, `paymentCredentials`.

### Saisie

- `InternationalPhoneInput` (basé sur `intl_phone_number_input`) renvoie un numéro E.164 (`+2250787610716`) uniquement quand il est valide. `maxLength` est fixé à 13.
- `CountryPhoneNumberInput` (Client) : champ avec masque `## #### ## ##`. Le sélecteur de pays est décoratif (`onChanged: print`) et la validation vérifie seulement que le champ n'est pas vide.
- Paiement et retrait : masque `## ## ## ## ##` (10 chiffres nationaux) et validation par opérateur (regex `^07…`, `^05…`, `^01…`).

---

## 2. App Client — flux par flux

| Flux | Champ envoyé | Format produit | Verdict |
|---|---|---|---|
| Connexion `POST /auth/phone/challenges` | `phoneNumber` | `2250787610716` (confirmé par un payload réel) | OK |
| Renvoi / vérification du code | `phoneNumber` | formateur | OK |
| Inscription, changement de contact | `phoneNumber` | formateur | OK |
| Modification du profil | `phoneNumber` | formateur à l'envoi | OK à l'envoi (voir §2.2 point 5) |
| Retrait du coffre | `phoneNumber` | `+225…`, puis `+` retiré par l'intercepteur | OK, repose sur le filet |
| Réservation de résidence | `clientPhoneNumber` | texte brut du champ | **À corriger** |
| Demande de visite | `clientPhoneNumber` | `"225" + texte du champ` | **À corriger** |
| Réservation d'hôtel | `voyageur.telephone` | `currentUser.phoneNumber` brut | **À vérifier** |
| Paiement mobile money | `paymentCredentials` | `0787610716` (10 chiffres nationaux) | Différent des autres |

### 2.1 Détail des points sensibles

- **Réservation** (`booking_formular_action.dart`, ligne ~747) : le champ est prérempli avec `currentUser.phoneNumber` tel que stocké. Si l'utilisateur le modifie, le masque produit `07 8761 07 16`. Trois formats sont possibles : `2250…`, `+2250…`, `07 8761 07 16`.
- **Visite** (`visit_formular_action.dart`, ligne ~58) : `"225${texte}"`. Le champ est prérempli avec `currentUser.number` (accesseur local qui retire `+225` / `225`). Si l'utilisateur modifie le champ, le masque ajoute des espaces : `22507 8761 07 16`. Le `225` est forcé : un numéro étranger deviendrait faux.
- **`currentUser.number`** n'est pas un champ de l'API : c'est un accesseur de `user_model_schema.dart` qui retire `+225` ou `225` au début de `phoneNumber`. Il prouve que l'app doit gérer deux formats stockés.

### 2.2 Constats

1. Réservation et visite : formats non maîtrisés (voir ci-dessus).
2. Sélecteur de pays décoratif : le pays choisi n'est jamais utilisé.
3. Hôtel : aucun nettoyage du numéro envoyé.
4. Paiement : regex sans `$` final (`^(99|0[157])[0-9]{8}`), et numéro national sans `225`.
5. Écran de modification du profil : `initialPhoneNumber` reçoit `phoneNumber` brut alors que le champ international attend `+225…`. L'écran du coffre, lui, ajoute un `+` avant l'affichage. Les deux écrans ne se comportent pas pareil. **À confirmer** avec le format réel renvoyé.
6. `InternationalPhoneInput.onValidPhoneNumber` n'est appelé que pour un numéro valide : la dernière valeur valide reste en mémoire chez l'appelant si le numéro devient invalide ensuite. Les écrans lus vérifient aussi l'indicateur de validité ; tous les appelants n'ont pas été contrôlés.
7. Validateur `FormUtils.numberValidator` : n'accepte que `07`, `01`, `05` suivis de 8 chiffres.
8. Aucun test unitaire pour le formateur ni pour l'intercepteur.

---

## 3. App Pro — flux par flux

| Flux | Champ envoyé | Format produit | Verdict |
|---|---|---|---|
| Connexion / inscription (ancien flux d'envoi de code) | `phoneNumber` | formateur : `2250787610716` | OK |
| Changement de contact | `phoneNumber` | formateur | OK |
| Modification du profil | `phoneNumber` | formateur (`_phoneToJson`) | OK à l'envoi |
| Retrait (création) | `phoneNumber` | `0787610716` (10 chiffres nationaux) | **Différent de l'app Client** |
| Retrait depuis un QR | `phoneNumber` | `0787610716` | **Différent de l'app Client** |
| Paiement mobile money | `paymentCredentials` | numéro national à 10 chiffres | Comme le Client |
| Détail d'une réservation | `clientPhoneNumber` (lecture) | `split('-')` puis dernier morceau | Suppose un format `225-0787610716` |
| Détail d'une visite | `client.phoneNumber` (lecture) | utilisé tel quel pour l'appel | **À confirmer** |

### Constats

1. **Même champ, deux formats** : le retrait de l'app Client envoie `2250787610716`, celui de l'app Pro envoie `0787610716`, vers le même DTO (`CreateWalletWithdrawalRequestDto.phoneNumber`).
2. **Tiret** : l'app Pro découpe `clientPhoneNumber` sur `-`. Cela suppose que le backend renvoie `225-0787610716`. Une ancienne version de l'app Client produisait ce format (`Utils.formatPhoneNumber` insère un tiret après l'indicatif). C'est une déduction du code, pas une valeur observée.
3. L'app Pro n'utilise pas `/auth/phone/challenges` : elle utilise l'ancien flux d'envoi de code (`SendOptModel`).
4. Mêmes limites de l'intercepteur et du masque de saisie que l'app Client.
5. Modification du profil : même risque que côté Client (`initialPhoneNumber` brut).

---

## 4. Ce que dit le Swagger

Source : `https://api-v2.immoplus.ci/swagger`

| Schéma | Champ | Exemple / description |
|---|---|---|
| `CreatePhoneChallengeCommand` | `phoneNumber` | `+2250700000000` |
| `SendOtpDto`, `VerifyOtpDto` | `phoneNumber` | `2250707070707` |
| `PayBillingInvoiceDto` | `payerPhone` | `+2250700000000` |
| `SyncContactDto` | `phoneNumbers` | « dans n'importe quel format. Un numéro sans indicatif est lu comme ivoirien. » (exemple `+2250700000001`) |
| `CreatePaymentIntentCommand` | `paymentCredentials` | « Numéro de téléphone (mobile money) » |
| `MarketingProAcquisitionDto` | `telephoneIndicatif`, `telephoneNumero` | seul schéma avec indicatif et numéro séparés |
| `UserDto`, `clientPhoneNumber`, `ownerPhoneNumber`, `voyageur.telephone`, retraits | — | aucun exemple ni format indiqué |

Les formats ne sont donc pas cohérents entre endpoints (avec ou sans `+`), et la plupart des champs n'ont aucun exemple.

---

## 5. Questions pour le backend

### Ce que vous renvoyez
1. `UserDto.phoneNumber` (`/users/me`, connexion, vérification du code) : quel format exact ? Identique partout ?
2. Existe-t-il un champ séparé pour l'indicatif ou pour le numéro national ? Si oui, lequel, sur quels objets ?
3. `clientPhoneNumber` (réservations, visites), `ReservationClientInfoDto.phoneNumber`, `ownerPhoneNumber`, `contactPhoneNumber`, `voyageur.telephone` : quel format pour chacun ? Trouve-t-on encore des valeurs avec tiret (`225-0787610716`) ou espaces ?
4. Les anciennes données en base ont-elles été normalisées ?

### Ce que nous devons envoyer
5. `POST /auth/phone/challenges` : le `+` est-il obligatoire, facultatif ou refusé ? Le Swagger et l'app Client ne sont pas d'accord.
6. Le format attendu est-il le même pour tous les endpoints ? Réponse attendue champ par champ :
   - `phoneNumber` (connexion, vérification du code, inscription, changement de contact) ;
   - `clientPhoneNumber` (réservation et visite) ;
   - `voyageur.telephone` ;
   - `paymentCredentials` (mobile money) ;
   - `phoneNumber` du retrait (`CreateWalletWithdrawalRequestDto` et création depuis un QR).
7. Un numéro sans indicatif est-il toujours interprété comme ivoirien ? Un numéro ivoirien garde-t-il le `0` initial après `225` (`2250787610716`) ?
8. Les espaces, tirets et le `+` sont-ils acceptés, ignorés ou refusés ?
9. Comment le backend détermine-t-il le pays d'un numéro ? Quels pays sont prévus à court terme ?
10. `paymentCredentials` : numéro national, avec indicatif ou autre ? Valable pour tous les opérateurs ?

---

## 6. Demande de documentation

Après vérification côté backend, mise à jour du Swagger pour que les apps puissent s'y caler et nettoyer leur code :

- pour chaque champ téléphone, une description du format attendu ;
- des exemples concrets de **requêtes** avec un numéro **ivoirien** et un numéro **français** ;
- des exemples de **réponses** pour les mêmes champs, qui montrent le format réellement renvoyé.

---

## 7. Limites de cet audit

- Aucune exécution, aucun appel réel à l'API : le format de `phoneNumber` renvoyé par le backend n'est pas vérifié.
- Le point sur le tiret dans l'app Pro est une déduction du code.
- Tous les écrans n'ont pas été relus ligne à ligne ; les fichiers cités ont été lus.
- Aucune modification de code n'a été faite. La correction côté mobile est suspendue à la réponse du backend.
