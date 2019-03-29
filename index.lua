-- подключим библиотеку json
json = require "./vendors/json"

dofile("conf.lua")
dofile("fileInfo.lua")
dofile("client-info.lua")
dofile("table-maker.lua")

-- создадим файл для логов
oldValueLog = ""
fileLog = FileConstructor:new(fileLogName)
if fileLog:fileExists() then
    oldValue = fileLog:readFromFile()
else
    fileLog:createFile()
end

-- поищем файл с данными или если его нет сохраненными в момент инициализации
oldValueInfo = ""
oldValueInfoObj = {}

fileInfo = FileConstructor:new(fileInfoName)
if fileInfo:fileExists() then
    oldValueInfo = fileInfo:readFromFile()
    oldValueInfoObj = json.decode(oldValueInfo)
else
    fileInfo:createFile()
    message("создаю файл")
end

-- file:log("Новый комментарий", true)

-- создадим клиента, чтобы получать данные по нему
message("clientCode " .. clientCode)
client = ClientInfo:new(clientCode, currency)

isConnect = isConnected()

function OnInit()
    if isConnect == 1 then
        message("Подключение есть")
        start()
    else
        --start()
        message("Подключение нет!")
    end
end

function start()
    drowTable()
    moneyLimit = client.getManyLimitT2()
end

function main()
    while do_main do -- пока do_main = true выполняется цикл
        updateValueInTable()
        sleep(sleep_time) -- "сон"
    end
end

function drowTable()
    tables = TableMaker:new(titleTable, columns, rows)
    setValueTofirsColumn()
    updateValueInTable()
    -- подготовим данные для записи, если запускается первый раз
    mydataToconvert = {}
    -- установим цену закрытия
    for i = 1, #rows do -- получим значение для каждой бумаги
        -- обновим в таблице i-тую строку и 3-ю ячейку, полученым значением
        local res = getLastClose(rows[i])
        if #oldValueInfo == 0 then
            local val = tostring(res)
            local key = tostring(rows[i])
            table.insert(mydataToconvert, {[key] = val})
        end

        tables.updateTableCellValue({}, i, 3, res)
    end
    if #oldValueInfo == 0 then
        local text = json.encode(mydataToconvert)
        fileInfo.log({}, text)
    end
end

-- Формируем первый
function setValueTofirsColumn()
    for i = 1, #rows do
        tables.updateTableCellValue({}, i, 1, rows[i])
    end
end

function getLastClose(tiker)
    return tiker and math_round(tonumber(getParamEx(class_code, tiker, lastClose).param_value), 4) or 0
end

function updateValueInTable()
    for i = 1, #rows do -- получим значение для каждой бумаги
        local newValue = getLastData(rows[i])
        -- обновим в таблице i-тую строку и 2-ю ячейку, полученым значением (счет ячеек начинаю с нуля)
        -- первый аргумент связан как то с установкой метаданных, без него параметры прилетают пустые
        tables.updateTableCellValue({}, i, 2, newValue)

        local oldValue = 0
        if #oldValueInfo > 0 then
            oldValue = findMyVal(rows[i], oldValueInfoObj)
        end
        oldValue = oldValue and oldValue or getLastClose(rows[i])
        tables.updateTableCellValue({}, i, 4, getIncrementValue(oldValue, newValue))
        sleep(10)
    end
end

function findMyVal(key, arr)
    for i = 1, #arr do
        for k, value in pairs(arr[i]) do
            if k == key then
                return value
            end
        end
    end
end

-- пример тернарного оператора
-- s = condition and "on" or "off"

function getIncrementValue(oldValue, newValue)
    return math_round(newValue - oldValue, 2)
end

function math_round(roundIn, roundDig) -- функция округления, первый аргумент округляемое число, второй сколько знаков в дробной части
    local mul = math.pow(10, roundDig)
    return (math.floor((roundIn * mul) + 0.5) / mul)
end

function getLastData(tiker)
    return tiker and math_round(tonumber(getParamEx(class_code, tiker, indefParam).param_value), 4) or 0
end
