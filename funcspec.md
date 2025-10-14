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

---


### *2. rész – Felhasználói interakciók, funkciók és kezelési folyamatok*


### *3. rész – Nem funkcionális követelmények, biztonság, és fejlesztési keretek*

