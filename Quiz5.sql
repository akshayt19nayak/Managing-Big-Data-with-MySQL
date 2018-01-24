Database ua_dillards;

#Problem1
SELECT my.month_num,my.year_num,COUNT(DISTINCT my.saledate)
FROM (SELECT saledate, EXTRACT(MONTH from saledate) AS month_num, EXTRACT(YEAR from saledate) AS year_num
FROM trnsact) AS my
GROUP BY my.month_num,my.year_num;

#Problem2
SELECT sku,SUM(amt)
FROM trnsact
WHERE stype='P' AND (EXTRACT(MONTH from saledate)=6 OR EXTRACT(MONTH from saledate)=7 OR EXTRACT(MONTH from saledate)=8)
GROUP BY sku
ORDER BY 2 DESC;

#Problem3
SELECT my.store, my.month_num,my.year_num,COUNT(DISTINCT my.saledate)
FROM (SELECT store, saledate, EXTRACT(MONTH from saledate) AS month_num, EXTRACT(YEAR from saledate) AS year_num
FROM trnsact) AS my
GROUP BY my.store,my.month_num,my.year_num
ORDER BY 4 ASC;

#Problem4
SELECT my.store,my.month_num,my.year_num,SUM(my.amt),COUNT(DISTINCT saledate),SUM(my.amt)/COUNT(DISTINCT my.saledate)
FROM (SELECT amt, stype, store, saledate, EXTRACT(MONTH from saledate) AS month_num || EXTRACT(YEAR from saledate) AS year_num
FROM trnsact) AS my
WHERE my.stype='P' AND NOT(month_num = 8 AND year_num=2005)
GROUP BY my.store,my.month_num,my.year_num
HAVING COUNT(DISTINCT saledate)>=20;

#Problem5
SELECT sm.edu,SUM(my.amt),COUNT(DISTINCT saledate),SUM(my.amt)/COUNT(DISTINCT my.saledate)
FROM (SELECT amt, stype, store, saledate,  EXTRACT(MONTH from saledate) AS month_num, EXTRACT(YEAR from saledate) AS year_num
FROM trnsact) AS my LEFT JOIN (SELECT msa_high,store,
CASE
WHEN msa_high >=50 AND msa_high<=60 THEN 'Low'
WHEN msa_high >=60.01 AND msa_high<=70 THEN 'Medium'
WHEN msa_high >70 THEN 'High'
END AS edu
FROM store_msa) AS sm
ON my.store=sm.store
WHERE my.stype='P' AND NOT(month_num = 8 AND year_num=2005)  
GROUP BY sm.edu
HAVING COUNT(DISTINCT saledate)>=20;

SELECT amt, stype, my.store, saledate, sm.store, sm.edu, EXTRACT(MONTH from saledate) AS month_num, EXTRACT(YEAR from saledate) AS year_num
FROM trnsact AS my LEFT JOIN (SELECT msa_high,store,
CASE
WHEN msa_high >=50 AND msa_high<=60 THEN 'Low'
WHEN msa_high >=60.01 AND msa_high<=70 THEN 'Medium'
WHEN msa_high >70 THEN 'High'
END AS edu
FROM store_msa) AS sm
ON my.store=sm.store
WHERE my.stype='P' AND NOT(month_num = 8 AND year_num=2005)

#Problem10
SELECT my.month_num,SUM(my.amt)/COUNT(DISTINCT my.saledate)
FROM (SELECT amt, stype, store, saledate, EXTRACT(MONTH from saledate) AS month_num, EXTRACT(YEAR from saledate) AS year_num
FROM trnsact) AS my
WHERE my.stype='P' AND NOT(month_num = 8 AND year_num=2005)  
GROUP BY my.month_num
ORDER BY 4 DESC

#Quiz5
#Question2
SELECT COUNT(DISTINCT sku)
FROM skuinfo
WHERE brand = 'Polo fas' AND (size = 'XXL' OR color='black');

#Question3
SELECT sm.city,sm.state,my.store,my.month_num,my.year_num,COUNT(DISTINCT my.saledate)
FROM (SELECT store, saledate, EXTRACT(MONTH from saledate) AS month_num, EXTRACT(YEAR from saledate) AS year_num
FROM trnsact) AS my JOIN store_msa sm
ON my.store=sm.store
GROUP BY sm.city,sm.state,my.store,my.month_num,my.year_num
HAVING COUNT(DISTINCT my.saledate)=11;

