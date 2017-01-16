::::	forfiles /P C:\TEMP\20160623_ID-SCAN /s /m *_List-Local-User-Group.csv /c "cmd /c type @path >>C:\TEMP\20160623_ID-SCAN\原始資料篩選\_$$_ALL_List-Local-User-Group.csv"
forfiles /P C:\TEMP /s /m *_List-Local-User-Group.csv /c "cmd /c type @path >>C:\TEMP\20160623_ID-SCAN\原始資料篩選\_$$_ALL_List-Local-User-Group_0629.csv"
PAUSE