﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Серверные процедуры и функции общего назначения:
// - для работы с данными в базе;
// - для работы с прикладными типами и коллекциями значений;
// - математические процедуры и функции;
// - для работы с внешним соединением;
// - для работы с формами;
// - для работы с типами, объектами метаданных и их строковыми представлениями;
// - функции определения типов объектов метаданных;
// - сохранение, чтение и удаление настроек из хранилищ;
// - для работы с табличными документами;
// - для работы с журналом регистрации;
// - для работы в режиме разделения данных;
// - версионирование программных интерфейсов;
// - вспомогательные процедуры и функции.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для работы с хранилищем паролей.

// Записывает конфиденциальные данные в безопасное хранилище.
// Вызывающий код должен самостоятельно устанавливать привилегированный режим.
//
// Параметры:
//  Владелец - ПланОбменаСсылка, СправочникСсылка - ссылка на объект информационной базы,
//               представляющий объект-владелец сохраняемого пароля.
//               Для объектов других типов в качестве Владельца рекомендуется использовать ссылку на
//               элемент метаданных этого типа в справочнике ИдентификаторыОбъектовМетаданных.
//               Например, Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("РегистрСведений.АдресныеОбъекты");
//  Данные  - Произвольный - Данные помещаемые в безопасное хранилище. Неопределенно - удаляет данные.
//  Ключ    - Строка       - Ключ сохраняемых настроек, по умолчанию "Пароль".
//
Процедура ЗаписатьДанныеВБезопасноеХранилище(Владелец, Данные, Ключ = "Пароль") Экспорт
	
	ОбщегоНазначенияКлиентСервер.Проверить(ЗначениеЗаполнено(Владелец), 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Недопустимое значение параметра %1 в %2. 
		|параметр должен содержать ссылку; передано значение: %3 (тип %4).'"),
			"Владелец", "ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище", Владелец, ТипЗнч(Владелец)));
	
	ЭтоОбластьДанных = ОбщегоНазначенияПовтИсп.РазделениеВключено() И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных();
	Если ЭтоОбластьДанных Тогда
		БезопасноеХранилищеДанных = РегистрыСведений.БезопасноеХранилищеДанныхОбластейДанных.СоздатьМенеджерЗаписи();
	Иначе
		БезопасноеХранилищеДанных = РегистрыСведений.БезопасноеХранилищеДанных.СоздатьМенеджерЗаписи();
	КонецЕсли;
	
	Отбор = Новый Структура("Владелец", Владелец);
	БезопасноеХранилищеДанных.Владелец = Владелец;
	БезопасноеХранилищеДанных.Прочитать();
	Если Данные <> Неопределено Тогда
		Если БезопасноеХранилищеДанных.Выбран() Тогда
			ДанныеДляСохранения = БезопасноеХранилищеДанных.Данные.Получить();
			Если ТипЗнч(ДанныеДляСохранения) <> Тип("Структура") Тогда
				ДанныеДляСохранения = Новый Структура();
			КонецЕсли;
			ДанныеДляСохранения.Вставить(Ключ, Данные);
			ДанныеДляХранилищеЗначения = Новый ХранилищеЗначения(ДанныеДляСохранения, Новый СжатиеДанных(6));
			БезопасноеХранилищеДанных.Данные = ДанныеДляХранилищеЗначения;
			БезопасноеХранилищеДанных.Записать();
		Иначе
			ДанныеДляСохранения = Новый Структура(Ключ, Данные);
			ДанныеДляХранилищеЗначения = Новый ХранилищеЗначения(ДанныеДляСохранения, Новый СжатиеДанных(6));
			БезопасноеХранилищеДанных.Данные = ДанныеДляХранилищеЗначения;
			БезопасноеХранилищеДанных.Владелец = Владелец;
			БезопасноеХранилищеДанных.Записать();
		КонецЕсли;
	Иначе
		БезопасноеХранилищеДанных.Удалить();
	КонецЕсли;
	
КонецПроцедуры

// Возвращает данные из безопасного хранилища.
// Вызывающий код должен самостоятельно устанавливать привилегированный режим.
//
// Параметры:
//  Владелец    -  ПланОбменаСсылка, СправочникСсылка - ссылка на объект информационной базы,
//                            представляющий объект-владелец сохраняемого пароля.
//  Ключи       - Строка - Содержит список имен сохраненных данных, указанных через запятую.
//  ОбщиеДанные - Булево - Истина, если требуется в модели сервиса получить данные из общих данных в разделенном режиме.
// 
// Возвращаемое значение:
//  Произвольный, Структура - Данные из безопасного хранилища. Если указан один ключ,
//                            то возвращается его значение, иначе структура.
//                            Если данные отсутствуют - Неопределенно.
//
Функция ПрочитатьДанныеИзБезопасногоХранилища(Владелец, Ключи = "Пароль", ОбщиеДанные = Неопределено) Экспорт
	
	ОбщегоНазначенияКлиентСервер.Проверить(ЗначениеЗаполнено(Владелец), 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Недопустимое значение параметра %1 в %2. 
		|параметр должен содержать ссылку; передано значение: %3 (тип %4).'"),
			"Владелец", "ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища", Владелец, ТипЗнч(Владелец)));
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
			И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Если ОбщиеДанные = Истина Тогда
			ИмяБезопасноеХранилищеДанных = "БезопасноеХранилищеДанных";
		Иначе
			ИмяБезопасноеХранилищеДанных = "БезопасноеХранилищеДанныхОбластейДанных";
		КонецЕсли;
	Иначе
		ИмяБезопасноеХранилищеДанных = "БезопасноеХранилищеДанных";
		
	КонецЕсли;

	Результат = ДанныеИзБезопасногоХранилища(Владелец, ИмяБезопасноеХранилищеДанных, Ключи);
	
	Если Результат <> Неопределено И Результат.Количество() = 1 Тогда
		Возврат ?(Результат.Свойство(Ключи), Результат[Ключи], Неопределено);
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ДанныеИзБезопасногоХранилища(Владелец, ИмяБезопасноеХранилищеДанных, Ключ)
	
	Результат = Новый Структура(Ключ);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	БезопасноеХранилищеДанных.Данные КАК Данные
	|ИЗ
	|	РегистрСведений." + ИмяБезопасноеХранилищеДанных + " КАК БезопасноеХранилищеДанных
	|ГДЕ
	|	БезопасноеХранилищеДанных.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Владелец", Владелец);
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Если РезультатЗапроса.Следующий() Тогда
		Если ЗначениеЗаполнено(РезультатЗапроса.Данные) Тогда
			СохраненныеДанные = РезультатЗапроса.Данные.Получить();
			Если ЗначениеЗаполнено(СохраненныеДанные) Тогда
				ЗаполнитьЗначенияСвойств(Результат, СохраненныеДанные);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

