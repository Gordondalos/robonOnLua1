sleep_time = 10000
do_main = true
class_code = "SPBXM" -- ����� ������
columnName = "V" -- ��� ������
titleTable = "������� ���������� ���� ������ � ���� ��������"
table = nil
indefParam = 'OFFER'
lastClose = 'PREVPRICE'
filename = 'log.txt'
currency = 'USD'
clientCode = '10T13' -- ����� ������ ��� ������� ����� ������� ������� ������ � ������� ������,
--  ��� ���� ���������� ������ � ��� ����� ����� ��� �������, ����� ����� ���������� ��� ������� � ������� ������� �� �������

-- ������� ������ �������
columns = {
    { ["title"] = "�����", ["width"] = "20" },
    { ["title"] = "����", ["width"] = "20" },
    { ["title"] = "���� ��������", ["width"] = "20" },
    { ["title"] = "����������", ["width"] = "30" },
}

-- ������� ������ �����
rows = { "AAPL", "V", "BSX", "BABA", "BIDU", "BAC" }
