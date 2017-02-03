#Использовать ".."
#Использовать asserts
#Использовать tempfiles

Перем юТест;
Перем УправлениеКонфигуратором;
Перем Лог;
Перем мВременнаяВыгрузка;
Перем СуффиксКТестам;

Процедура Инициализация()
	
	УправлениеКонфигуратором = Новый УправлениеКонфигуратором;
	
	Лог = Логирование.ПолучитьЛог("oscript.lib.v8runner");
	Лог.УстановитьУровень(УровниЛога.Отладка);
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ЭтоLinux = НЕ Найти(НРег(СистемнаяИнформация.ВерсияОС), "windows") > 0;

	СуффиксКТестам = "";
	
	УправлениеКонфигуратором.ИспользуемаяВерсияПлатформыСтаршеИлиРавна("8.3.10");
	
	Если ЭтоLinux Тогда
		УправлениеКонфигуратором.ИспользоватьВерсиюПлатформы("8.3.10");
	КонецЕсли;

	Если НЕ УправлениеКонфигуратором.ИспользуемаяВерсияПлатформыСтаршеИлиРавна("8.3.10") Тогда
		СуффиксКТестам = "Не_Найдена_Платформа_8_3_10_или_старше";
		возврат;
	Иначе
		
	КонецЕсли;
		
	ПодготовитьВременнуюВыгрузку();

КонецПроцедуры

Функция ПолучитьСписокТестов(Тестирование) Экспорт
	
	юТест = Тестирование;
	
	СписокТестов = Новый Массив;
		
	СписокТестов.Добавить("ТестДолжен_ВыгрузитьКонфигурациюВФайлы" + СуффиксКТестам);
    СписокТестов.Добавить("ТестДолжен_ВыгрузитьИзмененияКонфигурацииВФайл" + СуффиксКТестам);
		
	СписокТестов.Добавить("ТестДолжен_ВыгрузитьКонфигурациюВФайлыОтносительноФайлаВерсий" + СуффиксКТестам);
    СписокТестов.Добавить("ТестДолжен_ВыгрузитьИзмененияКонфигурацииВФайлОтносительноФайлаВерсий" + СуффиксКТестам);


	Возврат СписокТестов;
	
КонецФункции

Процедура ТестДолжен_ВыгрузитьКонфигурациюВФайлы() Экспорт

	ПутьФайлКонфигурации2 = ОбъединитьПути(ТекущийСценарий().Каталог, "fixtures", "1.0","1Cv8.cf");
		
	УправлениеКонфигуратором.ЗагрузитьКонфигурациюИзФайла(ПутьФайлКонфигурации2);
	
	УправлениеКонфигуратором.ВыгрузитьКонфигурациюВФайлы(мВременнаяВыгрузка,,Истина);

	МассивФайловВыгрузки = НайтиФайлы(мВременнаяВыгрузка,"*", Истина);
	
	ФайлВерсииКонфигурации = Новый Файл(ОбъединитьПути(мВременнаяВыгрузка, "ConfigDumpInfo.xml"));
	
	Лог.Информация("Количество файлов выгрузки: " + МассивФайловВыгрузки.Количество());
	
	Утверждения.ПроверитьРавенство(6, МассивФайловВыгрузки.Количество(), "Неверное количество файлов выгрузки. Ожидали число слева, а получили другое число выгруженных файлов");
	Утверждения.ПроверитьИстину(ФайлВерсииКонфигурации.Существует(), "Файл версии кофигурации должен существовать");

КонецПроцедуры

Процедура ТестДолжен_ВыгрузитьИзмененияКонфигурацииВФайл() 
	
КонецПроцедуры

Процедура ТестДолжен_ВыгрузитьКонфигурациюВФайлыОтносительноФайлаВерсий() 
	
КонецПроцедуры

Процедура ТестДолжен_ВыгрузитьИзмененияКонфигурацииВФайлОтносительноФайлаВерсий() 
	
КонецПроцедуры

Процедура ТестДолжен_ЗагрузитьКонфигурациюИзФайлов()
	
	
КонецПроцедуры


Процедура ПодготовитьВременнуюВыгрузку()
	
	Если ЗначениеЗаполнено(мВременнаяВыгрузка) Тогда
		Возврат;
	КонецЕсли; 

	ВременныйКаталог = ВременныеФайлы.СоздатьКаталог();

	УправлениеКонфигуратором.КаталогСборки(ВременныйКаталог);
	
	КаталогВыгрузки = ОбъединитьПути(ВременныйКаталог, "v8r_TempDitr");
	
	ПутьФайлКонфигурации = ОбъединитьПути(ТекущийСценарий().Каталог, "fixtures", "0.9","1Cv8.cf");
	
	УправлениеКонфигуратором.ЗагрузитьКонфигурациюИзФайла(ПутьФайлКонфигурации);
	
	УправлениеКонфигуратором.ВыгрузитьКонфигурациюВФайлы(КаталогВыгрузки);

	МассивФайловВыгрузки = НайтиФайлы(КаталогВыгрузки,"*", Истина);
		
	мВременнаяВыгрузка = КаталогВыгрузки;

	
КонецПроцедуры

/////////////////////////////////////////////////////////////////////////////////////
// Инициализация


Инициализация();