#Question4
SELECT sku,SUM(November),SUM(December),SUM(December)-SUM(November)
FROM(SELECT sku,(CASE WHEN my.month_num=11 THEN amt END AS November),(CASE WHEN my.month_num=12 THEN amt END AS December)
FROM (SELECT amt, sku, stype, store, saledate, EXTRACT(MONTH from saledate) AS month_num, EXTRACT(YEAR from saledate) AS year_num
FROM trnsact) AS my
WHERE my.stype='P') AS summonths
GROUP BY sku
ORDER BY 4 DESC

#Question5
SELECT vend.vendor, COUNT(vend.sku)
FROM(SELECT DISTINCT sk.vendor, trn.sku
FROM trnsact trn JOIN skuinfo sk
ON trn.sku=sk.sku) AS vend LEFT JOIN skstinfo skst
ON vend.sku=skst.sku
WHERE skst.sku IS NULL
GROUP BY vend.vendor
ORDER BY 2 DESC

#Question6
SELECT sk.brand,trn.sd
FROM skuinfo sk JOIN (SELECT sku,STDDEV_SAMP(sprice) AS sd,COUNT(trannum) AS CountOfSales
FROM trnsact
WHERE stype='P'
GROUP BY sku
HAVING COUNT(trannum)>100) AS trn
ON sk.sku=trn.sku
ORDER BY 2 DESC

#Question7
SELECT smsa.state,smsa.city,final.store,SUM(December)-SUM(November)
FROM(SELECT good.store,(CASE WHEN good.month_num=11 THEN good.ADR END AS November),(CASE WHEN good.month_num=12 THEN good.ADR END AS December)
FROM (SELECT my.store,my.month_num,my.year_num,SUM(my.amt) AS sumamt,COUNT(DISTINCT saledate) AS sd,SUM(my.amt)/COUNT(DISTINCT my.saledate) AS ADR
FROM (SELECT amt, store, saledate, EXTRACT(MONTH from saledate) AS month_num, EXTRACT(YEAR from saledate) AS year_num
FROM trnsact
WHERE stype='P') AS my
WHERE month_num=11 OR month_num=12
GROUP BY my.store,my.month_num,my.year_num
HAVING COUNT(DISTINCT saledate)>=20) AS good) AS final LEFT JOIN store_msa smsa
ON final.store=smsa.store
GROUP BY final.store,smsa.state,smsa.city
ORDER BY 4 DESC;

#Question8
SELECT mininc.state,mininc.city,SUM(sumamt)/SUM(sd)
FROM(SELECT my.store,my.month_num,my.year_num,SUM(my.amt) AS sumamt,COUNT(DISTINCT saledate) AS sd,SUM(my.amt)/COUNT(DISTINCT my.saledate) AS ADR
FROM (SELECT amt, store, saledate, EXTRACT(MONTH from saledate) AS month_num, EXTRACT(YEAR from saledate) AS year_num
FROM trnsact
WHERE stype='P') AS my
WHERE NOT(month_num = 8 AND year_num=2005)
GROUP BY my.store,my.month_num,my.year_num
HAVING COUNT(DISTINCT saledate)>=20) AS good,(SELECT TOP 1 state,city,store FROM store_msa ORDER BY msa_income ASC) AS mininc
WHERE good.store=mininc.store
GROUP BY mininc.state,mininc.city

SELECT maxinc.state,maxinc.city,SUM(sumamt)/SUM(sd)
FROM(SELECT my.store,my.month_num,my.year_num,SUM(my.amt) AS sumamt,COUNT(DISTINCT saledate) AS sd,SUM(my.amt)/COUNT(DISTINCT my.saledate) AS ADR
FROM (SELECT amt, store, saledate, EXTRACT(MONTH from saledate) AS month_num, EXTRACT(YEAR from saledate) AS year_num
FROM trnsact
WHERE stype='P') AS my
WHERE NOT(month_num = 8 AND year_num=2005)
GROUP BY my.store,my.month_num,my.year_num
HAVING COUNT(DISTINCT saledate)>=20) AS good,(SELECT TOP 1 state,city,store FROM store_msa ORDER BY msa_income DESC) AS maxinc
WHERE good.store=maxinc.store
GROUP BY maxinc.state,maxinc.city

