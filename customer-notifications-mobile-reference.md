# Fiche de référence — Notifications Marketing Client (Customer)

> **Destinataires :** Développeurs mobiles (iOS / Android)
> **Dernière mise à jour :** 2026-07-17
> **Source :** `src/infrastructure/features/customer-notifications/`

---

## Structure du payload `data` reçu côté mobile

Chaque notification push marketing contient un objet `data` avec la structure suivante :

```json
{
  "type": "marketing",
  "code": "CLI-ONB-02"
}
```

| Champ | Type | Valeur | Description |
|-------|------|--------|-------------|
| `type` | `string` | Toujours `"marketing"` | Catégorie de la notification |
| `code` | `string` | Voir tableaux ci-dessous | Identifiant unique du template |

> La logique de redirection côté mobile se fait **uniquement sur le champ `code`**.

---

## Onboarding — `CLI-ONB-*`

Série de notifications envoyées automatiquement dans les 30 premiers jours suivant l'inscription.

| Code | Déclencheur | Titre | Corps | Canaux | Redirection mobile |
|------|-------------|-------|-------|--------|--------------------|
| `CLI-ONB-02` | J+1 après inscription | Complétez votre profil pour des résultats personnalisés | Ajoutez vos préférences : budget, type de bien, quartier | Push | Écran **Profil / Préférences** |
| `CLI-ONB-03` | J+3 après inscription | Ces résidences vous attendent à `{{quartier_actif}}` 👀 | `{{description_biens}}` | Push | Écran **Recherche** (liste résidences) |
| `CLI-ONB-04` | J+7 après inscription | ImmoPlus : si votre voisin loue à moins de `{{prix_reference}}` FCFA/mois | Vous cherchez quelque chose de similaire ? Utilisez Imatch ! | Push | Écran **Imatch** |
| `CLI-ONB-05` | J+14 après inscription | 1000 FCFA la Visite Express, en 24h découvrez le bien de vos rêves | Planifiez une visite aujourd'hui, voyez le bien demain | Push | Écran **Visite Express** |
| `CLI-ONB-06` | J+21 après inscription | `{{nb_nouveaux_biens}}` nouveaux biens ajoutés cette semaine à Abidjan | Regardez avant que ça parte ! | Push | Écran **Recherche** (liste résidences) |
| `CLI-ONB-07` | J+30 après inscription | Un mois avec ImmoPlus 🎉 | Merci de nous faire confiance. Voici les meilleurs biens du moment. | Push | Écran **Accueil** |

---

## Réengagement inactif — `CLI-REENG-*`

Notifications envoyées aux utilisateurs n'ayant pas ouvert l'application depuis N jours.

| Code | Inactivité | Titre | Corps | Canaux | Redirection mobile |
|------|-----------|-------|-------|--------|--------------------|
| `CLI-REENG-07` | 7 jours | Vous nous manquez 👋 | Des dizaines de nouvelles résidences ont été ajoutées depuis votre dernière visite | Push | Écran **Accueil / Nouveautés** |
| `CLI-REENG-14` | 14 jours | ⚡ Prix abordable sur une résidence que vous avez consultée | La résidence `{{nom_ou_quartier}}` est maintenant à `{{prix}}` FCFA/mois | Push | Écran **Recherche** |
| `CLI-REENG-30` | 30 jours | 30 jours déjà ! Voici ce que vous avez raté 🔥 | 15 nouvelles résidences à `{{quartier_prefere}}`, dès `{{prix_min}}` FCFA | Push + Email | Écran **Recherche** |
| `CLI-REENG-60` | 60 jours | 🚨 Votre compte est toujours actif | Ne laissez pas passer les meilleures offres immobilières d'Abidjan | Push + SMS + Email | Écran **Accueil** |

---

## Nurturing comportemental — `CLI-NURT-*`

Notifications déclenchées par des actions spécifiques de l'utilisateur sur l'application.

| Code | Déclencheur | Titre | Corps | Canaux | Redirection mobile | `referenceId` |
|------|-------------|-------|-------|--------|--------------------| --------------|
| `CLI-NURT-01` | Bien consulté 2 fois | Vous l'avez regardé deux fois... 😏 | `{{nom_bien}}` vous plaît vraiment ? Réservez avant qu'il parte. | Push | Fiche **Détail Résidence** *(voir note A)* | `bienId` (UUID résidence) |
| `CLI-NURT-02` | Bien en favori non réservé | Toujours intéressé par `{{nom_bien}}` ? | Il est encore disponible dans vos favoris. | Push | Écran **Favoris** | `bienId` (UUID résidence) |
| `CLI-NURT-PC-01` | Bien « aimé » encore dispo | Vous avez aimé `{{nom_bien}}` ? | Elle est encore disponible. Ne la laissez pas partir. | Push | Fiche **Détail Résidence** *(voir note A)* | `bienId` (UUID résidence) |
| `CLI-NURT-PC-03` | X viewers sur résidence en live | ⚡ `{{nb_viewers}}` autres clients regardent cette résidence en ce moment | Réservez maintenant avant qu'il soit trop tard | Push | Fiche **Détail Résidence** *(voir note A)* | `bienId` (UUID résidence) |

