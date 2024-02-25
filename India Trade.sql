Create database India_trade;
use india_trade;

# -----------Exploratory Data Analysis-------------
Select * from exports;
Select * from imports;

desc Exports;
desc imports;

#--------Checking For Null Values in Tables---------
select count(*) from exports
where HSCode is null or Commodity is null or `value` is null or country is null or `year` is null;

select count(*) from Imports
where HSCode is null or Commodity is null or `value` is null or country is null or `year` is null;

#-------Checking for Blank Values--------
select count(*) from exports
where HSCode ="" or Commodity ="" or `value` ="" or country ="" or `year` ="";
# export table has 19258 rows where values are blank

select count(*) from imports
where HSCode ="" or Commodity ="" or `value` ="" or country ="" or `year` ="";
#import table has 11136 rows where values are blank

#--------- deleting rows where values are blank----------
delete from exports where HSCode ="" or Commodity ="" or `value` ="" or country ="" or `year` ="";

Delete from imports where HSCode ="" or Commodity ="" or `value` ="" or country ="" or `year` ="";

#----------count of distinct commodities by year--------
select count(distinct hscode)HScode, `year` from exports
group by `year`;

select count(distinct hscode)HScode, `year` from imports
group by `year`;

# India imports and exports 98 different commodities every year

#------------min, max and avg value every year----------
select min(`value`)Minimum, max(`value`)Maximum, avg(`value`)Average, `year` from exports 
group by `year`;

select min(`value`)Minimum, max(`value`)Maximum, avg(`value`)Average, `year` from imports 
group by `year`;

#--------Data Analysis-------

# Country with which India has highest trade over the years

select Country, `Year`, round(c,2)Total_export from (select country, `year`, sum(`value`)c, row_number() over(partition by `year` order by sum(`value`) desc)`rank`  from exports
group by country, `year`)ABC
where `rank`=1;

select Country, `Year`, round(c,2)Total_import from (select country, `year`, sum(`value`)c, row_number() over(partition by `year` order by sum(`value`) desc)`rank`  from imports
group by country, `year`)ABC
where `rank`=1;

# Top 3 trding partners of India over the years
select * from (select `year`, country, round(sum(`value`),2)Total_Value, 
dense_rank() over(partition by `year` order by sum(`value`) desc)`Rank` from  exports
group by country,`year`)ABC 
where `rank` <=3;

select * from (select `year`,country, round(sum(`value`),2)Total_Value, 
dense_rank() over(partition by `year` order by sum(`value`) desc)`Rank` from  imports
group by country,`year`)ABC 
where `rank` <=3;


select country,
sum(case when `year`=2010 then `value` else "NA" end) as "2010",
sum(case when `year`=2011 then `value` else "NA" end) as "2011",
sum(case when `year`=2012 then `value` else "NA" end) as "2012",
sum(case when `year`=2013 then `value` else "NA" end) as "2013",
sum(case when `year`=2014 then `value` else "NA" end) as "2014",
sum(case when `year`=2015 then `value` else "NA" end) as "2015",
sum(case when `year`=2016 then `value` else "NA" end )as "2016",
sum(case when `year`=2017 then `value` else "NA" end )as "2017",
sum(case when `year`=2018 then `value` else "NA" end )as "2018",
sum(case when `year`=2019 then `value` else "NA" end )as "2019",
sum(case when `year`=2020 then `value` else "NA" end) as "2020",
sum(case when `year`=2021 then `value` else "NA" end) as "2021"
from exports
where country in ("Japan", "Australia", "U S A")
group by country;

select country,
sum(case when `year`=2010 then `value` else "NA" end) as "2010",
sum(case when `year`=2011 then `value` else "NA" end) as "2011",
sum(case when `year`=2012 then `value` else "NA" end) as "2012",
sum(case when `year`=2013 then `value` else "NA" end) as "2013",
sum(case when `year`=2014 then `value` else "NA" end) as "2014",
sum(case when `year`=2015 then `value` else "NA" end) as "2015",
sum(case when `year`=2016 then `value` else "NA" end )as "2016",
sum(case when `year`=2017 then `value` else "NA" end )as "2017",
sum(case when `year`=2018 then `value` else "NA" end )as "2018",
sum(case when `year`=2019 then `value` else "NA" end )as "2019",
sum(case when `year`=2020 then `value` else "NA" end) as "2020",
sum(case when `year`=2021 then `value` else "NA" end) as "2021"
from imports
where country in ("Japan", "Australia", "U S A")
group by country;

# Most Exported and imported commodity each year
select HSCode,Commodity, Total_Export, `Year` from (select HSCode, commodity, round(sum(value),2)Total_Export , `year`, dense_rank() over( partition by `year` order by sum(`value`) desc)`Rank` from exports 
group by HSCode, commodity, `year`)ABC
where `rank`=1 ;

