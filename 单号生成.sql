/* 格式化对象 2019/10/31 17:18:21 (QP5 v5.287) */
DECLARE
   Seq   INT;
BEGIN
   FOR i IN 1 .. 40
   LOOP
      FOR it
         IN (  SELECT id,
                      wavecode,
                      A,
                      ROWNUM AS rn
                 FROM test
                WHERE     wavecode = 1
                      AND TO_NUMBER (A) > 240
                      AND TO_NUMBER (A) <= 280           -- IS NOT NULL
                      AND TO_NUMBER (REPLACE (itemname, '3A-', '')) = i
             ORDER BY id)
      LOOP
         UPDATE test
            SET orderno =
                      'O20191031-'
                   || it.A
                   || '-'
                   || it.wavecode
                   || '-'
                   || LPAD (i, 2, '0'),
                DETAILORDERNO =
                      'O20191031-'
                   || it.A
                   || '-'
                   || it.wavecode
                   || '-'
                   || LPAD (i, 2, '0')
                   || '-'
                   || LPAD (it.rn, 4, '0')
          WHERE id = it.id;



         DBMS_OUTPUT.put_line (
               'O20191031-'
            || it.A
            || '-'
            || it.wavecode
            || '-'
            || LPAD (i, 2, '0')
            || '   '
            || 'O20191031-'
            || it.A
            || '-'
            || it.wavecode
            || '-'
            || LPAD (i, 2, '0')
            || '-'
            || LPAD (it.rn, 4, '0'));
      END LOOP;
   END LOOP;
END;


SELECT DETAILORDERNO,
       TO_NUMBER (SUBSTR (DETAILORDERNO, 16, 4)),
       TRUNC (TO_NUMBER (SUBSTR (DETAILORDERNO, 16, 4)) / 50),
       TRUNC (TO_NUMBER (SUBSTR (DETAILORDERNO, 16, 4)) / 50) + 1,
          orderno
       || '-'
       || (TRUNC (TO_NUMBER (SUBSTR (DETAILORDERNO, 16, 4)) / 50) + 1)
  FROM test
 WHERE wavecode = '1' AND areacode IS NULL;

UPDATE test
   SET   STOCKUNITCODE='PCS',STOCKUNITNAME='箱',SPEC='1*6'
 WHERE wavecode = '1';

 --UPDATE test
--   SET orderno =
--             orderno
--          || '-'
--          || (TRUNC (TO_NUMBER (SUBSTR (DETAILORDERNO, 16, 4)) / 50) + 1)
-- WHERE wavecode = '1' AND areacode IS NULL;


/* 格式化对象 2019/10/31 17:37:01 (QP5 v5.287) */
--INSERT INTO DPS_OUTBOUNDDETAIL (ID,
--                                ORDERNO,
--                                DETAILORDERNO,
--                                STOCKQTY,
--                                QTY,
--                                ITEMCODE,
--                                AREACODE,
--                                LOCATIONCODE,
--                                STATUS,
--                                STOCKUNITCODE,
--                                STOCKUNITNAME,
--                                UNITCODE,
--                                UNITNAME,
--                                CUSTOMCODE,
--                                CUSTOMNAME,
--                                WAVECODE,
--                                SPEC,
--                                DEALQTY)
--   SELECT ID,
--          ORDERNO,
--          DETAILORDERNO,
--          STOCKQTY,
--          QTY,
--          ITEMCODE,
--          AREACODE,
--          LOCATIONCODE,
--          STATUS,
--          STOCKUNITCODE,
--          STOCKUNITNAME,
--          UNITCODE,
--          UNITNAME,
--          CUSTOMCODE,
--          CUSTOMNAME,
--          WAVECODE,
--          SPEC,
--          DEALQTY
--     FROM test
--    WHERE wavecode = 1;


/* 格式化对象 2019/11/01 08:58:14 (QP5 v5.287) */
--INSERT INTO DPS_ITEMUNIT (CODE,
--                          name,
--                          ITEMCODE,
--                          INNERCODE,
--                          qty,
--                          ID)
--   SELECT CODE,
--          name,
--          ITEMCODE,
--          INNERCODE,
--          qty,
--          SYS_GUID ()
--     FROM (SELECT DISTINCT 'PCS' AS CODE,
--                           '箱' AS name,
--                           itemcode,
--                           'BT' AS INNERCODE,
--                           6 AS QTY
--             FROM DPS_OUTBOUNDDETAIL
--           UNION ALL
--           SELECT DISTINCT 'BT' AS CODE,
--                           '瓶' AS name,
--                           itemcode,
--                           '' AS INNERCODE,
--                           null AS QTY
--             FROM DPS_OUTBOUNDDETAIL);