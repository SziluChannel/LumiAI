## *Követelmény specifikáció – LumiAI*

### *1. rész – Általános leírás, célok, és felhasználói igények*
## Bevezetés

A projekt célja egy olyan intelligens rendszer létrehozása, amely segítséget nyújt a látássérülteknek a mindennapi életben való eligazodásban, különösen a vizuális információk felismerésében és értelmezésében.  
A rendszer célja, hogy a kamera által rögzített vizuális környezetet elemezze, azonosítsa a fontos elemeket (például tárgyakat, embereket, feliratokat, akadályokat), majd ezeket hangalapú formában továbbítsa a felhasználónak.
Ez a megoldás hozzájárul ahhoz, hogy a látássérültek önállóbban és biztonságosabban tudjanak közlekedni, vásárolni, vagy más mindennapi tevékenységeket végezni.

A probléma gyökere abban rejlik, hogy a látássérült emberek jelentős hátrányt szenvednek a vizuális információkhoz való hozzáférés terén.  
A környezetükből érkező információk nagy része vizuális jellegű, legyen szó közlekedési táblákról, feliratokról, emberek mozgásáról vagy tárgyak helyzetéről.  

## Célrendszer

A projekt fő célja, hogy a megrendelő (vagyis a látássérültek segítését célul kitűző szervezet, illetve maga a felhasználói közösség) számára olyan eszközt biztosítson, amely hatékonyan támogatja az önálló életvitelt.  
A rendszer segítségével a felhasználó képes lesz a környezetében lévő tárgyakat, akadályokat, személyeket vagy akár feliratokat felismerni, és erről valós idejű hangos visszajelzést kapni.

### A célrendszer főbb elemei:

1. **Alapvető cél:**  
   A látássérült emberek önálló életvitelének elősegítése a vizuális információk auditív formában történő közvetítésével.

2. **Technológiai cél:**  
   Olyan mesterséges intelligencián alapuló képfelismerő és beszédgeneráló rendszer megalkotása, amely valós időben működik, és képes alkalmazkodni a különböző környezeti feltételekhez.

3. **Felhasználói cél:**  
   Egyszerűen kezelhető, megbízható és könnyen hordozható megoldás biztosítása, amely nem igényel bonyolult beállításokat vagy műszaki ismereteket.

4. **Társadalmi cél:**  
   A látássérültek társadalmi integrációjának erősítése, az önbizalom növelése és a mindennapi tevékenységekben való részvétel elősegítése.

A megrendelő célja, hogy a rendszer fejlesztésével és bevezetésével a látássérültek életminősége jelentősen javuljon.  
A projekt hozzájárulhat ahhoz is, hogy csökkenjen a gondozók terhelése, és a felhasználók nagyobb önállóságot élvezhessenek a mindennapokban.

---

## Felhasználói igények és elvárások

A fejlesztés során kiemelt figyelmet kell fordítani a látássérült felhasználók speciális igényeire.  
Az eszköz vagy alkalmazás használatának intuitívnak, gyorsnak és biztonságosnak kell lennie.

### A legfontosabb igények:

1. **Egyszerű, hangalapú vezérlés:**  
   A rendszernek teljes mértékben hangutasításokkal kezelhetőnek kell lennie.  
   A hangfelismerésnek pontosnak és gyorsnak kell lennie, hogy a felhasználó természetes módon kommunikálhasson az eszközzel.

2. **Valós idejű visszajelzés a kamera képéből:**  
   A rendszernek képesnek kell lennie a környezet azonnali elemzésére és a releváns információk hangos közvetítésére.  
   Ez különösen fontos közlekedés vagy akadálykerülés közben.

3. **Offline és online működés:**  
   Fontos, hogy a rendszer internetkapcsolat nélkül is használható legyen alapfunkcióiban.  
   Az online mód pedig pontosabb felismerést és frissítéseket biztosíthat.

4. **Adatvédelem és személyes adatok védelme:**  
   A képi és hangadatok feldolgozása során biztosítani kell az adatbiztonságot és a GDPR-megfelelőséget.  
   Az adatok nem kerülhetnek illetéktelen kezekbe, és a felhasználónak mindig tudnia kell, milyen információkat kezel a rendszer.

5. **Könnyű telepítés és frissítés:**  
   A rendszer legyen egyszerűen telepíthető és automatikusan frissíthető, minimális felhasználói beavatkozással.

6. **Kompakt és kényelmes kialakítás:**  
   Amennyiben a rendszer hardveres eszközt is tartalmaz, annak könnyen hordozhatónak és ergonomikusnak kell lennie.  
   A hosszabb használat sem okozhat kényelmetlenséget.

7. **Multinyelvű támogatás:**  
   A rendszernek több nyelvet is kezelnie kell, különös tekintettel a magyar nyelvre és a természetes hangvisszaadásra.

---

## Célcsoport

A fejlesztés célcsoportja több szinten értelmezhető.

### 1. Elsődleges célcsoport:
Teljesen vagy részlegesen látássérült személyek, akik önállóan szeretnének közlekedni, vásárolni, tanulni vagy dolgozni.  
Ők a rendszer legfőbb felhasználói, akik számára az eszköz mindennapi segítséget nyújthat.  
A különböző fokú látássérülésekhez igazodó testreszabási lehetőségek biztosítása kiemelten fontos.

