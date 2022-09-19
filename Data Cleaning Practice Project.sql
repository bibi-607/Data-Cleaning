----------CLEANING DATA IN SQL  QUERIES----------------
select*
from dbo.NashvilleHousing

---------------STANDARDIZE DATE FORMATE----------
select saledateconverted,SaleDate,convert(date,SaleDate)
from dbo.NashvilleHousing

----------------	CHANGING FORMAT IN DATA SET------

update NashvilleHousing
set SaleDate= convert(date,SaleDate)


alter table NashvilleHousing
add saledateconverted date;

update NashvilleHousing
set SaleDateconverted= convert(date,SaleDate)

select SaleDateconverted,convert(date,SaleDate)
from dbo.NashvilleHousing


------------Populate the property address data---------------
select PropertyAddress
from dbo.NashvilleHousing
---where propertyaddress is not null
order by ParcelID


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[uniqueID]<>b.[uniqueID]
where a.PropertyAddress is null

update a
set PropertyAddress=isnull(a.propertyaddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[uniqueID]<>b.[uniqueID]
where a.PropertyAddress is null

------Now if we execute it we are not going to have any output because all 
--nulls have been replaced----


-------BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMN ADDRESS,CITY,STATE----
select Propertyaddress
from portfolioproject.dbo.NashvilleHousing



alter table NashvilleHousing
add propertysplitaddress Nvarchar(255)

update NashvilleHousing
Set PropertySplitAddress=SUBSTRING(PropertyAddress,1,Charindex(',',PropertyAddress) -1)

alter table NashvilleHousing
add PropertySplitCity nvarchar(255);
update NashvilleHousing
set PropertySplitCity= substring(PropertyAddress, Charindex(',', PropertyAddress) +1, LEN(PropertyAddress))


select*
from portfolioproject.dbo.NashvilleHousing



---

-----split the owner address
select OwnerAddress
from portfolioproject.dbo.NashvilleHousing

select 
parsename(replace(OwnerAddress,',','.') , 3),
parsename(replace(OwnerAddress,',','.') , 2),
parsename(replace(OwnerAddress,',','.') ,1)
from portfolioproject.dbo.NashvilleHousing

alter table NashvilleHousing
add Ownersplitaddress Nvarchar(255)

update NashvilleHousing
Set OwnerSplitAddress = parsename(replace(OwnerAddress,',','.') , 3)

alter table NashvilleHousing
add OwnerSplitCity nvarchar(255);
update NashvilleHousing
set OwnerSplitCity= parsename(replace(OwnerAddress,',','.') , 2)

alter table NashvilleHousing
add OwnerSplitState nvarchar(255);
update NashvilleHousing
set OwnerSplitState= parsename(replace(OwnerAddress,',','.') , 1)

select*
from portfolioproject.dbo.NashvilleHousing

---cHANGE Y AND N TO YES AND NO IN SOLD AS VACANT FIELD
select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2



select SoldAsVacant
, case when SoldAsVacant='Y' then 'YES'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
end
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SoldAsVacant= case when SoldAsVacant= 'Y'then 'YES'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
end


----Removing duplicates--
with RowNumCTE as(
select*,
ROW_NUMBER() over(
partition by parcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
Order by 
UniqueID
) row_num
from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
delete
from RownumCTE
where row_num>1
--ORDER BY PropertyAddress

--order by PropwertyAddress


select*
from PortfolioProject.dbo.NashvilleHousing
alter table PortfolioProject.dbo.NashvilleHousing
drop column OwnerAddress,TaxDistrict,PropertyAddress,SaleDate

select*
from PortfolioProject.dbo.NashvilleHousing
alter table PortfolioProject.dbo.NashvilleHousing
drop column SaleDate