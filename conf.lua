sleep_time = 10000
do_main = true
class_code = "SPBXM" -- ����� ������
columnName = "V" -- ��� ������
titleTable = "������� ���������� ���� ������ � ���� ��������"
tables = nil
indefParam = "OFFER"
lastClose = "PREVPRICE"
fileLogName = "log.txt"
fileInfoName = "info.json" -- ���� � ��������� �������
currency = "USD"
clientCode = "10T13" -- ����� ������ ��� ������� ����� ������� ������� ������ � ������� ������,
--  ��� ���� ���������� ������ � ��� ����� ����� ��� �������, ����� ����� ���������� ��� ������� � ������� ������� �� �������

-- ������� ������ �������
columns = {
    {["title"] = "�����", ["width"] = "20"},
    {["title"] = "����", ["width"] = "20"},
    {["title"] = "���� ������� �������", ["width"] = "23"},
    {["title"] = "����������", ["width"] = "30"}
}

-- ������� ������ �����
rows = {"AAPL", "V", "BSX", "BABA", "BIDU", "BAC"}