---

## Nurturing alerte — `CLI-NURT-AL-*`

Notifications liées au cycle de vie des alertes immobilières créées par l'utilisateur.

| Code | Déclencheur | Titre | Corps | Canaux | Redirection mobile | `referenceId` |
|------|-------------|-------|-------|--------|--------------------|---------------|
| `CLI-NURT-AL-01` | Création d'une alerte | Votre alerte est activée ✅ | Nous cherchons activement un bien correspondant à vos critères | Push | Écran **Alertes** *(voir note B)* | `alertId` (UUID alerte) |
| `CLI-NURT-AL-02` | J+3 après création alerte | Notre équipe recherche votre bien idéal 🔍 | Vous serez alerté dès qu'un bien correspondant est trouvé | Push | Écran **Alertes** | `alertId` (UUID alerte) |
| `CLI-NURT-AL-03` | J+7 après création alerte | Nous avons `{{nb_biens}}` biens similaires à vos critères | Un conseiller vous contacte sous peu | Push | Écran **Alertes** *(voir note B)* | `alertId` (UUID alerte) |
| `CLI-NURT-AL-04` | Match alerte trouvé | 🎉 Bonne nouvelle ! Un bien vous correspond ! | Consultez votre alerte pour découvrir le bien qui vous correspond. | Push (priorité haute) | Écran **Alertes** *(voir note B)* | `alertId` (UUID alerte) |

---

## Post-réservation — `CLI-RESA-*`

Notifications envoyées autour du séjour d'un utilisateur ayant une réservation validée et payée.

| Code | Déclencheur | Titre | Corps | Canaux | Redirection mobile | `referenceId` |
|------|-------------|-------|-------|--------|--------------------|---------------|
| `CLI-RESA-02` | J-3 avant date de début séjour | 📅 Plus que 3 jours avant votre séjour ! | Voici les informations pratiques : `{{adresse}}`, contact : `{{contact_proprietaire}}` | Push | Détail **Réservation** *(voir note C)* | `reservationId` (UUID réservation) |
| `CLI-RESA-03` | Jour J du séjour (date_debut) | 🏠 Bienvenue dans votre résidence ! | Profitez bien de votre séjour. | Push | Détail **Réservation** *(voir note C)* | `reservationId` (UUID réservation) |
| `CLI-RESA-04` | J+2 après début séjour | Tout se passe bien ? 😊 | Signalez tout problème facilement depuis l'app | Push | Détail **Réservation** / Écran **Signalement** | `reservationId` (UUID réservation) |
| `CLI-RESA-05` | Jour de fin de séjour (date_fin) | Merci pour votre séjour 👋 | Notez votre expérience – votre avis aide les futurs locataires | Push | Écran **Avis / Notation** *(voir note C)* | `reservationId` (UUID réservation) |
| `CLI-RESA-06` | J+1 après fin de séjour | Votre avis compte pour la communauté ⭐ | Notez `{{nom_bien}}` et recevez 500 FCFA de crédit ImmoPlus | Push | Écran **Avis / Notation** *(voir note C)* | `reservationId` (UUID réservation) |

---

## Saisonnalité — `CLI-SEASON-*`

Notifications liées aux événements calendaires et tendances de marché.

| Code | Déclencheur | Titre | Corps | Canaux | Redirection mobile |
|------|-------------|-------|-------|--------|--------------------|
| `CLI-SEASON-01` | Anniversaire 1 an d'inscription | 🎂 1 an avec ImmoPlus ! Merci de votre confiance | Profitez d'un accès prioritaire aux nouvelles annonces | Push | Écran **Accueil** |
| `CLI-SEASON-02` | Mensuel — quartier tendance | 📍 `{{quartier}}` est tendance en ce moment | `{{nb_biens}}` nouvelles résidences disponibles | Push | **Recherche** filtrée par quartier |
| `CLI-SEASON-03` | Baisse de prix dans quartier favori | 💥 Les prix ont baissé dans votre quartier favori | C'est le bon moment pour bouger | Push | **Recherche** filtrée |
| `CLI-SEASON-04` | Forte demande dans un quartier | ⚡ Forte demande à `{{quartier}}` cette semaine | Réservez vite, les biens partent vite | Push | **Recherche** filtrée par quartier |

---

## Social proof — `CLI-SOCIAL-*`

Notifications basées sur la preuve sociale et l'activité de la communauté.

