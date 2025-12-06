import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/features/settings/providers/privacy_policy_provider.dart';

class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacyStateObj = ref.watch(privacyPolicyControllerProvider);
    final isAccepted = privacyStateObj.value ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Adatvédelmi Nyilatkozat')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LumiAi Adatkezelési Tájékoztató',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hatálybalépés dátuma: 2025. december 6.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ez a tájékoztató részletezi, hogyan kezeli a TechNova Innovációs Kft. (a továbbiakban: "Mi" vagy "Adatkezelő") a LumiAi szolgáltatás (a továbbiakban: "Szolgáltatás") felhasználóinak (a továbbiakban: "Ön") személyes adatait.',
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Az Adatkezelő adatai'),
                  const Text(
                    'Név: TechNova Innovációs Kft.\n'
                    'Székhely: 1095 Budapest, Lehel út 42. IV. em. 14.\n'
                    'Kapcsolattartási e-mail: privacy@lumiai-support.hu',
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('A kezelt személyes adatok köre'),
                  const Text(
                    'A LumiAi szolgáltatás jellegéből adódóan a következő kategóriájú személyes adatokat gyűjthetjük és kezelhetjük:\n\n'
                    '• Azonosító adatok: ideértve a nevet, e-mail címet és felhasználónevet a regisztráció során.\n'
                    '• Technikai adatok: mint az IP-cím, használt operációs rendszer és böngésző típusa, eszköz azonosítója, valamint hozzáférési dátumok és időpontok.\n'
                    '• Szolgáltatás használatával összefüggő adatok: beleértve a LumiAi API-n keresztül generált vagy feldolgozott adatokat (input promptok, kimeneti eredmények), funkciók használatának gyakoriságát és az esetleges előfizetési adatokat.',
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Az adatkezelés célja és jogalapja'),
                  const Text(
                    '• Szolgáltatás nyújtása: Ez magában foglalja a fiókkezelést és az API hozzáférést. Jogalap: a szerződés teljesítése (GDPR 6. cikk (1) bekezdés b) pont).\n'
                    '• Hibaelhárítás és biztonság: Jogalap: jogos érdekünk (GDPR 6. cikk (1) bekezdés f) pont).\n'
                    '• Pénzügyi elszámolás: Előfizetés esetén. Jogalap: jogi kötelezettség (GDPR 6. cikk (1) bekezdés c) pont).',
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Adattovábbítás'),
                  const Text(
                    'Az adatok továbbítását harmadik felek részére kizárólag akkor végezzük, ha az a szolgáltatás nyújtásához elengedhetetlen (pl. felhőszolgáltató, fizetési szolgáltató) vagy jogi kötelezettség teljesítéséhez szükséges. Minden esetben biztosítjuk a megfelelő garanciákat.',
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Az Ön jogai'),
                  const Text(
                    'Önnek lehetősége van kérelmezni a hozzáférést, helyesbítést, törlést ("elfeledtetéshez való jog"), korlátozást, adathordozhatóságot, valamint tiltakozhat az adatkezelés ellen.\n\n'
                    'Panaszával fordulhat a Nemzeti Adatvédelmi és Információszabadság Hatósághoz (NAIH) is.',
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Adattárolás'),
                  const Text(
                    'Az adatokat a felhasználói jogviszony fennállásáig tároljuk. A jogviszony megszűnését követően a jogi kötelezettségek (pl. számviteli) teljesítéséhez szükséges ideig őrizzük meg őket, majd véglegesen töröljük vagy anonimizáljuk.',
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          // Sticky Bottom Area
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: isAccepted
                    ? ElevatedButton.icon(
                        onPressed: null, // Disabled
                        icon: const Icon(Icons.check, color: Colors.green),
                        label: const Text(
                          'Elfogadva',
                          style: TextStyle(color: Colors.green),
                        ),
                        style: ElevatedButton.styleFrom(
                          disabledBackgroundColor: Colors.green.withValues(
                            alpha: 0.1,
                          ),
                          disabledForegroundColor: Colors.green,
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          ref
                              .read(privacyPolicyControllerProvider.notifier)
                              .acceptPolicy();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Elfogadom'),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
