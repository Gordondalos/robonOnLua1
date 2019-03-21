ClientInfo = {}
function ClientInfo:new(clientCode, currency)
  local this = {}
  this.clientCode = clientCode
  this.currency = currency
  this.moneyLimit = 0

  -- ������� ������ ������� ������� �� �������
  function this:getManyLimitT2()
    -- ������� ���������� ���������� ������� � ������� �TableName�.
    -- NUMBER getNumberOf(STRING TableName)
    local n = getNumberOf("money_limits") -- ������� - ������� �� �������
    for i = 0, n - 1 do
      -- ������� ���������� ������� Lua, ���������� ���������� � ������ �� ������ � ������� �Index� �� ������� � ������ �TableName�.
      -- TABLE getItem (STRING TableName, NUMBER Index)

      local manyLimitRow = getItem("money_limits", i)

      -- clientCode - ��� �������
      -- currcode - ��� ������
      -- limit_kind - ��������� �������� �0, �1, �2
      -- currentbal - ������� �������
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

  --������ �����!
  setmetatable(this, self)
  self.__index = self
  return this
end
