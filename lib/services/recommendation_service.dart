class RecommendationService {
  /// 1. KONU ANLATIMI FİLTRESİ (Mevcut yapın - Hiç dokunulmadı)
  static List<String> getRecommendedMaterials(String style, String disability) {
    // 1. GÖRSEL ÖĞRENME STİLİ
    if (style == 'Görsel Öğrenme') {
      if (disability == 'Görme Engeli') return ['podcast']; 
      if (disability == 'İşitsel Engeli') return ['pdf'];  
      if (disability == 'Fiziksel Engel') return ['video', 'pdf'];
      if (disability == 'Dikkat Eksikliği / Hiperaktivite') return ['video', 'pdf']; 
      if (disability == 'Öğrenme Güçlüğü') return ['video', 'pdf'];
    }
    // 2. İŞİTSEL ÖĞRENME STİLİ
    if (style == 'İşitsel Öğrenme') {
      if (disability == 'Görme Engeli') return ['podcast'];
      if (disability == 'İşitsel Engeli') return ['pdf']; 
      if (disability == 'Fiziksel Engel') return ['podcast', 'pdf'];
      if (disability == 'Dikkat Eksikliği / Hiperaktivite') return ['podcast', 'pdf'];
      if (disability == 'Öğrenme Güçlüğü') return ['podcast', 'pdf'];
    }
    // 3. KİNESTETİK ÖĞRENME STİLİ
    if (style == 'Kinestetik Öğrenme') {
      if (disability == 'Görme Engeli') return ['podcast'];
      if (disability == 'İşitsel Engeli') return ['pdf']; 
      if (disability == 'Fiziksel Engel') return ['pdf', 'podcast'];
      if (disability == 'Dikkat Eksikliği / Hiperaktivite') return ['video', 'podcast'];
      if (disability == 'Öğrenme Güçlüğü') return ['pdf', 'podcast'];
    }
    // 4. SÖZEL ÖĞRENME STİLİ
    if (style == 'Sözel Öğrenme') {
      if (disability == 'Görme Engeli') return ['podcast'];
      if (disability == 'İşitsel Engeli') return ['pdf']; 
      if (disability == 'Fiziksel Engel') return ['podcast', 'pdf'];
      if (disability == 'Dikkat Eksikliği / Hiperaktivite') return ['pdf', 'podcast'];
      if (disability == 'Öğrenme Güçlüğü') return ['pdf', 'podcast'];
    }
    // 5. MANTIKSAL ÖĞRENME STİLİ
    if (style == 'Mantıksal Öğrenme') {
      if (disability == 'Görme Engeli') return ['podcast'];
      if (disability == 'İşitsel Engeli') return ['pdf']; 
      if (disability == 'Fiziksel Engel') return ['pdf', 'podcast'];
      if (disability == 'Dikkat Eksikliği / Hiperaktivite') return ['video', 'pdf'];
      if (disability == 'Öğrenme Güçlüğü') return ['pdf', 'podcast'];
    }
    return ['pdf', 'video', 'podcast'];
  }

  /// 2. SORU BANKASI KOMBİNASYON FİLTRESİ (Senin istediğin özel yapı)
  /// Bu metod, stil ve engel kombinasyonuna göre Firestore filtrelerini belirler.
  static Map<String, dynamic> getTestFilters(String style, String disability) {
    
    // 1. GÖRSEL ÖĞRENME STİLİ KOMBİNASYONLARI
    if (style == 'Görsel Öğrenme') {
      if (disability == 'Görme Engeli') return {'difficulty': 'orta', 'isVisual': false};
      if (disability == 'İşitsel Engeli') return {'difficulty': 'orta', 'isVisual': true};
      if (disability == 'Fiziksel Engel') return {'difficulty': 'orta', 'isVisual': true};
      if (disability == 'Dikkat Eksikliği / Hiperaktivite') return {'difficulty': 'kolay', 'isVisual': true, 'limit': 2};
      if (disability == 'Öğrenme Güçlüğü') return {'difficulty': 'kolay', 'isVisual': true};
    }

    // 2. İŞİTSEL ÖĞRENME STİLİ KOMBİNASYONLARI
    if (style == 'İşitsel Öğrenme') {
      if (disability == 'Görme Engeli') return {'difficulty': 'orta', 'isVisual': false};
      if (disability == 'İşitsel Engeli') return {'difficulty': 'orta', 'isVisual': false};
      if (disability == 'Fiziksel Engel') return {'difficulty': 'orta', 'isVisual': false};
      if (disability == 'Dikkat Eksikliği / Hiperaktivite') return {'difficulty': 'kolay', 'isVisual': false, 'limit': 2};
      if (disability == 'Öğrenme Güçlüğü') return {'difficulty': 'kolay', 'isVisual': false};
    }

    // 3. KİNESTETİK ÖĞRENME STİLİ KOMBİNASYONLARI
    if (style == 'Kinestetik Öğrenme') {
      if (disability == 'Görme Engeli') return {'difficulty': 'orta', 'isVisual': false};
      if (disability == 'İşitsel Engeli') return {'difficulty': 'orta', 'isVisual': true};
      if (disability == 'Fiziksel Engel') return {'difficulty': 'orta', 'isVisual': false};
      if (disability == 'Dikkat Eksikliği / Hiperaktivite') return {'difficulty': 'kolay', 'isVisual': true, 'limit': 2};
      if (disability == 'Öğrenme Güçlüğü') return {'difficulty': 'kolay', 'isVisual': false};
    }

    // 4. SÖZEL ÖĞRENME STİLİ KOMBİNASYONLARI
    if (style == 'Sözel Öğrenme') {
      if (disability == 'Görme Engeli') return {'difficulty': 'orta', 'isVisual': false};
      if (disability == 'İşitsel Engeli') return {'difficulty': 'orta', 'isVisual': false};
      if (disability == 'Fiziksel Engel') return {'difficulty': 'orta', 'isVisual': false};
      if (disability == 'Dikkat Eksikliği / Hiperaktivite') return {'difficulty': 'kolay', 'isVisual': false, 'limit': 3};
      if (disability == 'Öğrenme Güçlüğü') return {'difficulty': 'kolay', 'isVisual': false};
    }

    // 5. MANTIKSAL ÖĞRENME STİLİ KOMBİNASYONLARI
    if (style == 'Mantıksal Öğrenme') {
      if (disability == 'Görme Engeli') return {'difficulty': 'orta', 'isVisual': false};
      if (disability == 'İşitsel Engeli') return {'difficulty': 'orta', 'isVisual': true};
      if (disability == 'Fiziksel Engel') return {'difficulty': 'orta', 'isVisual': false};
      if (disability == 'Dikkat Eksikliği / Hiperaktivite') return {'difficulty': 'kolay', 'isVisual': false, 'limit': 2};
      if (disability == 'Öğrenme Güçlüğü') return {'difficulty': 'kolay', 'isVisual': true};
    }

    // Varsayılan (Fallback)
    return {'difficulty': 'orta', 'isVisual': false};
  }
}