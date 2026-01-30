create table road_accident (
accident_index varchar(50),
accident_date DATE,
day_of_week varchar(50),	
junction_control varchar(100),
junction_detail varchar(100),
accident_severity varchar(100),
light_conditions varchar(100),
local_authority varchar(100),
carriageway_hazards varchar(150),
number_of_casualties INT,
number_of_vehicles	INT,
police_force varchar(100),
road_surface_conditions varchar(100),
road_type varchar(100),
speed_limit INT,
time TIME,
urban_or_rural_area varchar(100),
weather_conditions	varchar(100),
vehicle_type varchar(100)
);


SELECT *
FROM road_accident;

select distinct year(accident_date)
from road_accident
;

#1 No.Of Casualties in CY 2022
select sum(number_of_casualties) as cy_casualties
from road_accident
where year(accident_date) = '2022';

#2 Total Accidents in the Current year 2022 
select count(distinct accident_index) as cy_accidents
from road_accident
where year(accident_date) = 2022;

#3 CY_Casualties for distinct accident severiity
select accident_severity, sum(number_of_casualties) as cy_casualties
from road_accident
where year(accident_date) = '2022' 
group by accident_severity
;

#4 Percentage of CY_Casualties vs Total_casualties for accident severity
select accident_severity, sum(number_of_casualties) as CY_Casualties, sum(number_of_casualties)*100
/(select sum(number_of_casualties) from road_accident) as PCT_CY_TOTAL
from road_accident
where year(accident_date) = '2022'
group by accident_severity
order by 2
;

#5 Total Casualties by vehicle type
select distinct vehicle_type
from road_accident;

select
	case
		when vehicle_type in ('Agricultural vehicle') then 'Agriculture'
        when vehicle_type in ('Motorcycle 125cc and under', 'Motorcycle 50cc and under','Motorcycle over 500cc', 'Motorcycle over 125cc and up to 500cc','Pedal cycle') then 'Bikes'
		when vehicle_type in ('Car','Taxi/Private hire car') then 'Cars'
		when vehicle_type in ('Van / Goods 3.5 tonnes mgw or under','Goods over 3.5t. and under 7.5t','Goods 7.5 tonnes mgw and over') then 'Vans'
		when vehicle_type in ('Bus or coach (17 or more pass seats)','Minibus (8 - 16 passenger seats') then 'Bus'
		else 'others'
	end as vehicle_group,
    count(vehicle_type), sum(number_of_casualties) as Total_casualties
from road_accident
group by 
	case
		when vehicle_type in ('Agricultural vehicle') then 'Agriculture'
        when vehicle_type in ('Motorcycle 125cc and under', 'Motorcycle 50cc and under','Motorcycle over 500cc', 'Motorcycle over 125cc and up to 500cc','Pedal cycle') then 'Bikes'
		when vehicle_type in ('Car','Taxi/Private hire car') then 'Cars'
		when vehicle_type in ('Van / Goods 3.5 tonnes mgw or under','Goods over 3.5t. and under 7.5t','Goods 7.5 tonnes mgw and over') then 'Vans'
		when vehicle_type in ('Bus or coach (17 or more pass seats)','Minibus (8 - 16 passenger seats') then 'Bus'
		else 'others'
	end;
    
select DISTINCT YEAR(accident_date)
from road_accident;
    
#6 Current_Year Vs Previous_Year Casualties
select monthname(accident_date) as month_2022, sum(number_of_casualties) as CY_casualties
from road_accident
where year(accident_date)='2022'
group by month_2022
order by 2 desc;

select monthname(accident_date) as month_2021, sum(number_of_casualties) as PY_casualties
from road_accident
where year(accident_date)='2021'
group by month_2021
order by 2 desc;

#7 Percentage of Casualties by distinct road types
select road_type,sum(number_of_casualties) as total_casualties,
sum(number_of_casualties)*100/(select sum(number_of_casualties) from road_accident where year(accident_date)='2022') as PCT
from road_accident
where year(accident_date)='2022'
group by 1
order by 3 DESC;

#8 Casualties by Urban/Rural areas
select urban_or_rural_area, sum(number_of_casualties) as total_casualties
from road_accident
group by 1
;

#9 Percentage of casualties by  Urban/Rural areas
select urban_or_rural_area, sum(number_of_casualties) as total_casualties, sum(number_of_casualties)*100/(select sum(number_of_casualties) from road_accident) as PCT
from road_accident
group by 1
;

#10 Percentage of cy_casualties by light conditions
select distinct light_conditions
from road_accident;

select
	case
		when light_conditions in ('Daylight') then 'Day'
        when light_conditions in ('Darkness - lights lit','Darkness - lighting unknown','Darkness - lights unlit','Darkness - no lighting') then 'Night'
        else 'others'
	end as light_conditions,
    cast(cast(sum(number_of_casualties) as decimal(10,2))*100/(select cast(sum(number_of_casualties) as decimal(10,2)) from road_accident where year(accident_date)='2022') as decimal(10,2)) as PCT_CYLight_Casualties
    from road_accident
    where year(accident_date)='2022'
    group by
    case
		when light_conditions in ('Daylight') then 'Day'
        when light_conditions in ('Darkness - lights lit','Darkness - lighting unknown','Darkness - lights unlit','Darkness - no lighting') then 'Night'
        else 'others'
	end;

#11 Top 10 location by casualties
select local_authority, sum(number_of_casualties) as total_casualties,
dense_rank() over (order by sum(number_of_casualties) desc) as top10_locations
from road_accident
group by local_authority
order by 2 desc
limit 10;

#12 Casualties by weather conditions
select weather_conditions, sum(number_of_casualties) as cy_casualties
from road_accident
where year(accident_date)='2022'
group by weather_conditions
order by 2 desc;

#13 Casualties by road conditions
select road_surface_conditions, sum(number_of_casualties) as total_casualties
from road_accident
group by road_surface_conditions
order by 2 desc;

#14 Accidents on weekdays/weekend
select day_of_week, count(accident_index) as total_accidents
from road_accident
group by day_of_week
order by 2 
;

#15 Casualties by time (peak hours)
select distinct time
from road_accident;	

select
	case
		when hour(time) between 6 and 12 then 'Morning'
        when hour(time) between 12 and 16 then 'AfterNoon'
        when hour(time) between 16 and 20 then 'Evening'
        when hour(time) between 20 and 24 then 'Night'
        when hour(time) between 24 and 6 then 'MidNight'
        Else 'Others'
     End as 'Time_Bands',
     sum(number_of_casualties) as total_casualties
     from road_accident
     group by
     case
		when hour(time) between 6 and 12 then 'Morning'
        when hour(time) between 12 and 16 then 'AfterNoon'
        when hour(time) between 16 and 20 then 'Evening'
        when hour(time) between 20 and 24 then 'Night'
        when hour(time) between 24 and 6 then 'MidNight'
        Else 'Others'
     End
     order by 2 desc;
     
#16 Juction Control impact on each year casualties 
select junction_control, sum(number_of_casualties) as CY_casualties
from road_accident
where year(accident_date) = 2022
group by junction_control
order by CY_casualties desc;
        
select junction_control, sum(number_of_casualties) as PY_casualties
from road_accident
where year(accident_date) = 2021
group by junction_control
order by PY_casualties desc;