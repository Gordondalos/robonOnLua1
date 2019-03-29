-- ��������� ���������� json
json = require "./vendors/json"

dofile("conf.lua")
dofile("fileInfo.lua")
dofile("client-info.lua")
dofile("table-maker.lua")

-- �������� ���� ��� �����
oldValueLog = ""
fileLog = FileConstructor:new(fileLogName)
if fileLog:fileExists() then
    oldValue = fileLog:readFromFile()
else
    fileLog:createFile()
end

-- ������ ���� � ������� ��� ���� ��� ��� ������������ � ������ �������������
oldValueInfo = ""
oldValueInfoObj = {}

fileInfo = FileConstructor:new(fileInfoName)
if fileInfo:fileExists() then
    oldValueInfo = fileInfo:readFromFile()
    oldValueInfoObj = json.decode(oldValueInfo)
else
    fileInfo:createFile()
    message("������ ����")
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
        --start()
        message("����������� ���!")
    end
end

function start()
    drowTable()
    moneyLimit = client.getManyLimitT2()
end

function main()
    while do_main do -- ���� do_main = true ����������� ����
        updateValueInTable()
        sleep(sleep_time) -- "���"
    end
end

function drowTable()
    tables = TableMaker:new(titleTable, columns, rows)
    setValueTofirsColumn()
    updateValueInTable()
    -- ���������� ������ ��� ������, ���� ����������� ������ ���
    mydataToconvert = {}
    -- ��������� ���� ��������
    for i = 1, #rows do -- ������� �������� ��� ������ ������
        -- ������� � ������� i-��� ������ � 3-� ������, ��������� ���������
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

-- ��������� ������
function setValueTofirsColumn()
    for i = 1, #rows do
        tables.updateTableCellValue({}, i, 1, rows[i])
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

-- ������ ���������� ���������
-- s = condition and "on" or "off"

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
