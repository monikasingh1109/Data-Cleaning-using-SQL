select * from [dbo].[HousingPrice]

--Date format
update HousingPrice
set SaleDate=(convert(date,SaleDate)) 

select SaleDate from [dbo].[HousingPrice]

Alter table HousingPrice
Add SaleDate2 Date

update HousingPrice
set SaleDate2=(convert(date,SaleDate)) 

select SaleDate2 from [dbo].[HousingPrice]

--Populating Null values

select * from HousingPrice
where PropertyAddress is null

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
 from HousingPrice a
 Join HousingPrice b
 on a.ParcelID=b.ParcelID
 and a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null

 update a
set a.PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
 from HousingPrice a
 Join HousingPrice b
 on a.ParcelID=b.ParcelID
 and a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null

 select PropertyAddress from HousingPrice
 where PropertyAddress is null


 --Spliting PropertyAddress into multiple Columns using SUBSTRING

 select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
 SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, Len(PropertyAddress)) as City
 from HousingPrice


 Alter table HousingPrice
 add PropertyAdd nvarchar(255)

update HousingPrice
set PropertyAdd= SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


alter table HousingPrice
add PropertyCity nvarchar(255)

update HousingPrice
set PropertyCity= SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, Len(PropertyAddress))

select * from HousingPrice

select OwnerAddress from HousingPrice

--Spliting PropertyAddress into multiple Columns using PARSENAME

select 
ParseName(Replace(OwnerAddress,',','.'),3),
ParseName(Replace(OwnerAddress,',','.'),2),
ParseName(Replace(OwnerAddress,',','.'),1)
from HousingPrice


 Alter table HousingPrice
 add OnwerAdd nvarchar(255)

update HousingPrice
set OnwerAdd= ParseName(Replace(OwnerAddress,',','.'),3)

 Alter table HousingPrice
 add OnwerCity nvarchar(255)

update HousingPrice
set OnwerCity= ParseName(Replace(OwnerAddress,',','.'),2)

 Alter table HousingPrice
 add OwnerCountry nvarchar(255)

update HousingPrice
set OwnerCountry= ParseName(Replace(OwnerAddress,',','.'),1)

select * from HousingPrice


--Replaced SoldAsVacant columns with Y and N

select Distinct(SoldAsVacant),Count(SoldAsVacant)
from HousingPrice
group by SoldAsVacant
order by 2

update HousingPrice
set SoldAsVacant=
Case 
	when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'N' Then 'No'
	else SoldAsVacant
End


--Removing duplicates

select * from HousingPrice


WITH RowNumCTE as(
select * ,
row_number() over
					(partition by 
					ParcelID,
					PropertyAddress,
					SaleDate,
					LegalReference,
					SalePrice
					order by
					UniqueID) row_num
from HousingPrice
)
select * from RowNumCTE
where row_num>1


--Deleteing unnecessary columns

select * from HousingPrice


Alter table HousingPrice
Drop column SaleDate,PropertyAddress,OwnerAddress,TaxDistrict