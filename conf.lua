sleep_time = 10000
do_main = true
class_code = "SPBXM" -- ����� ������
columnName = "V" -- ��� ������
titleTable = "������� ���������� ���� ������ � ���� ��������"
tableLink = nil
indefParam = 'OFFER'
lastClose = 'PREVPRICE'
filename = 'info.txt'

-- ������� ������ �������
columns = {
    { ["title"] = "�����", ["width"] = "20" },
    { ["title"] = "����", ["width"] = "20" },
    { ["title"] = "���� ��������", ["width"] = "20" },
    { ["title"] = "����������", ["width"] = "30" },
}

-- ������� ������ �����
rows = { "AAPL", "V", "BSX", "BABA", "BIDU", "BAC" }
