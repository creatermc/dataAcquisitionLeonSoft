﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда 
		Объект.ТекстЗапроса = "{" + Символ(34) + "query" + Символ(34) + ": " + Символ(34) + "query {\n             }\n  " + Символ(34) + "}";
		Объект.ТипМодели = Перечисления.ТипМодели.ПустаяСсылка();
		ЭтаФорма.Элементы.ТипМодели.Доступность = Истина;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СформироватьЗапросНаСервере()

	Объект.ТекстЗапроса = "";
	Разделитель = ",";
	ПреносСтрокиКонсоль = "\n";
	СкрытьСимволКавычки = "\" + Символ(34);

	 Если СтрЧислоСтрок(Объект.ИсходныйТекстДляФормированияЗапроса) = 0 Тогда 
		 Возврат;
	 Иначе

		 Если СтрЧислоВхождений(Объект.ИсходныйТекстДляФормированияЗапроса, "{") <> СтрЧислоВхождений(Объект.ИсходныйТекстДляФормированияЗапроса, "}") Тогда
			 	Сообщить("Внимание! Количество открытых фигурных скобок неравно закрытых, проверьте текст запроса!");
			 Возврат; 
		 КонецЕсли;

		 Если СтрЧислоВхождений(Объект.ИсходныйТекстДляФормированияЗапроса, "(") <> СтрЧислоВхождений(Объект.ИсходныйТекстДляФормированияЗапроса, ")") Тогда
			 	Сообщить("Внимание! Количество открытых круглых скобок неравно закрытых, проверьте текст запроса!");
			 Возврат; 
		 КонецЕсли;

		 Если Объект.ТипМодели = Перечисления.ТипМодели.Query Тогда 
			 Объект.ТекстЗапроса = "{" + Символ(34) + "query" + Символ(34) + ": " + Символ(34) + "query {";
		 ИначеЕсли Объект.ТипМодели = Перечисления.ТипМодели.Mutation Тогда 
			 Объект.ТекстЗапроса = "{" + Символ(34) + "mutation" + Символ(34) + ": " + Символ(34) + "query {";
		 ИначеЕсли Объект.ТипМодели = Перечисления.ТипМодели.Subscription Тогда 
			 Объект.ТекстЗапроса = "{" + Символ(34) + "subscription" + Символ(34) + ": " + Символ(34) + "query {";
		 КонецЕсли;
	 КонецЕсли;

	    Для Индекс = 1 По СтрЧислоСтрок(Объект.ИсходныйТекстДляФормированияЗапроса) Цикл
	        ТекущCтрока = СтрПолучитьСтроку(Объект.ИсходныйТекстДляФормированияЗапроса, Индекс);
				Если ТекущCтрока = "{" Тогда // "{"
					Объект.ТекстЗапроса = Объект.ТекстЗапроса + " {" + ПреносСтрокиКонсоль;
				ИначеЕсли ТекущCтрока = "}" Тогда // "}"
					Объект.ТекстЗапроса = Объект.ТекстЗапроса + " }" + ПреносСтрокиКонсоль;
				ИначеЕсли Прав(ТекущCтрока, 1) = "{" Тогда  // "        {"
					Объект.ТекстЗапроса = Объект.ТекстЗапроса + " " + СокрЛП(ТекущCтрока) + ПреносСтрокиКонсоль;
				ИначеЕсли СтрНайти(ТекущCтрока, "{") = 0 И СтрНайти(СокрЛП(ТекущCтрока), "}") = 1 Тогда  //  "                }"
					Объект.ТекстЗапроса = Объект.ТекстЗапроса + " " + СокрЛП(ТекущCтрока) + ПреносСтрокиКонсоль;
				ИначеЕсли СтрНайти(СокрЛП(ТекущCтрока), "{") = 1 И СтрНайти(ТекущCтрока, "}") = 0 Тогда  //  " {              "
					Объект.ТекстЗапроса = Объект.ТекстЗапроса + " " + СокрЛП(ТекущCтрока) + ПреносСтрокиКонсоль;
				ИначеЕсли СтрНайти(ТекущCтрока, "{") > 0 И СтрНайти(СокрЛП(ТекущCтрока), "}") = 0 Тогда  	//  "  aircraftAvailability{     "
					Объект.ТекстЗапроса = Объект.ТекстЗапроса + " " + СокрЛП(СтрЗаменить(СокрЛП(ТекущCтрока), "{", "")) + ПреносСтрокиКонсоль + " {" + ПреносСтрокиКонсоль;
				ИначеЕсли СтрНайти(ТекущCтрока, "{") = 0 И СтрНайти(СокрЛП(ТекущCтрока), "}") > 0 Тогда  	//  "  name	 			}  "
					Объект.ТекстЗапроса = Объект.ТекстЗапроса + " " + СокрЛП(СтрЗаменить(СокрЛП(ТекущCтрока), "}", "")) + ПреносСтрокиКонсоль + " }" + ПреносСтрокиКонсоль;
				ИначеЕсли СтрНайти(ТекущCтрока, Разделитель) > 0 И СтрЧислоВхождений(ТекущCтрока, Символ(34)) = 0 И СтрНайти(ТекущCтрока, "{") = 0 И СтрНайти(ТекущCтрока, "}") = 0 Тогда // "       flightNo, "
					Объект.ТекстЗапроса = Объект.ТекстЗапроса + " " + СокрЛП(ТекущCтрока) + ПреносСтрокиКонсоль;
				ИначеЕсли СтрНайти(ТекущCтрока, Разделитель) > 0 И СтрЧислоВхождений(ТекущCтрока, Символ(34)) > 0 И СтрНайти(ТекущCтрока, "{") = 0 И СтрНайти(ТекущCтрока, "}") = 0  Тогда // "       			    startTime : "ДатаНачала", "
					Объект.ТекстЗапроса = Объект.ТекстЗапроса + " " + СтрЗаменить(СокрЛП(ТекущCтрока), Символ(34), СкрытьСимволКавычки) + ПреносСтрокиКонсоль;
				ИначеЕсли СтрЧислоВхождений(ТекущCтрока, Символ(34)) > 0 И СтрНайти(ТекущCтрока, "{") = 0 И СтрНайти(ТекущCтрока, "}") = 0 Тогда  //  "   emptyLegList(startTime: "firstDate")    "
					Объект.ТекстЗапроса = Объект.ТекстЗапроса + " " + СтрЗаменить(СокрЛП(ТекущCтрока), Символ(34), СкрытьСимволКавычки) + ПреносСтрокиКонсоль;
				ИначеЕсли СтрНайти(ТекущCтрока, "{") = 0 И СтрНайти(ТекущCтрока, "}") = 0 Тогда // "          aircraftAvailability   "
					Объект.ТекстЗапроса = Объект.ТекстЗапроса + " " + СокрЛП(ТекущCтрока);
				КонецЕсли;
	    КонецЦикла;
	
	Объект.ТекстЗапроса = Объект.ТекстЗапроса + " }" + ПреносСтрокиКонсоль + " " + Символ(34) + "}";

