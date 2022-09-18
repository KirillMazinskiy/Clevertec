   WITH TestCTE
        AS
        (
                SELECT 
                      CALENDAR_DATE,
                      IS_DAYOFF (number) – признак выходного дня (0-рабочий 1-выходной).
                FROM 
                    TestTable 
        )
   SELECT * FROM TestCTE
   123
   
