// =========================================================================
// PATTERN: Session-Level Master Data Caching (App.Formulas)
// PURPOSE: Preloads SharePoint lookup tables into memory on startup to 
//          eliminate repetitive HTTP calls and bypass the 2,000-item delegation limit.
// =========================================================================

// 1. Authorized Plant Users Whitelist (RBAC)
fxCacheUsersPlants = 'Users_Plants_Whitelist';

// 2. Manufacturing Lines & Target Speeds
fxCacheLines = 'MasterData_Lineas';

// 3. Hierarchical Line -> Zone -> Equipment Mapping
fxCacheLineZones = 'MasterData_LineasZonas';

// 4. Official 13 OEE/TPM Downtime Categories
fxCacheDowntimeCategories = 'MasterData_Paradas';

// 5. Material Scrap & Waste Classifications
fxCacheScrapTypes = 'MasterData_Perdidas';

// 6. Operational Effects & Root Cause Catalog
fxCacheEffects = 'MasterData_Efectos';

// 7. Recipe Formulations (Doughs & Creams Matrices)
fxCacheRecipes = 'MasterData_MasasyCremas';
