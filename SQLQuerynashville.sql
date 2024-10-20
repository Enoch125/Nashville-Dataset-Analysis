----Major task

--Cleaning data
select * from Projectsql..Nashvillecleaning
--Data formats
select NewSaleDate ,  COnVERT(date,SaleDate) 
from Projectsql..Nashvillecleaning

	

Alter table Nashvillecleaning
Add NewSaleDate Date;
update Nashvillecleaning
set NewSaleDate =  CONVERT(date,SaleDate)		

--populate property address data

select *
from Projectsql..Nashvillecleaning
--where PropertyAddress is null
order by ParcelID


select a.ParcelID , a.PropertyAddress , b.ParcelID ,b.PropertyAddress, isnull(a.propertyAddress,b.PropertyAddress)
   from  Projectsql..Nashvillecleaning  a
join 
   Projectsql..Nashvillecleaning  b
   on
    a.ParcelID = b.ParcelID and  
	a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null


	update a
	set PropertyAddress = isnull(a.propertyAddress,b.PropertyAddress)
	  from  Projectsql..Nashvillecleaning  a
join 
   Projectsql..Nashvillecleaning  b
   on
    a.ParcelID = b.ParcelID and  
	a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null



--breaking out address with individuals colums (Address, city, state)

select PropertyAddress
from Projectsql..Nashvillecleaning

select
SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1  ,LEN(propertyAddress))

--CHARINDEX( ',', PropertyAddress )
from Projectsql..Nashvillecleaning


Alter table Nashvillecleaning
Add PropertysplitAdress nvarchar(235);

update Nashvillecleaning
set  PropertysplitAdress = 	SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1)


Alter table Nashvillecleaning
Add PropertysplitCity nvarchar(235);

update Nashvillecleaning
set  PropertysplitCity= SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1  ,LEN(propertyAddress))




 select
   OwnerAddress,
   Parsename(replace( ownerAddress ,',', '.'),3),
      Parsename(replace( ownerAddress ,',', '.'),2),
	     Parsename(replace( ownerAddress ,',', '.'),1),
		 SUBSTRING(ownerAddress,1,CHARINDEX(',', PropertyAddress)-1) as Address,
		 substring(ownerAddress, charindex(',', ownerAddress)+1 ,len(owneraddress)) as addd
from Projectsql..Nashvillecleaning
where OwnerAddress is not null




Alter table Nashvillecleaning
Add OwnersplitAddress nvarchar(235);

update Nashvillecleaning
set OwnersplitAddress =  Parsename(replace( ownerAddress ,',', '.'),3)


Alter table Nashvillecleaning
Add OwnersplitCity nvarchar(235);

update Nashvillecleaning
set OwnersplitCity=      Parsename(replace( ownerAddress ,',', '.'),2)


Alter table Nashvillecleaning
Add OwnersplitState nvarchar(235);

update Nashvillecleaning
set OwnersplitState=      Parsename(replace( ownerAddress ,',', '.'),1)

select * from Nashvillecleaning

--Change y to yes and n to no as vacant field
select
   distinct(SoldAsVacant), 
   count(SoldAsVacant) 
from
   Nashvillecleaning
   group by SoldAsVacant
   order by SoldAsVacant


   select SoldAsVacant,
   case when SoldAsVacant = 'Y' then 'YES'
        when SoldAsVacant = 'N' then 'No'
        else SoldAsVacant
        end
   from Nashvillecleaning

   update Nashvillecleaning
   set SoldAsVacant = case
   when SoldAsVacant = 'Y' then 'YES'
        when SoldAsVacant = 'N' then 'No'
        else SoldAsVacant
        end

		
--remove duplicates
with duplicate as
(
select *,
row_number()
over(partition by parcelID,
propertyAddress,
Saleprice,
SaleDate,
 LegalReference 
order by UniqueID)as rownum
from Nashvillecleaning

)
select * from duplicate
where rownum >1
--delete from duplicate
--where rownum > 1

--delete unsused colums 
   



-- with country (OwnerAddress)as
-- (
-- select OwnerAddress
--from Projectsql..Nashvillecleaning
--where OwnerAddress is not null
--)
--select count(*) from country

select * from Nashvillecleaning

--delete unsused colums 
Alter table Nashvillecleaning
drop column OwnerAddress, TaxDistrict, propertyAddress, SaleDate  