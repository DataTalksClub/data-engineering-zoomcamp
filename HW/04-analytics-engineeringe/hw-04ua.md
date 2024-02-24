## Module 4 Homework 

У цьому домашньому завданні використовуємо моделі, розроблені протягом відео 4-го тижня, та покращимо вже презентований dbt проект,
використовуючи завантажені у наше сховище даних про таксі для таксомоторних підприємств (fhv) за 2019 рік.

Отже, у цьому завданні використовуємо такі дані:  [Datasets list](https://github.com/DataTalksClub/nyc-tlc-data/)
* Дані про жовті таксі - 2019 та 2020 роки
* Дані про зелені таксі - 2019 та 2020 роки
* Дані прокату fhv - 2019 рік.

Використовуватимемо завантажені дані для:

* Створення первинної таблиці: `stg_fhv_tripdata`
* Створення таблиці фактів: `fact_fhv_trips`
* Створення інформаційної панелі (dashboard) 

Якщо у вас немає доступу до GCP, ви можете виконати ці дії локально, використовуючи дані у своїй базі даних Postgres.
Якщо ж доступ до GCP ви маєте, вам не потрібно виконувати дії з Postgres - тільки якщо з’являється конкретне бажання.

> **Примітка**: якщо ваша відповідь необов’язково буде точно такою ж, виберіть найближчий варіант.
> 
### Question 1: 
**
**Що стається, коли ми виконуємо команду dbt build --vars '{'is_test_run':'true'}'?**
You'll need to have completed the ["Build the first dbt models"](https://www.youtube.com/watch?v=UVI30Vxzd6c) video. 

- Команда має такий же ефект, як і виконання *dbt build*
- Команда додає обмеження _limit 100_ до всіх наших моделей
- Команда додає обмеження _limit 100_ лише до проміжних (staging) моделей
- Нічого з переліченого

### Question 2: 

**Який код запускатиме наше CI (continuous integration) завдання**  

- Код, розміщений на головній гілці (main)
- Код, який відповідає об'єкту схеми dbt_cloud_pr_
- Код з будь-якої гілки розробки, створеної на основі main
- Код з гілки розробки, для якої створено запит на злиття з гілкою main

### Питання 3:

**Якою буде кількість записів у моделі fact_fhv_trips після запуску всіх залежностей, коли тестова змінна вимкнена (:false)?**  

Створіть проміжну (staging) модель для даних fhv, схожу на вже створені для жовтих та зелених таксі. Додайте фільтр, який залишатиме лише записи з часом взяття пасажира у 2019 році.
Не додавайте крок дедуплікації. Запускайте ці моделі без обмежень (is_test_run: false).

Створіть основну (core) модель, подібну до fact trips, але вона має вибирати дані з stg_fhv_tripdata та виконувати об’єднання (join) з dim_zones.
Як ми зробили у fact_trips, залишіть лише записи з відомими пунктами взяття (pickup) та висадки (dropoff) пасажирів.
Запустіть модель dbt без обмежень (is_test_run: false).

- 12998722
- 22998722
- 32998722
- 42998722

### Question 4: 

**What is the service that had the most rides during the month of July 2019 month with the biggest amount of rides after building a tile for the fact_fhv_trips table?**

Create a dashboard with some tiles that you find interesting to explore the data. One tile should show the amount of trips per month, as done in the videos for fact_trips, including the fact_fhv_trips data.

- FHV
- Green
- Yellow
- FHV and Green


## Submitting the solutions

* Form for submitting: [TO DO]
* You can submit your homework multiple times. In this case, only the last submission will be used. 

Deadline: 22 February (Thursday), 22:00 CET


## Solution (To be published after deadline)

* Video: 
* Answers:
  * Question 1: 
  * Question 2: 
  * Question 3: 
  * Question 4: 
  * Question 5: 