#Question9
SELECT smsa.incbrac,SUM(good.sumamt)/SUM(good.sd)
FROM(SELECT my.store,my.month_num,my.year_num,SUM(my.amt) AS sumamt,COUNT(DISTINCT saledate) AS sd,SUM(my.amt)/COUNT(DISTINCT my.saledate) AS ADR
FROM (SELECT amt, store, saledate, EXTRACT(MONTH from saledate) AS month_num, EXTRACT(YEAR from saledate) AS year_num
FROM trnsact
WHERE stype='P') AS my
WHERE NOT(month_num = 8 AND year_num=2005)
GROUP BY my.store,my.month_num,my.year_num
HAVING COUNT(DISTINCT saledate)>=20)AS good JOIN (SELECT store,msa_income,
CASE 
WHEN msa_income >=1 AND msa_income <=20000 THEN 'low'
WHEN msa_income >=20001 AND msa_income <=30000 THEN 'med-low'
WHEN msa_income >=30001 AND msa_income <=40000 THEN 'med-high'
WHEN msa_income >=40001 AND msa_income <=60000 THEN 'high'
END AS incbrac
FROM store_msa) AS smsa
ON good.store=smsa.store
GROUP BY smsa.incbrac
ORDER BY 2 DESC

#Question10
SELECT smsa.popbrac,SUM(good.sumamt)/SUM(good.sd)
FROM(SELECT my.store,my.month_num,my.year_num,SUM(my.amt) AS sumamt,COUNT(DISTINCT saledate) AS sd,SUM(my.amt)/COUNT(DISTINCT my.saledate) AS ADR
FROM (SELECT amt, store, saledate, EXTRACT(MONTH from saledate) AS month_num, EXTRACT(YEAR from saledate) AS year_num
FROM trnsact
WHERE stype='P') AS my
WHERE NOT(month_num = 8 AND year_num=2005)
GROUP BY my.store,my.month_num,my.year_num
HAVING COUNT(DISTINCT saledate)>=20)AS good JOIN (SELECT store,msa_pop,
CASE 
WHEN msa_pop >=1 AND msa_pop <=100000 THEN 'very small'
WHEN msa_pop >=100001 AND msa_pop <=200000 THEN 'small'
WHEN msa_pop >=200001 AND msa_pop <=500000 THEN 'med-small'
WHEN msa_pop >=500001 AND msa_pop <=1000000 THEN 'med-large'
WHEN msa_pop >=1000001 AND msa_pop <=5000000 THEN 'large'
WHEN msa_pop >=5000001 THEN 'very large'
END AS popbrac
FROM store_msa) AS smsa
ON good.store=smsa.store
GROUP BY smsa.popbrac
ORDER BY 2 DESC

#Problem11
SELECT TOP 5 final.store,final.state,final.city,final.deptdesc,SUM(final.November)/SUM(final.NovDays)AS nadr,SUM(final.December)/SUM(final.DecDays) AS dadr,(dadr-nadr)/nadr
FROM (SELECT csd.state,csd.city,good.store,csd.deptdesc,(CASE WHEN good.month_num=11 THEN sumamt END AS November),(CASE WHEN good.month_num=11 THEN sd END AS NovDays),(CASE WHEN good.month_num=12 THEN sumamt END AS December),(CASE WHEN good.month_num=12 THEN sd END AS DecDays)
FROM(SELECT my.store,my.month_num,my.year_num,SUM(my.amt) AS sumamt,COUNT(DISTINCT saledate) AS sd,SUM(my.amt)/COUNT(DISTINCT my.saledate) AS ADR
FROM (SELECT amt, store, saledate, EXTRACT(MONTH from saledate) AS month_num, EXTRACT(YEAR from saledate) AS year_num
FROM trnsact
WHERE stype='P') AS my
WHERE month_num=11 OR month_num=12
GROUP BY my.store,my.month_num,my.year_num
HAVING COUNT(DISTINCT saledate)>=20) AS good JOIN (SELECT smsa.state,smsa.city,smsa.store,skd.deptdesc
FROM store_msa smsa, skstinfo skst,(SELECT sk.sku,sk.dept,d.deptdesc FROM skuinfo sk LEFT JOIN deptinfo d 
ON sk.dept=d.dept) AS skd
WHERE skst.sku=skd.sku AND skst.store=smsa.store) AS csd
ON good.store=csd.store) AS final
GROUP BY final.store,final.state,final.city,final.deptdesc
HAVING (SUM(final.November)>=1000 AND SUM(final.December)>=1000)
ORDER BY 7 DESC

