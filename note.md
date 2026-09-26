# Customer Cohort Analysis

## Məqsəd

Bu layihədə Brazilian E-Commerce dataset-i üzrə cohort analysis aparılıb. Müştərilər ilk alış etdikləri aya görə qruplaşdırılıb və sonrakı aylarda retention və revenue göstəriciləri analiz edilib.

## Görülən işlər

 Yalnız `delivered` statuslu sifarişlər analizə daxil edilib.
 `orders` və `customers` cədvəlləri `customer_id` ilə birləşdirilib.
 Müştəriləri düzgün izləmək üçün `customer_unique_id` istifadə edilib.
 Hər müştərinin ilk alış ayı cohort kimi müəyyən edilib.
 Aylıq `period_number` hesablanıb.
 Cohort size və retention rate SQL ilə hesablanıb.
`order_items.price` əsasında cohort və period üzrə revenue analiz edilib.
 Nəticələr qrafik və heatmap-lərlə vizuallaşdırılıb.

## Əsas nəticələr

 Analizdə 96,478 delivered order istifadə edilib.
 `order_items` ilə birləşmədən sonra 110,197 order-item sətri əldə edilib.
 Ümumi revenue 13,221,498.11 olub.
 Orta period-1 retention 5.45% təşkil edib.
 Məsələn, 2017-10 cohortunda period-1 retention 0.72%, 2017-09 cohortunda isə 0.70% olub.
 2017-11 cohortu period 0-da ən yüksək revenue nəticələrindən birini göstərib: 972,614.06.

## Insights

1. Period-1 retention-in 5.45% olması müştərilərin böyük hissəsinin ilk alışdan sonrakı ayda geri qayıtmadığını göstərir.

2. Böyük cohortlarda belə period-1 retention aşağı qalır. Bu, yeni müştərilərlə yanaşı repeat purchase davranışının da izlənməsinin vacibliyini göstərir.

3. Revenue əsasən period 0-da formalaşır. Sonrakı periodlarda aktiv müştəri sayı və revenue əhəmiyyətli dərəcədə azalır.

4. Bəzi sonrakı periodlarda aktiv müştəri sayı az olsa da, revenue per customer yüksək ola bilir. Buna görə retention ilə yanaşı müştəri başına revenue də nəzərə alınmalıdır.

## Vizualizasiyalar

 Cohort Size Chart
 Average Retention Curve
 Cohort Retention Rate Heatmap
 Customer Segmentation Chart

## Yekun

Cohort analysis nəticələri göstərir ki, ilk alışdan sonra müştəri retention səviyyəsi aşağıdır. Bu səbəbdən repeat purchase davranışının və cohortlar üzrə müştəri dəyərinin izlənməsi əsas analiz istiqamətlərindən biridir.
