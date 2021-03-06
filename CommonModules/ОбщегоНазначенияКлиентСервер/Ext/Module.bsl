////////////////////////////////////////////////////////////////////////////////
//
//  Подсистема "Базовая функциональность".
//  Клиентские и серверные процедуры и функции общего назначения:
//  - для поддержки формирования печатных форм;
//  - для работы с файлами;
//  - для работы с управляемыми формами; 
//  - для работы с почтовыми адресами;
//  - для работы с отборами динамических списков;
//  - прочее.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Прочие функции
//

// Вызывает исключение с текстом Сообщение, если Условие не равно Истина.
// Применяется для самодиагностики кода.
//
// Параметры:
//   Условие                - Булево - если не равно Истина, то вызывается исключение.
//   КонтекстПроверки       - Строка - например, имя процедуры или функции, в которой выполняется проверка.
//   Сообщение              - Строка - текст сообщения. Если не задан, то исключение вызывается с сообщением по
//                                     умолчанию.
//
Процедура Проверить(Знач Условие, Знач Сообщение = "", Знач КонтекстПроверки = "") Экспорт
	
	Если Условие <> Истина Тогда
		Если ПустаяСтрока(Сообщение) Тогда
			ТекстИсключения = НСтр("ru = 'Недопустимая операция'"); // Assertion failed
		Иначе
			ТекстИсключения = Сообщение;
		КонецЕсли;
		Если Не ПустаяСтрока(КонтекстПроверки) Тогда
			ТекстИсключения = ТекстИсключения + " " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'в %1'"), КонтекстПроверки);
		КонецЕсли;
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
КонецПроцедуры