### 2. Másodlagos célcsoport:
A látássérültek gondozói, családtagjai és segítői, akik a rendszer használatával könnyebben támogathatják szeretteik biztonságát és önállóságát.  
Számukra a rendszer megkönnyítheti a felügyeletet és a kommunikációt is.

### 3. Kiegészítő célcsoport:
Oktatási intézmények, rehabilitációs központok és civil szervezetek, amelyek a látássérültek fejlesztését és társadalmi integrációját segítik.  
A rendszer számukra oktatási vagy demonstrációs célokra is hasznos lehet.

## Összegzés

A projekt célja, hogy a modern technológia eszközeivel valós segítséget nyújtson a látássérültek számára.  
A rendszer a vizuális világot érthető és hozzáférhető módon közvetíti azoknak, akik számára a látás korlátozott vagy nem lehetséges.  
A hangsúly az egyszerűségen, a biztonságon, az adatvédelemen és a valós idejű működésen van.  
A fejlesztés nemcsak technológiai, hanem társadalmi értéket is képvisel, hiszen hozzájárul egy befogadóbb és akadálymentesebb világ megteremtéséhez.




### *2. rész – Rendszerfunkciók, környezet és interfészek*

### *3. rész – Nem funkcionális követelmények és projektkeretek*

Ez a fejezet azokat az elvárásokat foglalja össze, amelyek nem közvetlenül egy-egy funkcióhoz kapcsolódnak, hanem az alkalmazás egészének minőségét, használhatóságát és megbízhatóságát határozzák meg a felhasználó szemszögéből.

#### **1. Azonnali és megbízható segítség a mindennapokban (Teljesítmény)**

A LumiAI egy digitális segítőtárs, amelynek mindig kéznél kell lennie, és azonnali, pontos információval kell szolgálnia. A felhasználónak éreznie kell, hogy számíthat az alkalmazásra.

*   **Gyorsaság – "Azonnal tudni akarom, mi van előttem."**
    *   Amikor a felhasználó a kamerát egy tárgyra irányítja, a hangalapú leírásnak szinte azonnal, legfeljebb egy-két másodpercen belül meg kell érkeznie. A gyors visszajelzés elengedhetetlen a magabiztos tájékozódáshoz, legyen szó egy bevásárlásról vagy egy ismeretlen helyen való közlekedésről. A várakozás bizonytalanságot szül, ezt el kell kerülni.

*   **Megbízhatóság – "Bíznom kell benne, hogy mindig működik."**
    *   Az alkalmazásnak stabilan kell működnie, még akkor is, ha a mobilinternet-kapcsolat gyenge vagy ingadozó. Ha a kapcsolat megszakad, az applikációnak nem szabad összeomlania vagy lefagynia. Ehelyett egyértelmű, nyugodt hangon kell jeleznie a problémát (pl. "Nincs internetkapcsolat, próbálja meg később"), és amint a hálózat helyreáll, zökkenőmentesen kell folytatnia a munkát.

*   **Diszkréció és hatékonyság – "Ne merítse le a telefonomat."**
    *   A felhasználók egész nap maguknál hordják a telefonjukat, és számos más alkalmazást is használnak. A LumiAI nem merítheti le túlzottan az akkumulátort, és nem fogyaszthat feleslegesen sok mobiladatot. A háttérben futó folyamatokat optimalizálni kell, hogy az alkalmazás használata ne menjen a telefon általános használhatóságának rovására.

#### **2. Egyszerű, természetes és stresszmentes használat (Használhatóság)**

A LumiAI kezelőfelületének és működésének a lehető leginkább intuitívnak és a látássérült felhasználók igényeire szabottnak kell lennie.

*   **Hangvezérlés – "Úgy beszélhessek hozzá, mint egy emberhez."**
    *   A felhasználónak nem kell bonyolult parancsszavakat megtanulnia. Az alkalmazásnak értenie kell az egyszerű, hétköznapi nyelven megfogalmazott kéréseket, mint például: "Mi ez?", "Olvasd el ezt a szöveget!" vagy "Milyen színű ez a ruha?". A kommunikációnak párbeszédszerűnek kell lennie.

*   **Egyértelmű visszajelzések – "Tudnom kell, mi történik."**
    *   Minden felhasználói műveletre (pl. a kamera aktiválása) és rendszerállapot-változásra (pl. a kép elemzése folyamatban) érthető hangjelzésnek vagy finom rezgésnek kell érkeznie. Ez a folyamatos visszacsatolás biztonságérzetet ad, a felhasználó mindig tudja, hogy az alkalmazás "figyel rá" és dolgozik a kérésén.

*   **Teljes körű akadálymentesség – "Minden funkciót el kell érnem."**
    *   Az alkalmazásnak tökéletesen együtt kell működnie a mobiltelefonok beépített képernyőolvasó szoftvereivel (mint a VoiceOver vagy a TalkBack). Minden gombnak, beállítási lehetőségnek és szöveges tartalomnak megfelelően felcímkézettnek kell lennie, hogy a képernyőolvasóval navigáló felhasználók számára is teljes értékű élményt nyújtson.
