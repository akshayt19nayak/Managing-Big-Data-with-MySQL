Database ua_dillards;

#Exercise1

HELP TABLE DEPTINFO;

SELECT TOP 10*
FROM strinfo
ORDER BY city ASC;

SELECT TOP 10*
FROM skuinfo;

SELECT COUNT(*) FROM skuinfo;

SELECT COUNT(DISTINCT dept) FROM skuinfo;

SELECT COUNT(DISTINCT *) FROM skuinfo;

#Quiz
#Problem6
HELP TABLE strinfo;
SELECT COUNT(*) FROM strinfo

SELECT COUNT(zip) 
FROM strinfo
WHERE zip IS NULL;

#Problem7
HELP TABLE trnsact;
SELECT TOP 10 * FROM trnsact WHERE quantity>1;

SELECT MAX(orgprice) FROM trnsact WHERE sku=3631365;

#Problem8
HELP TABLE skuinfo;
SELECT TOP 10 * FROM skuinfo WHERE brand='LIZ CLAI';

SELECT color
FROM skuinfo
WHERE brand='LIZ CLAI' AND sku=9999664;

#Problem9
SELECT SKU, orgprice, sprice, amt
FROM TRNSACT
WHERE AMT>50;

#Problem10
SELECT sku
FROM trnsact
WHERE orgprice=6017;

#Problem11
SELECT COUNT(DISTINCT state)
FROM strinfo;

#Problem12
SELECT deptdesc 
FROM deptinfo
WHERE deptdesc LIKE('E%');

#Problem13
SELECT TOP 10 saledate,orgprice-sprice AS diff
FROM trnsact
WHERE sprice <> orgprice
ORDER BY saledate ASC, diff DESC;

#Problem14
HELP register;

SELECT saledate, register, sprice, orgprice
FROM trnsact
WHERE saledate BETWEEN '2004-08-01' AND '2004-08-10'
ORDER BY orgprice DESC, sprice DESC;

#Problem15
HELP TABLE skuinfo;

SELECT DISTINCT brand
FROM skuinfo
WHERE brand LIKE ('%LIZ%');

#Problem16
HELP TABLE store_msa;

SELECT store
FROM store_msa
WHERE city IN ('little rock','memphis','tulsa')
ORDER BY store;
