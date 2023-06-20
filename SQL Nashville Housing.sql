--Standardize Data Format

SELECT SaleDate, SaleDayConverted
from NashvilleHousing

ALTER table NashvilleHousing 
ADD SaleDayConverted Date;

UPDATE NashvilleHousing
set SaleDayConverted = CONVERT(date, SaleDate)

SELECT SaleDate, SaleDayConverted
from NashvilleHousing

--Populate Property Adress Data

SELECT PropertyAddress
from NashvilleHousing
WHERE  PropertyAddress is not null

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a 
JOIN NashvilleHousing b  
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a  
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a 
JOIN NashvilleHousing b  
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Breaking address into Individual Columns (Adress, City, State)
select PropertyAddress  
from NashvilleHousing

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Adress,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, len(PropertyAddress))
from NashvilleHousing

ALTER table NashvilleHousing 
ADD PropertySplitAddress  NVARCHAR(255);

UPDATE NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER table NashvilleHousing 
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, len(PropertyAddress))

select OwnerAddress
From NashvilleHousing


select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3 ),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2 ),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1 )
From NashvilleHousing

ALTER table NashvilleHousing 
ADD OwnerSplitAddress  NVARCHAR(255);

UPDATE NashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3 )

ALTER table NashvilleHousing 
ADD OwnerSplitCity  NVARCHAR(255);

UPDATE NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2 )

ALTER table NashvilleHousing 
ADD OwnerSplitState  NVARCHAR(255);

UPDATE NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


--Change Y and N to Yes and No in 'Sold as vacant'
SELECT distinct(SoldAsVacant)
from NashvilleHousing


select SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' then 'Yes'
WHEN SoldAsVacant = 'N' then 'No'
else SoldAsVacant
END
from NashvilleHousing

UPDATE NashvilleHousing
set SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' then 'Yes'
WHEN SoldAsVacant = 'N' then 'No'
else SoldAsVacant
END


--Remove Duplicates
WITH  RowNumCTE as
 (
select *,
ROW_NUMBER() OVER ( PARTITION BY ParcelID, PropertyAddress, Saleprice, SaleDate, legalreference 
ORDER BY UniqueID) as RowNum
from NashvilleHousing
)
select *
FROM RowNumCTE
where RowNum > 1
order by PropertyAddress



--Remove Unused Columns
Select *
from NashvilleHousing

Alter TABLE NashvilleHousing
DROP COLUMN owneraddress, taxdistrict, propertyaddress 

Alter TABLE NashvilleHousing
DROP COLUMN saledate