КонецПроцедуры

&НаКлиенте
Процедура СформироватьЗапрос(Команда)
	СформироватьЗапросНаСервере();
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТипМоделиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	ЭтаФорма.Элементы.ТипМодели.Доступность = Ложь;
		
	//	Если ВыбранноеЗначение = ПредопределенноеЗначение("Перечисление.ТипМодели.Query") Тогда 
	//		Объект.ИскходныйТекстДляФормированияЗапроса  = "query {";
	//	ИначеЕсли ВыбранноеЗначение = ПредопределенноеЗначение("Перечисление.ТипМодели.Mutation") Тогда
	//		Объект.ИскходныйТекстДляФормированияЗапроса  = "mutation {"; 
	//	ИначеЕсли ВыбранноеЗначение = ПредопределенноеЗначение("Перечисление.ТипМодели.Subscription") Тогда 
	//		Объект.ИскходныйТекстДляФормированияЗапроса  = "subscription {";	
	//	КонецЕсли;

	//Для СчСтрок = 1 По 16 Цикл
	//	Объект.ИскходныйТекстДляФормированияЗапроса = Объект.ИскходныйТекстДляФормированияЗапроса + Символы.ПС;
	//КонецЦикла;

	//Объект.ИскходныйТекстДляФормированияЗапроса = Объект.ИскходныйТекстДляФормированияЗапроса + "   }";

КонецПроцедуры

&НаКлиенте
Процедура ИскходныйТекстДляФормированияЗапросаПриИзменении(Элемент)

	Если Объект.ТипМодели = ПредопределенноеЗначение("Перечисление.ТипМодели.ПустаяСсылка") Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияПредупреждение", ЭтотОбъект);
		ПоказатьПредупреждение(Оповещение, "Перед вводом текста запроса, необходимо выбрать тип модели (CHEMA)! ", 0, "Внимание!");
		
		Объект.ИсходныйТекстДляФормированияЗапроса = "";
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияПредупреждение(Параметры) Экспорт
КонецПроцедуры

