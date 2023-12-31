# 1.3. Качество данных

## Оцените, насколько качественные данные хранятся в источнике.
Открывал в CloudBeaver каждую табличку и смотрел Columns\Constraints.
ТАкже смотрел первые данные. В таблице production\users будто бы логин и имя местами поменяны.

## Укажите, какие инструменты обеспечивают качество данных в источнике.
Ответ запишите в формате таблицы со следующими столбцами:
- `Наименование таблицы` - наименование таблицы, объект которой рассматриваете.
- `Объект` - Здесь укажите название объекта в таблице, на который применён инструмент. Например, здесь стоит перечислить поля таблицы, индексы и т.д.
- `Инструмент` - тип инструмента: первичный ключ, ограничение или что-то ещё.
- `Для чего используется` - здесь в свободной форме опишите, что инструмент делает.

Пример ответа:

| Таблицы             | Объект                      | Инструмент      | Для чего используется |
| ------------------- | --------------------------- | --------------- | --------------------- |
| production.Products | id int NOT NULL PRIMARY KEY | Первичный ключ  | Обеспечивает уникальность записей о продуктах |
| production.Products | [id, name, price] NOT NULL  | Constraint      | Обеспечивает ненулевость записей о продуктах |
| production.users    | [id, login ] NOT NULL  | Constraints      | Обеспечивает ненулевость записей о пользователях |
| production.users    | id int PRIMARY KEY  | первичный ключ      | Обеспечивает уникальность записей о пользователях |
| production.orderstatuslog    | iorderstatuslog_order_id_status_id_key | Unique Key      | Обеспечивает уникальность пар order\status |
| production.orderstatuses    | id | Primary Key      | Обеспечивает уникальность статусов |
| production.orders    | ((cost = (payment + bonus_payment)))  | Check      | Обеспечивает стоимость = оплате + бонусы |
| production.users    | [*] NOT NULL  | Constraints      | Обеспечивает ненулевость записей|
| production.productitems    | (((discount >= (0)::numeric) AND (discount <= price))) ((price >= (0)::numeric)) ((quantity > 0)) | Checks      | Обеспечивает качество записей|
