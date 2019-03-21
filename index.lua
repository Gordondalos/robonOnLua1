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

-- file:log("����� �����������", true)

-- �������� �������, ����� �������� ������ �� ����
message("clientCode " .. clientCode)
client = ClientInfo:new(clientCode, currency)

isConnect = isConnected()

function OnInit()
    if isConnect == 1 then
        message("����������� ����")
        start()
    else
        message("����������� ���!")
        start()
    end
end

function start()
    drowTable()
    moneyLimit = client.getManyLimitT2()
    file:log("����� �� ������� = " .. moneyLimit)
end

function main()
    while do_main do -- ���� do_main = true ����������� ����
        updateValueInTable()
        sleep(sleep_time) -- "���"
    end
end

function drowTable()
    table = TableMaker:new(titleTable, columns, rows)
    setValueTofirsColumn()
    updateValueInTable()
    -- ��������� ���� ��������
    for i = 0, #rows do -- ������� �������� ��� ������ ������
        -- ������� � ������� i-��� ������ � 3-� ������, ��������� ���������
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
    for i = 1, #rows do -- ������� �������� ��� ������ ������
        local newValue = getLastData(rows[i])
        -- ������� � ������� i-��� ������ � 2-� ������, ��������� ��������� (���� ����� ������� � ����)
        -- ������ �������� ������ ��� �� � ���������� ����������, ��� ���� ��������� ��������� ������
        table.updateTableCellValue({}, i, 2, newValue)
        local oldValue = getLastClose(rows[i]) -- ��� ���� �� ������������ ��� ��������� ����� ��� �����������
        table.updateTableCellValue({}, i, 4, getIncrementValue(oldValue, newValue))
        sleep(10)
    end
end

function getIncrementValue(oldValue, newValue)
    return math_round(newValue - oldValue, 2)
end

function math_round(roundIn, roundDig) -- ������� ����������, ������ �������� ����������� �����, ������ ������� ������ � ������� �����
    local mul = math.pow(10, roundDig)
    return (math.floor((roundIn * mul) + 0.5) / mul)
end

function getLastData(tiker)
    return tiker and math_round(tonumber(getParamEx(class_code, tiker, indefParam).param_value), 4) or 0
end
