## LumiAI – Rendszerterv

### 1. Frontend (Flutter UI + interakció)



### 2. Backend + API integráció

Ez a fejezet a LumiAI alkalmazás szerveroldali architektúráját és annak technikai megvalósítását részletezi. A backend teljes egészében a **Google Firebase** platformra épül, kihasználva annak szervermentes, skálázható és szorosan integrált szolgáltatásait. Ez a megközelítés minimalizálja az infrastruktúra menedzsmentjét, és lehetővé teszi a fejlesztői csapat számára, hogy az alapvető alkalmazáslogikára összpontosítson.

* **Backend:** Firebase (Cloud Functions + Firestore)
* **Fő komponensek:**

  * Felhasználói profil (beállítások, látásmód)
  * API proxy a **Gemini Live API**-hoz (Cloud Function)
  * Képfeltöltés (Firebase Storage)
  * Naplózás, hibakezelés
* **Technikai részletek:**

  * Cloud Function Node.js környezet
  * HTTPS endpoint: `/analyze-image`
  * Hitelesítés: Firebase Auth (anonymous / Google)
  * Gemini Live API hívás (REST POST → JSON válasz)
  * Adattárolás Firestore-ban: beállítások, előzmények
* **Visszajelzés a kliensnek:**

  * JSON válasz: `{ "description": "Egy kutya áll előtted." }`
  * Kliens oldalon TTS átalakítás
* **Későbbi bővítés:**

  * Lokális modellek (TensorFlow Lite)
  * API cache a költségek csökkentésére

---
### 3. Integráció, biztonság, teljesítmény*
