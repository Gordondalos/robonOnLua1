ClientInfo = {}
function ClientInfo:new(clientCode, currency)
  local this = {}
  this.clientCode = clientCode
  this.currency = currency
  this.moneyLimit = 0

  -- функция вернет Текущий остаток по деньгам
  function this:getManyLimitT2()
    -- Функция возвращает количество записей в таблице «TableName».
    -- NUMBER getNumberOf(STRING TableName)
    local n = getNumberOf("money_limits") -- таблица - Позиции по деньгам
    for i = 0, n - 1 do
      -- Функция возвращает таблицу Lua, содержащую информацию о данных из строки с номером «Index» из таблицы с именем «TableName».
      -- TABLE getItem (STRING TableName, NUMBER Index)

      local manyLimitRow = getItem("money_limits", i)

      -- clientCode - код клиента
      -- currcode - Код валюты
      -- limit_kind - Временной интервал Т0, Т1, Т2
      -- currentbal - Текущий остаток
      if
        manyLimitRow.client_code  == this.clientCode and manyLimitRow.currcode == this.currency and
          manyLimitRow.limit_kind == 2 and
          manyLimitRow.currentbal
       then
        return tonumber(manyLimitRow.currentbal)
      end
    end
    return 0
  end

  --чистая магия!
  setmetatable(this, self)
  self.__index = self
  return this
end
