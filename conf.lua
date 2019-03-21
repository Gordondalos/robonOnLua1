sleep_time = 10000
do_main = true
class_code = "SPBXM" -- класс бумаги
columnName = "V" -- код бумаги
titleTable = "“аблица приращений цены спроса к цене закрыти€"
table = nil
indefParam = 'OFFER'
lastClose = 'PREVPRICE'
filename = 'log.txt'
currency = 'USD'
clientCode = '10T13' -- чтобы узнать код клиента нужно открыть таблицу за€вок и создать за€вку,
--  там есть выпадающий список в нем можно вз€ть код клиента, также можно посмотреть код клиента в таблице позиции по деньгам

-- укажите ширину колонок
columns = {
    { ["title"] = "“икер", ["width"] = "20" },
    { ["title"] = "÷ена", ["width"] = "20" },
    { ["title"] = "÷ена закрыти€", ["width"] = "20" },
    { ["title"] = "ѕриращение", ["width"] = "30" },
}

-- укажите тикеры акций
rows = { "AAPL", "V", "BSX", "BABA", "BIDU", "BAC" }
