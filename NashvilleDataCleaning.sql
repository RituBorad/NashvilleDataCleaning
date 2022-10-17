-- Cleaning the data using SQL
Select * from PortfolioProject..NashvilleHousing;

-- Standardizing the date format

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = Convert(Date, SaleDate);

Select SaleDateConverted
From PortfolioProject..NashvilleHousing;

-- Populate property address data
Select * from PortfolioProject..NashvilleHousing
Where PropertyAddress is null
Order By ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
And a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null

-- Breaking up address into individual columns i.e. Address, City, State

Select PropertyAddress
from PortfolioProject..NashvilleHousing

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) As Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) As City
From PortfolioProject..NashvilleHousing 

Alter Table PortfolioProject..NashvilleHousing
Add PropertySplitAddress nvarchar(500);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table PortfolioProject..NashvilleHousing
Add PropertySplitCity nvarchar(500);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select * From PortfolioProject..NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From PortfolioProject..NashvilleHousing

Alter Table PortfolioProject..NashvilleHousing
Add OwnerSplitAddress nvarchar(500);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

Alter Table PortfolioProject..NashvilleHousing
Add OwnerSplitCity nvarchar(500);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Alter Table PortfolioProject..NashvilleHousing
Add OwnerSplitState nvarchar(500);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

Select * From PortfolioProject..NashvilleHousing

-- Changing Y to Yes and N to No in the 'SoldAsVacant' column

Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' then 'Yes'
	 When SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
END
From PortfolioProject..NashvilleHousing

Update NashvilleHousing 
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' then 'Yes'
	 When SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
END

-- Removing duplicates

With RowNumCTE As(
Select *,
Row_Number() OVER (
Partition By ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order By
			 UniqueID)
			 row_num
From PortfolioProject..NashvilleHousing
)
Select * 
from RowNumCTE
where row_num>1
order by PropertyAddress