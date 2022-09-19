WITH CALENDAR_OF_WORK_DATES AS ( 
    SELECT 
        T1_CAL.CALENDAR_DATE AS calendar_date,
        CASE
            WHEN WORK_DATES.fifth_work_date IS NULL     
                 AND 
                (LEAD(fifth_work_date,1,NULL) OVER(ORDER BY T1_CAL.CALENDAR_DATE)) IS NULL
            THEN LEAD(fifth_work_date,2,NULL) OVER(ORDER BY T1_CAL.CALENDAR_DATE)
            WHEN WORK_DATES.fifth_work_date IS NULL 
                 AND 
                (LEAD(fifth_work_date,1,NULL) OVER(ORDER BY T1_CAL.CALENDAR_DATE)) IS NOT NULL
            THEN LEAD(fifth_work_date,1,NULL) OVER(ORDER BY T1_CAL.CALENDAR_DATE)
            ELSE
                 fifth_work_date
        END fifth_work_date
    FROM
        CALENDAR T1_CAL
    LEFT JOIN 
            (
                SELECT
                        CALENDAR_DATE AS calendar_date,
                        LEAD(CALENDAR_DATE,4,NULL) OVER(ORDER BY CALENDAR_DATE) AS fifth_work_date
                FROM
                        CALENDAR
                WHERE
                        IS_DAYOFF = 1
             ) WORK_DATES
    ON
        T1_CAL.CALENDAR_DATE = WORK_DATES.calendar_date
        )


SELECT
    doc_id
FROM
    (
    SELECT
        T1_MESSAGE.DOCUMENT_ID AS doc_id 
    FROM 
        MESSAGE T1_MESSAGE  
    INNER JOIN 
        (
            SELECT 
                    DOCUMENT_ID AS CHILD_DOCUMENT_ID, 
                    DOCUMENT_DT AS answer_dt
            FROM
                    MESSAGE
        ) T2_MESSAGE 
    ON 
        T1_MESSAGE.CHILD_DOCUMENT_ID  = T2_MESSAGE.CHILD_DOCUMENT_ID
    LEFT  JOIN 
            CALENDAR_OF_WORK_DATES
    ON 
            T1_MESSAGE.DOCUMENT_DT  = CALENDAR_OF_WORK_DATES.calendar_date
    WHERE      
            T2_MESSAGE.answer_dt > CALENDAR_OF_WORK_DATES.fifth_work_date
    ) MAIN_TABLE
UNION --Добавляем такие DOCUMENT_ID, по которым не было ответа вообще
    SELECT
        DOCUMENT_ID AS doc_id
    FROM 
        MESSAGE
WHERE 
    CHILD_DOCUMENT_ID IS NULL