| Code | Déclencheur | Titre | Corps | Canaux | Redirection mobile | `referenceId` |
|------|-------------|-------|-------|--------|--------------------| --------------|
| `CLI-SOCIAL-01` | Résidence populaire réservée (> 5 viewers) | 🔥 `{{nom_bien}}` vient d'être réservée | `{{nb_viewers}}` personnes regardaient cette résidence. Découvrez des similaires. | Push | **Recherche** résidences similaires *(voir note A)* | `bienId` (UUID résidence) |
| `CLI-SOCIAL-03` | 1er du mois — digest mensuel | 💬 Vos voisins adorent ImmoPlus | `{{nb_reservations_mois}}` résidences réservées ce mois-ci à Abidjan | Push | Écran **Accueil** | aucun |
| `CLI-SOCIAL-04` | Prix en hausse dans un quartier | 📈 Les prix montent dans `{{quartier}}` | Réservez maintenant avant la prochaine hausse | Push | **Recherche** filtrée par quartier | aucun |

---

## Notes importantes sur les redirections

### Note A — Codes liés à une résidence spécifique

Codes concernés : `CLI-NURT-01`, `CLI-NURT-PC-01`, `CLI-NURT-PC-03`, `CLI-SOCIAL-01`

Le `referenceId` (UUID de la résidence) est stocké côté serveur pour la déduplication mais **n'est pas inclus dans le payload push actuel**.

**Comportement actuel :** rediriger vers l'écran Recherche général.

**Comportement cible (après correction API) :** deep link direct vers la fiche résidence avec l'`id` reçu :
```json
{
  "type": "marketing",
  "code": "CLI-NURT-01",
  "referenceId": "uuid-de-la-residence"
}
```
→ Redirection : `/residences/:referenceId`

---

### Note B — Codes liés à une alerte spécifique

Codes concernés : `CLI-NURT-AL-01`, `CLI-NURT-AL-03`, `CLI-NURT-AL-04`

Même situation : l'`alertId` n'est **pas dans le payload push actuel**.

**Comportement actuel :** rediriger vers la liste générale des alertes.

**Comportement cible (après correction API) :**
```json
{
  "type": "marketing",
  "code": "CLI-NURT-AL-04",
  "referenceId": "uuid-de-l-alerte"
}
```
→ Redirection : `/alertes/:referenceId`

---

### Note C — Codes liés à une réservation spécifique

Codes concernés : `CLI-RESA-02`, `CLI-RESA-03`, `CLI-RESA-04`, `CLI-RESA-05`, `CLI-RESA-06`

Même situation : la `reservationId` n'est **pas dans le payload push actuel**.

**Comportement actuel :** rediriger vers la liste des réservations de l'utilisateur.

**Comportement cible (après correction API) :**
```json
{
  "type": "marketing",
  "code": "CLI-RESA-02",
  "referenceId": "uuid-de-la-reservation"
}
```
→ Redirection : `/reservations/:referenceId`

---

## Correction requise côté API

Pour activer le deep linking sur toutes les notifications, une modification est nécessaire dans le processor :

**Fichier :** `src/infrastructure/features/customer-notifications/customer-notifications.processor.ts` — ligne ~230

```ts
// Avant
data: { type: PushNotificationType.Marketing, code },

// Après
data: { type: PushNotificationType.Marketing, code, ...(referenceId && { referenceId }) },
```

Après correction, le payload complet reçu côté mobile sera :

```json
{
  "type": "marketing",
  "code": "CLI-RESA-02",
  "referenceId": "550e8400-e29b-41d4-a716-446655440000"
}
```

---

## Récapitulatif des redirections par écran

| Écran mobile | Codes déclencheurs |
|---|---|
| Accueil | `CLI-ONB-07`, `CLI-REENG-07`, `CLI-REENG-60`, `CLI-SEASON-01`, `CLI-SOCIAL-03` |
| Recherche / Liste résidences | `CLI-ONB-03`, `CLI-ONB-06`, `CLI-REENG-14`, `CLI-REENG-30` |
| Profil / Préférences | `CLI-ONB-02` |
| Imatch | `CLI-ONB-04` |
| Visite Express | `CLI-ONB-05` |
| Favoris | `CLI-NURT-02` |
| Fiche Résidence (deep link) | `CLI-NURT-01`, `CLI-NURT-PC-01`, `CLI-NURT-PC-03`, `CLI-SOCIAL-01` |
| Alertes (deep link) | `CLI-NURT-AL-01`, `CLI-NURT-AL-02`, `CLI-NURT-AL-03`, `CLI-NURT-AL-04` |
| Détail Réservation (deep link) | `CLI-RESA-02`, `CLI-RESA-03`, `CLI-RESA-04` |
| Avis / Notation | `CLI-RESA-05`, `CLI-RESA-06` |
| Recherche filtrée par quartier | `CLI-SEASON-02`, `CLI-SEASON-03`, `CLI-SEASON-04`, `CLI-SOCIAL-04` |
