## *Funkcionális specifikáció –LumiAi*

---

### *1. rész – Rendszerarchitektúra, alapfunkciók és kommunikáció*

## 1.1. Rendszerarchitektúra

Az alkalmazás elsődlegesen **mobilplatformra** (Android és iOS) készül, mivel a célcsoport számára a hordozhatóság és a könnyű hozzáférhetőség alapvető szempont.  
A rendszer célja, hogy a felhasználó természetes módon, hangutasítások segítségével tudjon kapcsolatba lépni a környezetével.  
A rendszer architektúrája moduláris felépítésű, így a különböző komponensek önállóan fejleszthetők és karbantarthatók.

### Fő komponensek:

1. **Felhasználói modul (User Interface & Input/Output):**  
   - Felelős a felhasználóval való kommunikációért.  
   - A rendszer nem vizuális, hanem **hangalapú interfészt** használ.  
   - Tartalmazza a mikrofonvezérlést, a hangutasítások kezelését és a TTS alapú visszajelzést.  
   - A cél, hogy a látássérült felhasználó egyszerűen, vizuális megerősítés nélkül is kezelni tudja az alkalmazást.

2. **Képfeldolgozó modul (Image Processing Module):**  
   - A kamera által készített képeket előfeldolgozza.  
   - Feladata a képminőség optimalizálása (élesség, fényviszonyok javítása).  
   - Tömöríti és előkészíti az adatot a továbbításra a Gemini Live API felé.  
   - A feldolgozás során figyelni kell az adatbiztonságra és az adatméretre, hogy a kommunikáció hatékony maradjon.

3. **Kommunikációs modul (Network & API Handler):**  
   - Biztosítja az adatátvitelt az alkalmazás és a külső API-k között.  
   - Támogatja a **REST** és **WebSocket** alapú kommunikációt.  
   - Feladata az adatok titkosított (HTTPS) csatornán történő továbbítása.  
   - Hálózati hibák esetén automatikusan újrapróbálkozást végez vagy offline módba vált.

4. **Hangfeldolgozó modul (Speech Processing Module):**  
   - A beszéd felismerését (STT – Speech-to-Text) és a válaszok felolvasását (TTS – Text-to-Speech) végzi.  
   - Integrálható szolgáltatások: **Google Speech API**, **Whisper**, vagy az adott operációs rendszer beépített megoldása.  
   - Biztosítja a természetes hangzást, valamint a többnyelvű támogatást (pl. magyar és angol).

5. **Vezérlő logikai modul (Core Logic / Decision Engine):**  
   - Összefogja az összes modul működését.  
   - Elemzi a felhasználó kérését, eldönti, hogy milyen műveletet kell végrehajtani.  
   - Például: ha a felhasználó azt mondja, *„Mit látok?”*, akkor a kamera modult aktiválja, és elindítja a képfeldolgozást.  
   - A modul figyel a hibákra, eseményekre, és biztosítja a folyamatos működést.

 ## 1.2. Adatáramlás

Az adatáramlás a rendszer működésének alapja.  
A modulok közötti kommunikáció eseményvezérelt, így minden lépés meghatározott sorrendben történik.

### Folyamatleírás:

1. A felhasználó **hangparancsot** ad, például: „Mit látok magam előtt?”.  
2. A **mikrofon** rögzíti a hangot, és továbbítja az STT modulnak.  
3. Az **STT modul** felismeri és szöveggé alakítja a hangot.  
4. A **vezérlő logika** elemzi a szöveget, meghatározza a feladat típusát.  
5. A rendszer aktiválja a **kamera modult**, amely képet készít a környezetről.  
6. A kép előfeldolgozása megtörténik (méret, fény, kontraszt beállítás).  
7. A kép **base64 formátumban** vagy **multipart form-data** struktúrában elküldésre kerül a Gemini Live API-nak.  
8. A **Gemini Live API** mesterséges intelligenciája elemzi a képet és leírja annak tartalmát.  
9. Az API **szöveges választ** küld vissza a rendszernek, például: „Egy asztalt és egy laptopot látok.”  
10. A válasz szöveges formában megérkezik az alkalmazásba.  
11. A **TTS modul** hangos formába alakítja a választ.  
12. A felhasználó **hangos visszajelzést** kap: „Egy asztalt és egy laptopot látsz.”  

### További részletek:

- Az adatfolyam valós időben zajlik, a késleltetés minimalizálása érdekében.  
- Hibakezelés beépítve: ha a hálózat megszakad, a rendszer hangosan jelzi („A kapcsolat megszakadt.”).  
- Az adatok feldolgozása titkosított csatornán történik, így a személyes információk védelme biztosított.

## 1.3. Kommunikációs interfészek

A rendszer több különböző interfészen keresztül kommunikál, mind külső, mind belső szinten.

### 1.3.1. Gemini Live API
- A **Gemini Live API** egy felhőalapú szolgáltatás, amely képfelismerést és leírásgenerálást végez.  
- A kommunikáció **HTTPS** vagy **WebSocket** alapon zajlik.  
- A képadatot az alkalmazás **base64** vagy **multipart/form-data** formátumban továbbítja.  
- A válasz JSON formátumban érkezik vissza, amely tartalmazza a kép elemzését, leírását és esetleges metaadatokat.  
- Példa egy tipikus válaszra:
  ```json
  {
    "description": "Egy férfi ül egy asztalnál, előtte egy laptop.",
    "confidence": 0.95
  }

 
### 1.3.2. STT / TTS szolgáltatás

- A beszédfelismeréshez és hangvisszaadáshoz a rendszer több szolgáltatást is integrálhat:

    - Google Speech API – valós idejű és pontos felismerés.

    - Whisper – offline működésre is alkalmas, nyílt forráskódú megoldás.

    - Android / iOS natív API – egyszerű, gyors integráció.

- A választott szolgáltatás a felhasználó beállításaitól és az internetkapcsolat elérhetőségétől függ.

### 1.3.3. Belső API

- A modulok közötti kommunikáció eseményalapú üzenetkezeléssel történik.

- Minden modul saját eseményfigyelőt és feldolgozót tartalmaz.

- Például:

    - onSpeechRecognized() → elindítja a képfeldolgozást

    - onImageProcessed() → elküldi az adatot az API-nak

    - onResponseReceived() → aktiválja a TTS modult

- Ez az architektúra lehetővé teszi az aszinkron működést és a valós idejű válaszokat.
---

## 1.4. Rendszerindítás és leállítás

A rendszer működése során fontos a stabilitás és a megbízhatóság.
Indításkor és leállításkor több automatikus folyamat zajlik le a hibamentes működés érdekében.


### *2. rész – Felhasználói interakciók, funkciók és kezelési folyamatok*


### *3. rész – Nem funkcionális követelmények, biztonság, és fejlesztési keretek*

