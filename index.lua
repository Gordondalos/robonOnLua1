dofile("conf.lua")

function OnInit()
    isConnect = isConnected()
    if isConnect == 1 then
        message("����������� ����")
        drowTable()
    end
end


function main()
    while do_main do -- ���� do_main = true ����������� ����
        updateValueInTable()
        sleep(sleep_time) -- "���"
    end
end


function drowTable()
    createTable()
    setValueTofirsColumn()
    updateValueInTable()
    -- ��������� ���� ��������
    for i = 0, #rows do -- ������� �������� ��� ������ ������
        -- ������� � ������� i-��� ������ � 3-� ������, ��������� ���������
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
    for i = 0, #rows do -- ������� �������� ��� ������ ������
        -- ������� � ������� i-��� ������ � 2-� ������, ��������� ��������� (���� ����� ������� � ����)
        local newValue = getLastData(rows[i])
        updateTableCellValue(tableLink, i, 2,newValue )
        local oldValue = getLastClose(rows[i]) -- ��� ���� �� ������������ ��� ��������� ����� ��� �����������
        updateTableCellValue(tableLink, i, 4, getIncrementValue(oldValue, newValue))
        sleep(10)
    end

end

function getIncrementValue(oldValue, newValue)
    return math_round(newValue - oldValue, 2);
end


function math_round(roundIn, roundDig) -- ������� ����������, ������ �������� ����������� �����, ������ ������� ������ � ������� �����
    local mul = math.pow(10, roundDig)
    return (math.floor((roundIn * mul) + 0.5) / mul)
end


function getLastData(tiker)
    return tiker and math_round(tonumber(getParamEx(class_code, tiker, indefParam).param_value), 4) or 0
end

function table_callback() -- �������, ��������� �� �������� � ��������
    do_main = false
    if tableLink ~= nil then
        DestroyTable(tableLink) -- ������� �������
    end
end

-- tableLink - id ������� (������ �� �������)
-- iCode ��� ���������, ���������� � �������,  - ��� ���������� ����� � ������� ����� �� �����
-- name ��������� ������� - �� ��������,
-- par_type  ��� ���� �� ��������� �����
--QTABLE_INT_TYPE � ����� �����,
--QTABLE_DOUBLE_TYPE � ����� � ��������� ������,
--QTABLE_INT64_TYPE � 64-������ ����� �����,
--QTABLE_CACHED_STRING_TYPE � ���������� ������,
--QTABLE_TIME_TYPE � �����,
--QTABLE_DATE_TYPE � ����,
--QTABLE_STRING_TYPE � ������

--is_default ���� �������� �� ������������ ������ ���� ���
--width ������ ������� � �������� ��������

function addColumnToTable(tableLink, iCode, name, is_default, par_type, width)
    AddColumn(tableLink, iCode, name, is_default, par_type, width) -- ������� �������
end


function addRowsTable()
    message(tostring(#rows))
    for i = 1, #rows do
        if i <= #rows then
            -- ��������� ������ � ������� � �������� �� �������������, ����� 1 �������� ��� � ����� �����
            InsertRow(tableLink, -1)
        end
    end
end


function createTable()
    tableLink = AllocTable() -- ������� �������
    SetTableNotificationCallback(tableLink, table_callback) -- ������������� �� �������

    local widthSum = 0; -- ��������� ������ ������� � ������� ������� �������
    for i = 0, #columns do
        if columns[i] then
            -- � ����� ������ i ��� ���������� ����� �������
            addColumnToTable(tableLink, i, columns[i].title, true, QTABLE_STRING_TYPE, tonumber(columns[i].width));
            widthSum = widthSum + columns[i].width
        end
    end

    CreateWindow(tableLink) -- ������� ���� �������
    SetWindowPos(tableLink, 0, 0, widthSum * 7, #rows * 25) -- ������ ��������� ���� � ��� �������
    SetWindowCaption(tableLink, titleTable) -- ������� ��� �������
    addRowsTable() -- ��������� ������ �������
    message("������� �������" .. tostring(titleTable))
end


-- tableLink - id �������
-- rowLink - id, ����, ����� ������ � �������
-- code - ��� ���� �� ����� ���������� ����� ������ � ������
-- value �������� ����������� � ������
function updateTableCellValue(tableLink, rowLink, code, value)
    SetCell(tableLink, rowLink, code, tostring(value))
end