&НаСервере
Функция ТестЗапросаНаСервере()

	Если Объект.ТекстЗапроса = "" Или Объект.ВнешнийСервис = Справочники.ВнешниеСервисы.ПустаяСсылка() Тогда 
		Возврат "Не заполнены основные поля!";
	Иначе
		Возврат LeonSoftwareCommonModules.ПолучитьОтветНаЗапросЛеонСофт(Объект.ТекстЗапроса, Объект.ВнешнийСервис, Истина);
	КонецЕсли;

КонецФункции

&НаКлиенте
Процедура ТестЗапроса(Команда)

	предпроверка = "";
	РезультатЗапроса = ТестЗапросаНаСервере();

	Если ТипЗнч(РезультатЗапроса) = Тип("Соответствие") Тогда 		
		Если РезультатЗапроса.Получить("errors") = Неопределено Тогда
			Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияПредупреждение", ЭтотОбъект);
			ПоказатьПредупреждение(Оповещение, РезультатЗапроса.Получить("nformations"), 0, "Внимание!");
		Иначе
			предпроверка = РезультатЗапроса.Получить("errors");
			ВызватьИсключение РезультатЗапроса.Получить("errors");
		КонецЕсли;	
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ДобавитьВТекстЗапросаНаСервере()
	Возврат	ПроверитьПодчиненностьЭлемента(ЭтаФорма.Элементы.ЭлементыЗапроса.ТекущаяСтрока);
КонецФункции

&НаКлиенте
Процедура ДобавитьВТекстЗапроса(Команда)

	Если ЭтаФорма.Элементы.ЭлементыЗапроса.ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;

	Если ДобавитьВТекстЗапросаНаСервере() Тогда 
		Объект.ИсходныйТекстДляФормированияЗапроса = Объект.ИсходныйТекстДляФормированияЗапроса + 
		ЭтаФорма.Элементы.ЭлементыЗапроса.ТекущиеДанные.Наименование + Символы.ПС + Символы.Таб + "{" + Символы.ПС + Символы.ПС +  Символы.Таб + "}" + Символы.ПС;
	Иначе 
		Объект.ИсходныйТекстДляФормированияЗапроса = Объект.ИсходныйТекстДляФормированияЗапроса + ЭтаФорма.Элементы.ЭлементыЗапроса.ТекущиеДанные.Наименование;
	КонецЕсли;

	//ыв = ЭтаФорма.Элементы.ИскходныйТекстДляФормированияЗапроса.ПолучитьГраницыВыделения(1,1,100,1); //<НачалоСтроки>, <НачалоКолонки>, <КонецСтроки>, <КонецКолонки>)
	//Сообщить(Элементы.ИскходныйТекстДляФормированияЗапроса.ВыделенныйТекст = "");

КонецПроцедуры

&НаСервере
Функция ПроверитьПодчиненностьЭлемента(Родитель)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СписокЭлементовЗапроса.Представление КАК Представление
		|ИЗ
		|	Справочник.СписокЭлементовЗапроса КАК СписокЭлементовЗапроса
		|ГДЕ
		|	СписокЭлементовЗапроса.Родитель = &Родитель";
	Запрос.УстановитьПараметр("Родитель", Родитель);

	Если Запрос.Выполнить().Пустой() Тогда
		Возврат Ложь;
	Иначе 
		Возврат Истина;    
	КонецЕсли;

КонецФункции

&НаКлиенте
Процедура ОтобразитьСписокЭлементов(Команда)

	Если ЭтаФорма.Элементы.ГруппаЭлементыЗапроса.Видимость Тогда 
		ЭтаФорма.Элементы.ГруппаЭлементыЗапроса.Видимость = Ложь 
	Иначе 
		ЭтаФорма.Элементы.ГруппаЭлементыЗапроса.Видимость = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьИскходныйТекст(Команда)

	Если ЭтаФорма.Элементы.ГруппаИскходногоТекстаЗапроса.Видимость Тогда 
		ЭтаФорма.Элементы.ГруппаИскходногоТекстаЗапроса.Видимость = Ложь 
	Иначе 
		ЭтаФорма.Элементы.ГруппаИскходногоТекстаЗапроса.Видимость = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьГрафСхему(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияПредупреждение", ЭтотОбъект);
	ПоказатьПредупреждение(Оповещение, "Данный функционал находится в разработке! ", 0, "Внимание!");	

КонецПроцедуры
