dofile("conf.lua")
dofile("fileInfo.lua")
dofile("client-info.lua")
dofile("table-maker.lua")

oldValue = ""

file = FileConstructor:new(filename)
if file:fileExists() then
    oldValue = file:readFromFile()
else
    file:createFile()
end

-- file:log("Ќовый комментарий", true)

-- создадим клиента, чтобы получать данные по нему
message("clientCode " .. clientCode)
client = ClientInfo:new(clientCode, currency)

isConnect = isConnected()

function OnInit()
    if isConnect == 1 then
        message("ѕодключение есть")
        start()
    else
        message("ѕодключение нет!")
        start()
    end
end

function start()
    drowTable()
    moneyLimit = client.getManyLimitT2()
    file:log("Ћимит по деньгам = " .. moneyLimit)
end

function main()
    while do_main do -- пока do_main = true выполн€етс€ цикл
        updateValueInTable()
        sleep(sleep_time) -- "сон"
    end
end

function drowTable()
    table = TableMaker:new(titleTable, columns, rows)
    setValueTofirsColumn()
    updateValueInTable()
    -- установим цену закрыти€
    for i = 0, #rows do -- получим значение дл€ каждой бумаги
        -- обновим в таблице i-тую строку и 3-ю €чейку, полученым значением
        table.updateTableCellValue({}, i, 3, getLastClose(rows[i]))
    end
end

function setValueTofirsColumn()
    message("len" .. tostring(#rows))
    for i = 1, #rows do
        table.updateTableCellValue({}, i, 1, rows[i])
        message("lerows[i]" .. tostring(rows[i]))
    end
end

function getLastClose(tiker)
    return tiker and math_round(tonumber(getParamEx(class_code, tiker, lastClose).param_value), 4) or 0
end

function updateValueInTable()
    for i = 1, #rows do -- получим значение дл€ каждой бумаги
        local newValue = getLastData(rows[i])
        -- обновим в таблице i-тую строку и 2-ю €чейку, полученым значением (счет €чеек начинаю с нул€)
        -- первый аргумент св€зан как то с установкой метаданных, без него параметры прилетают пустые
        table.updateTableCellValue({}, i, 2, newValue)
        local oldValue = getLastClose(rows[i]) -- тут надо бы закешировать или сохранить гдето дл€ оптимизации
        table.updateTableCellValue({}, i, 4, getIncrementValue(oldValue, newValue))
        sleep(10)
    end
end

function getIncrementValue(oldValue, newValue)
    return math_round(newValue - oldValue, 2)
end

function math_round(roundIn, roundDig) -- функци€ округлени€, первый аргумент округл€емое число, второй сколько знаков в дробной части
    local mul = math.pow(10, roundDig)
    return (math.floor((roundIn * mul) + 0.5) / mul)
end

function getLastData(tiker)
    return tiker and math_round(tonumber(getParamEx(class_code, tiker, indefParam).param_value), 4) or 0
end