select HSCode,Commodity, Total_Import, `Year` from (select HSCode, commodity, round(sum(value),2)Total_Import , `year`, dense_rank() over( partition by `year` order by sum(`value`) desc)`Rank` from imports 
group by HSCode, commodity, `year`)ABC
where `rank`=1 ;

# Least Exported and imported commodity each year
select HSCode,Commodity, Total_Export, `Year` from (select HSCode, commodity, round(sum(value),2)Total_Export , `year`, dense_rank() over( partition by `year` order by sum(`value`) asc)`Rank` from exports 
group by HSCode, commodity, `year`)ABC
where `rank`=1 ;

select HSCode,Commodity, Total_Import, `Year` from (select HSCode, commodity, round(sum(value),2)Total_Import , `year`, dense_rank() over( partition by `year` order by sum(`value`) asc)`Rank` from imports 
group by HSCode, commodity, `year`)ABC
where `rank`=1 ;

# top 10 commodity exported and imported by India
select Commodity, round(Total,2)Total_Export from (select commodity, sum(`value`)Total, dense_rank() over(order by sum(`value`) desc)`rank` from exports
group by commodity)ABC
where `rank`<=10;

select Commodity, round(Total,2)Total_Import from (select commodity, sum(`value`)Total, dense_rank() over(order by sum(`value`) desc)`rank` from Imports
group by commodity)ABC
where `rank`<=10;


# imcrement in trade between India and Quad countries over the years
#------------JAPAN---------------
select country, `Year`, Total_Export, concat(round(((Total_export-PY)/PY)*100,2)," %")Percent_Increase  from (select Country, `year`, round(sum(`value`),2)Total_Export, 
lag(sum(`value`)) over(order by `year`)PY from exports
where country = "japan"
group by country, `year`)ABC ; 

select country, `Year`, Total_Import, concat(round(((Total_Import-PY)/PY)*100,2)," %")Percent_Increase  from (select Country, `year`, round(sum(`value`),2)Total_Import,
lag(sum(`value`)) over(order by `year`)PY from imports
where country = "japan"
group by country, `year`)ABC ; 

#------------USA---------------
select country, `Year`, Total_Export, concat(round(((Total_Export-PY)/PY)*100,2)," %")Percent_Increase  from (select Country, `year`, round(sum(`value`),2)Total_Export, 
lag(sum(`value`)) over(order by `year`)PY from exports
where country = "U S A"
group by country, `year`)ABC ; 

select country, `Year`, Total_Import, concat(round(((Total_Import-PY)/PY)*100,2)," %")Percent_Increase  from (select Country, `year`, round(sum(`value`),2)Total_Import,
lag(sum(`value`)) over(order by `year`)PY from imports
where country = "u s a"
group by country, `year`)ABC ; 

#------------Australia---------------
select country, `Year`, Total_Export, concat(round(((Total_Export-PY)/PY)*100,2)," %")Percent_Increase  from (select Country, `year`, round(sum(`value`),2)Total_Export, 
lag(sum(`value`)) over(order by `year`)PY from exports
where country = "australia"
group by country, `year`)ABC ; 

select country, `Year`, Total_Import, concat(round(((Total_Import-PY)/PY)*100,2)," %")Percent_Increase  from (select Country, `year`, round(sum(`value`),2)Total_Import,
lag(sum(`value`)) over(order by `year`)PY from imports
where country = "australia"
group by country, `year`)ABC ; 

# imcrement in trade between India and China over the years
select country, `Year`, Total_Export, concat(round(((Total_Export-PY)/PY)*100,2)," %")Percent_Increase  from (select Country, `year`, round(sum(`value`),2)Total_Export, 
lag(sum(`value`)) over(order by `year`)PY from exports
where country = "china p rp"
group by country, `year`)ABC ; 

select country, `Year`, Total_Import, concat(round(((Total_Import-PY)/PY)*100,2)," %")Percent_Increase  from (select Country, `year`, round(sum(`value`),2)Total_Import,
lag(sum(`value`)) over(order by `year`)PY from imports
where country = "china p rp"
group by country, `year`)ABC ; 

# imcrement in trade between India and UK over the years

select country, `Year`, Total_Export, concat(round(((Total_Export-PY)/PY)*100,2)," %")Percent_Increase  from (select Country, `year`, round(sum(`value`),2)Total_Export, 
lag(sum(`value`)) over(order by `year`)PY from exports
where country = "U k"
group by country, `year`)ABC ; 

select country, `Year`, Total_Import, concat(round(((Total_Import-PY)/PY)*100,2)," %")Percent_Increase  from (select Country, `year`, round(sum(`value`),2)Total_Import,
lag(sum(`value`)) over(order by `year`)PY from imports
where country = "U k"
group by country, `year`)ABC ; 

