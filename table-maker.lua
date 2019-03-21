
TableMaker = {}
function TableMaker:new(tableName, tableColums, rows)
    local this = {}
    this.tableName = tableName
    this.tableColums = tableColums
    this.tableLink = nil
    this.rows = rows

    function this:createTable()
        this.tableLink = AllocTable() -- ������� �������
        SetTableNotificationCallback(this.tableLink, this.tableCallback)  -- ������������� �� �������

        local widthSum = 0 -- ��������� ������ ������� � ������� ������� �������
        for i = 0, #this.tableColums do
            if this.tableColums[i] then
                -- � ����� ������ i ��� ���������� ����� �������
                this:addColumnToTable(
                    this.tableLink,
                    i,
                    this.tableColums[i].title,
                    true,
                    QTABLE_STRING_TYPE,
                    tonumber(this.tableColums[i].width)
                )
                widthSum = widthSum + this.tableColums[i].width
            end
        end

        CreateWindow(this.tableLink) -- ������� ���� �������
        SetWindowPos(this.tableLink, 0, 0, widthSum * 7, #rows * 25) -- ������ ��������� ���� � ��� �������
        SetWindowCaption(this.tableLink, this.tableName) -- ������� ��� �������
        this:addRowsTable() -- ��������� ������ �������
        message("������� �������" .. tostring(this.tableName))
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
    function this:addColumnToTable(tableLink, iCode, name, is_default, par_type, width)
        AddColumn(tableLink, iCode, name, is_default, par_type, width) -- ������� �������
    end

    function this:addRowsTable()
        for i = 1, #this.rows do
            if i <= #this.rows then
                -- ��������� ������ � ������� � �������� �� �������������, ����� 1 �������� ��� � ����� �����
                InsertRow(this.tableLink, -1)
            end
        end
    end

    -- tableLink - id �������
    -- rowLink - id, ����, ����� ������ � �������
    -- code - ��� ���������� ����� ������ � ������
    -- value �������� ����������� � ������
    function this:updateTableCellValue(rowLink, code, value)
        SetCell(this.tableLink, rowLink, code, tostring(value))
    end

    function this:tableCallback() -- �������, ��������� �� �������� � ��������
        do_main = false
        if this.tableLink ~= nil then
            DestroyTable(this.tableLink) -- ������� �������
        end
    end

    this:createTable()
    --������ �����!
    setmetatable(this, self)
    self.__index = self  

    return this
end
