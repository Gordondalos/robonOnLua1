sleep_time = 10000
do_main = true
class_code = "SPBXM" -- класс бумаги
columnName = "V" -- код бумаги
titleTable = "Таблица приращений цены спроса к цене закрытия"
tableLink = nil
indefParam = 'OFFER'
lastClose = 'PREVPRICE'

-- укажите ширину колонок
columns = {
    { ["title"] = "Тикер", ["width"] = "20" },
    { ["title"] = "Цена", ["width"] = "20" },
    { ["title"] = "Цена закрытия", ["width"] = "20" },
    { ["title"] = "Приращение", ["width"] = "30" },
}

-- укажите тикеры акций
rows = { "AAPL", "V", "BSX", "BABA", "BIDU", "BAC" }
