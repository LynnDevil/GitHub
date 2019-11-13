/* 格式化对象 2019/10/31 16:17:10 (QP5 v5.287) */
DECLARE
   Seq   INT;
BEGIN
   FOR i IN 1 .. 40
   LOOP
      FOR it
         IN (SELECT *
               FROM (SELECT id,
                            wavecode,
                            itemcode,
                            ROW_NUMBER ()
                               OVER (PARTITION BY itemcode ORDER BY id)
                               AS rn
                       FROM test
                      WHERE wavecode = 1 AND itemname IS NULL)
              WHERE rn = i)
      LOOP
         UPDATE test
            SET ITEMNAME = '3A-' || LPAD (i, 2, '0'), areacode = 240 + i
          WHERE id = it.id;

         DBMS_OUTPUT.put_line (
               it.id
            || '   '
            || '3A-'
            || LPAD (i, 2, '0')
            || '   '
            || it.itemcode);
      END LOOP;
   END LOOP;
END;

SELECT id,
       wavecode,
       areacode,
       itemname,
       itemcode,
       ROW_NUMBER () OVER (PARTITION BY itemcode ORDER BY wavecode, itemname)
          AS rn
  FROM test
 WHERE wavecode = 1;