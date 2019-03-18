dofile("conf.lua")

function OnInit()
    isConnect = isConnected()
    if isConnect == 1 then
        message("Подключение есть")
        drowTable()
    end
end


function main()
    while do_main do -- пока do_main = true выполняется цикл
        updateValueInTable()
        sleep(sleep_time) -- "сон"
    end
end


function drowTable()
    createTable()
    setValueTofirsColumn()
    updateValueInTable()
    -- установим цену закрытия
    for i = 0, #rows do -- получим значение для каждой бумаги
        -- обновим в таблице i-тую строку и 3-ю ячейку, полученым значением
        updateTableCellValue(tableLink, i, 3, getLastClose(rows[i]))
    end
end

function setValueTofirsColumn()
    for i = 0, #rows do
        updateTableCellValue(tableLink, i, 1, rows[i])
    end
end


function getLastClose(tiker)
    return tiker and math_round(tonumber(getParamEx(class_code, tiker, lastClose).param_value), 4) or 0
end


function updateValueInTable()
    for i = 0, #rows do -- получим значение для каждой бумаги
        -- обновим в таблице i-тую строку и 2-ю ячейку, полученым значением (счет ячеек начинаю с нуля)
        local newValue = getLastData(rows[i])
        updateTableCellValue(tableLink, i, 2,newValue )
        local oldValue = getLastClose(rows[i]) -- тут надо бы закешировать или сохранить гдето для оптимизации
        updateTableCellValue(tableLink, i, 4, getIncrementValue(oldValue, newValue))
        sleep(10)
    end

end

function getIncrementValue(oldValue, newValue)
    return math_round(newValue - oldValue, 2);
end


function math_round(roundIn, roundDig) -- функция округления, первый аргумент округляемое число, второй сколько знаков в дробной части
    local mul = math.pow(10, roundDig)
    return (math.floor((roundIn * mul) + 0.5) / mul)
end


function getLastData(tiker)
    return tiker and math_round(tonumber(getParamEx(class_code, tiker, indefParam).param_value), 4) or 0
end

function table_callback() -- коллбек, реагирует на действия с таблицей
    do_main = false
    if tableLink ~= nil then
        DestroyTable(tableLink) -- удаляем таблицу
    end
end

-- tableLink - id таблици (ссылка на таблицу)
-- iCode код параметра, выводимого в колонке,  - это порядковый номер в колонке слева на право
-- name Заголовок колонки - ее название,
-- par_type  это один из следующих типов
--QTABLE_INT_TYPE – целое число,
--QTABLE_DOUBLE_TYPE – число с плавающей точкой,
--QTABLE_INT64_TYPE – 64-битное целое число,
--QTABLE_CACHED_STRING_TYPE – кэшируемая строка,
--QTABLE_TIME_TYPE – время,
--QTABLE_DATE_TYPE – дата,
--QTABLE_STRING_TYPE – строка

--is_default этот параметр не используется должен быть тру
--width ширина колонки в условных еденицах

function addColumnToTable(tableLink, iCode, name, is_default, par_type, width)
    AddColumn(tableLink, iCode, name, is_default, par_type, width) -- создаем колонку
end


function addRowsTable()
    message(tostring(#rows))
    for i = 1, #rows do
        if i <= #rows then
            -- добавляет строку в таблицу и получает ее идентефикатор, минус 1 означает что в конец стека
            InsertRow(tableLink, -1)
        end
    end
end


function createTable()
    tableLink = AllocTable() -- создаем таблицу
    SetTableNotificationCallback(tableLink, table_callback) -- подписываемся на коллбек

    local widthSum = 0; -- посчитаем ширину таблицы и добавим колонки таблици
    for i = 0, #columns do
        if columns[i] then
            -- в нашем случае i это порядковый номер колонки
            addColumnToTable(tableLink, i, columns[i].title, true, QTABLE_STRING_TYPE, tonumber(columns[i].width));
            widthSum = widthSum + columns[i].width
        end
    end

    CreateWindow(tableLink) -- создаем окно таблицы
    SetWindowPos(tableLink, 0, 0, widthSum * 7, #rows * 25) -- задаем положение окна и его размеры
    SetWindowCaption(tableLink, titleTable) -- указать имя таблицы
    addRowsTable() -- добавляем строки таблици
    message("создана табилца" .. tostring(titleTable))
end


-- tableLink - id таблицы
-- rowLink - id, ключ, номер строки в таблице
-- code - это судя по всему порядковый номер ячейки в строке
-- value значение приведенное к строке
function updateTableCellValue(tableLink, rowLink, code, value)
    SetCell(tableLink, rowLink, code, tostring(value))
end