SELECT s.store, s.city, s.state, d.deptdesc, sum(case when extract(month from saledate)=11 then amt end) as November,
COUNT(DISTINCT (case WHEN EXTRACT(MONTH from saledate) ='11' then saledate END)) as Nov_numdays, sum(case when extract(month from saledate)=12 then amt end) as December,
COUNT(DISTINCT (case WHEN EXTRACT(MONTH from saledate) ='12' then saledate END)) as Dec_numdays, ((December/Dec_numdays)-(November/Nov_numdays))/(November/Nov_numdays)*100 AS bump
FROM trnsact t JOIN strinfo s
ON t.store=s.store JOIN skuinfo si
ON t.sku=si.sku JOIN deptinfo d
ON si.dept=d.dept
WHERE t.stype='P' and t.store||EXTRACT(YEAR from t.saledate)||EXTRACT(MONTH from t.saledate) IN (SELECT store||EXTRACT(YEAR from saledate)||EXTRACT(MONTH from saledate)
	FROM trnsact
	GROUP BY store, EXTRACT(YEAR from saledate), EXTRACT(MONTH from saledate)
	HAVING COUNT(DISTINCT saledate)>= 20)
GROUP BY s.store, s.city, s.state, d.deptdesc HAVING November > 1000 AND December > 1000
ORDER BY bump DESC;

#Problem12
SELECT TOP 5 s.store, s.city, s.state, d.deptdesc, sum(case when extract(month from saledate)=8 then amt end) as August,
COUNT(DISTINCT (case WHEN EXTRACT(MONTH from saledate) ='8' then saledate END)) as Aug_numdays, sum(case when extract(month from saledate)=9 then amt end) as September,
COUNT(DISTINCT (case WHEN EXTRACT(MONTH from saledate) ='9' then saledate END)) as Sep_numdays, ((August/Aug_numdays)-(September/Sep_numdays)) AS dip
FROM trnsact t JOIN strinfo s
ON t.store=s.store JOIN skuinfo si
ON t.sku=si.sku JOIN deptinfo d
ON si.dept=d.dept
WHERE t.stype='P' and t.store||EXTRACT(YEAR from t.saledate)||EXTRACT(MONTH from t.saledate) IN (SELECT store||EXTRACT(YEAR from saledate)||EXTRACT(MONTH from saledate)
	FROM trnsact
	GROUP BY store, EXTRACT(YEAR from saledate), EXTRACT(MONTH from saledate)
	HAVING COUNT(DISTINCT saledate)>= 20)
GROUP BY s.store, s.city, s.state, d.deptdesc
ORDER BY dip DESC;

#Problem13
SELECT TOP 5 s.store, s.city, s.state, d.deptdesc, sum(case when extract(month from saledate)=8 then quantity end) as August, sum(case when extract(month from saledate)=9 then quantity end) as September,August-September AS dip
FROM trnsact t JOIN strinfo s
ON t.store=s.store JOIN skuinfo si
ON t.sku=si.sku JOIN deptinfo d
ON si.dept=d.dept
WHERE t.stype='P'
GROUP BY s.store, s.city, s.state, d.deptdesc
ORDER BY dip DESC;

#Problem14
SELECT final.month_num,COUNT(final.store)
FROM(SELECT good.store,good.month_num,good.ADR, RANK() OVER(PARTITION BY good.store ORDER BY good.ADR ASC) AS rankadr
FROM(SELECT my.store,my.month_num,my.year_num,SUM(my.amt) AS sumamt,COUNT(DISTINCT saledate) AS sd,SUM(my.amt)/COUNT(DISTINCT my.saledate) AS ADR
FROM (SELECT amt, store, saledate, EXTRACT(MONTH from saledate) AS month_num, EXTRACT(YEAR from saledate) AS year_num
FROM trnsact
WHERE stype='P') AS my
WHERE NOT(month_num = 8 AND year_num=2005)
GROUP BY my.store,my.month_num,my.year_num
HAVING COUNT(DISTINCT saledate)>=20) AS good) AS final
WHERE final.rankadr=1
GROUP BY final.month_num
ORDER BY 2 DESC

#Problem15
SELECT final.month_num,COUNT(final.store)
FROM(SELECT base.store,base.month_num,COUNT(base.sku) AS skuunits, RANK() OVER(PARTITION BY base.store ORDER BY skuunits DESC) AS ranksku
FROM(SELECT store,EXTRACT(MONTH from saledate)AS month_num,EXTRACT(YEAR from saledate)AS year_num,sku
FROM trnsact
WHERE stype='R' AND NOT(month_num = 8 AND year_num=2005)) AS base
GROUP BY base.store,base.month_num) AS final
WHERE ranksku=1
GROUP BY final.month_num
