
TableMaker = {}
function TableMaker:new(tableName, tableColums, rows)
    local this = {}
    this.tableName = tableName
    this.tableColums = tableColums
    this.tableLink = nil
    this.rows = rows

    function this:createTable()
        this.tableLink = AllocTable() -- создаем таблицу
        SetTableNotificationCallback(this.tableLink, this.tableCallback)  -- подписываемся на коллбек

        local widthSum = 0 -- посчитаем ширину таблицы и добавим колонки таблици
        for i = 0, #this.tableColums do
            if this.tableColums[i] then
                -- в нашем случае i это порядковый номер колонки
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

        CreateWindow(this.tableLink) -- создаем окно таблицы
        SetWindowPos(this.tableLink, 0, 0, widthSum * 7, #rows * 25) -- задаем положение окна и его размеры
        SetWindowCaption(this.tableLink, this.tableName) -- указать имя таблицы
        this:addRowsTable() -- добавляем строки таблици
        message("создана табилца" .. tostring(this.tableName))
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
    function this:addColumnToTable(tableLink, iCode, name, is_default, par_type, width)
        AddColumn(tableLink, iCode, name, is_default, par_type, width) -- создаем колонку
    end

    function this:addRowsTable()
        for i = 1, #this.rows do
            if i <= #this.rows then
                -- добавляет строку в таблицу и получает ее идентефикатор, минус 1 означает что в конец стека
                InsertRow(this.tableLink, -1)
            end
        end
    end

    -- tableLink - id таблицы
    -- rowLink - id, ключ, номер строки в таблице
    -- code - это порядковый номер ячейки в строке
    -- value значение приведенное к строке
    function this:updateTableCellValue(rowLink, code, value)
        SetCell(this.tableLink, rowLink, code, tostring(value))
    end

    function this:tableCallback() -- коллбек, реагирует на действия с таблицей
        do_main = false
        if this.tableLink ~= nil then
            DestroyTable(this.tableLink) -- удаляем таблицу
        end
    end

    this:createTable()
    --чистая магия!
    setmetatable(this, self)
    self.__index = self  

    return this
end
