# CSV Süreç Madenciliği ve Dosya Analiz Uygulaması

Bu uygulama, CSV dosyalarını kullanarak süreç madenciliği analizi yapmanıza olanak sağlayan bir Flutter uygulamasıdır.


## 📱 Uygulama Kullanımı

1. Uygulamayı başlatın
2. CSV dosyanızı seçin
4. Analizi başlatın
5. Aşağıdaki analiz sonuçlarını ve raporları inceleyin:

### 📊 Sunulan Analiz Sonuçları

1. **Süreç Akış Diyagramı**
   - Süreçlerin görsel akış şeması
   - Aktiviteler arası geçişlerin görselleştirilmesi
   - Süreç adımları arasındaki ilişkilerin detaylı gösterimi

2. **Aktivite Frekans Analizi**
   - Her bir aktivitenin gerçekleşme sıklığı
   - Aktivite bazlı istatistiksel veriler
   - En sık ve en az gerçekleşen aktivitelerin görselleştirilmesi

3. **Geçiş Frekans Analizi**
   - Aktiviteler arası geçiş sıklıkları
   - Süreç yollarının kullanım oranları

4. **Detaylı Bilgi Kartları**
   - Süreç performans metrikleri
   - Özet istatistikler

5. **Genişletilebilir Liste Görünümleri**
   - Detaylı süreç adımları
   - Alt süreçlerin incelenmesi
   - Hiyerarşik süreç yapısı

6. **Özelleştirilmiş Neumorphic Arayüz**
   - Modern ve kullanıcı dostu tasarım
   - Kolay navigasyon
   - İnteraktif veri görselleştirme

### 📈 Rapor Özellikleri
- Tüm analizler interaktif grafikler ile sunulmaktadır
- Detaylı filtreleme ve arama özellikleri
- Veri görselleştirme seçenekleri
- Özelleştirilebilir görünüm seçenekleri

## 🛠️ Teknik Özellikler

* Flutter framework kullanılarak geliştirilmiştir
* Clean Architecture prensiplerine uygun olarak tasarlanmıştır
* Süreç madenciliği algoritmaları entegre edilmiştir
* CSV dosya işleme ve analiz yetenekleri

## 📁 Proje Yapısı

```
lib/
├── core/         # Temel utility ve sabitler
├── data/         # Veri katmanı
├── domain/       # İş mantığı katmanı
├── presentation/ # UI katmanı
└── main.dart     # Uygulama giriş noktası
```

## 📝 Notlar

* CSV dosyalarınızın UTF-8 formatında olduğundan emin olun
* Büyük dosyalar için işlem süresi uzayabilir
