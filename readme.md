# Помощник выполнения команд Конфигуратора (v8runner.os)

## Назначение

Скрипт v8runner.os предназначен для инкапсуляции запуска команд Конфигуратора и 1С:Предприятия с помощью командной строки.

Как правило, запуск той или иной команды конфигуратора в автоматическом режиме достаточно сложен. Нужно помнить синтаксис каждой команды, постоянно сверяться со справкой, обрабатывать выходные сообщения Конфигуратора и т.п.

Скрипт v8runner упрощает эти задачи и позволяет запускать Конфигуратор программно, в объектной манере.

## Принцип работы

Скрипт подключается, как отдельный класс и экземпляр этого класса используется для манипулирования какой-то одной информационной базой.

```bsl
#Использовать v8runner
Конфигуратор = Новый УправлениеКонфигуратором();
```

Каждая команда конфигуратора может выполняться только для конкретной информационной базы. База, для которой выполняется команда называется контекстом команды.

Контекст указывается в формате **параметра командной строки конфигуратора** - так, как в Конфигураторе задается нужная информационная база. Например, для формата строки соединения:

```bsl
Конфигуратор.УстановитьКонтекст("/IBConnectionString""Srvr=someserver:2041; Ref='database'""","Admin", "passw0rd");
```

В более простой форме - для файловой базы можно указать через ключ ```/S```:

```bsl
Конфигуратор.УстановитьКонтекст("/FC:\1cdb\mydatabase","Admin", "passw0rd");
```

Далее, вы вызываете методы объекта "Конфигуратор", соответствующие командам конфигуратора. Все команды будут выполняться над заданной базой. Теперь, объект Конфигуратор настроен на некий *"контекст"* - информационную базу, с которой и будут производиться все операции.

### Временный контекст

Если контекст явно не задан, то автоматически будет создана временная ИБ. Например, если для какого-то действия достаточно временной базы, то контекст можно не указывать.

```bsl
Конфигуратор = Новый УправлениеКонфигуратором();
Конфигуратор.ЗагрузитьКонфигурациюИзФайла("C:\source.cf");
Конфигуратор.ВыполнитьСинтаксическийКонтроль();

// удаление временной базы
УдалитьФайлы(Конфигуратор.ПутьКВременнойБазе());
```

В приведенном примере файл C:\source.cf будет загружен в автоматически созданную временную базу. После чего будет выполнен полный синтаксический контроль конфигурации.

## Параметры запуска

В обращении к Конфигуратору используется понятие "Параметров запуска". Это массив параметров командной строки для платформы 1С. Перед запуском платформы v8runner автоматически составит из этого массива командную строку платформы.

```bsl
УправлениеКонфигуратором = Новый УправлениеКонфигуратором();

// в ПараметрахЗапуска уже добавлены ключи DESIGNER, строка соединения с ИБ, пользователь и пароль
ПараметрыЗапуска = УправлениеКонфигуратором.ПолучитьПараметрыЗапуска();
ПараметрыЗапуска.Добавить("/LoadCfg""C:\source.cf"""); 

Попытка
    УправлениеКонфигуратором.ВыполнитьКоманду(ПараметрыЗапуска);
Исключение
    // вывод log-файла с сообщениями от платформы.
    Сообщить(УправлениеКонфигуратором.ВыводКоманды());
КонецПопытки
```

## Методы класса v8runner

### Основные функции

- Процедура УстановитьКонтекст(Знач СтрокаСоединения, Знач Пользователь, Знач Пароль) 
- Функция ПолучитьКонтекст()
- Процедура ИспользоватьКонтекст(Знач Контекст) 
- Функция ПолучитьВерсиюИзХранилища(Знач СтрокаСоединения, Знач ПользовательХранилища, Знач ПарольХранилища, Знач НомерВерсии = Неопределено) 
- ОтключитьсяОтХранилища()
- Процедура ЗагрузитьКонфигурациюИзФайла(Знач ФайлКонфигурации, Знач ОбновитьКонфигурациюИБ = Ложь)
- Процедура ОбновитьКонфигурациюБазыДанных()
- Процедура ОбновитьКонфигурацию(Знач КаталогВерсии, Знач ИспользоватьПолныйДистрибутив = Ложь)
- Процедура СоздатьФайловуюБазу(Знач КаталогБазы)
- Процедура ВыполнитьКоманду(Знач Параметры)
- Функция ПолучитьПараметрыЗапуска()
- Процедура ВыполнитьСинтаксическийКонтроль(ТонкийКлиент = Истина, ВебКлиент = Истина, Сервер = Истина, ВнешнееСоединение = Истина, ТолстыйКлиентОбычноеПриложение = Истина)
- Функция ПутьКВременнойБазе()

### Вспомогательные и настроечные функции

- Функция ПолучитьПутьКВерсииПлатформы(Знач ВерсияПлатформы)
- Процедура УстановитьКлючРазрешенияЗапуска(Знач Ключ)
- Функция ВыводКоманды()
- Функция КаталогСборки(Знач Каталог = "")
- Функция ПутьКПлатформе1С(Знач Путь = "")
- Процедура УстановитьКодЯзыка(Знач КодЯзыка)
- Процедура УстановитьКодЯзыкаСеанса(Знач КодЯзыкаСеанса)