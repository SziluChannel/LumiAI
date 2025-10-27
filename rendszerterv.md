## LumiAI – Rendszerterv

### 1. Frontend (Flutter UI + interakció)



### 2. Backend + API integráció

**Cél:** adatáramlás, kép-feldolgozás és AI válaszkezelés

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
