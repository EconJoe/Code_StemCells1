
*****************************************************************************************
*****************************************************************************************
* VERSION 1
cd B:\Research\RAWDATA\MeSH\2016\Parsed
import delimited "desc2016_meshtreenumbers.txt", clear delimiter(tab) varnames(1)
keep if regexm(treenumber, "A11.872")
keep meshid
rename meshid ui
duplicates drop
tempfile hold
save `hold', replace

cd D:\Research\RAWDATA\MEDLINE\2016\Parsed\MeSH
import delimited "medline16_mesh_ui.txt", clear delimiter(tab) varnames(1)
merge m:1 ui using `hold'
drop if _merge==2
gen stemcell_=0
replace stemcell_=1 if _merge==3
drop _merge
by pmid, sort: egen stemcell=max(stemcell_)
drop stemcell_
keep if stemcell==1
drop stemcell

compress
cd D:\Research\Projects\StemCells\StemCells3\Code_StemCells3
save stemcellarticles_meshbased, replace
*****************************************************************************************




*****************************************************************************************
*****************************************************************************************
* VERSION 2
clear
gen meshid=""
cd D:\Research\Projects\StemCells\StemCells3\Data
tempfile stemcellcore
save `stemcellcore', replace

cd B:\Research\RAWDATA\MeSH\2016\Parsed
import delimited "desc2016_meshtreenumbers.txt", clear delimiter(tab) varnames(1)
replace mesh=lower(mesh)
gen stemcell=0
replace stemcell=1 if regexm(mesh, "stem cell")
keep if stemcell==1
keep treenumber
duplicates drop

set more off
levelsof treenumber, local(levels) 
foreach l of local levels {
	
	cd B:\Research\RAWDATA\MeSH\2016\Parsed
	import delimited "desc2016_meshtreenumbers.txt", clear delimiter(tab) varnames(1)
	keep if regexm(treenumber, "`l'")
	
	cd D:\Research\Projects\StemCells\StemCells3\Data
	append using `stemcellcore'
	save `stemcellcore', replace
 }
 
keep meshid
rename meshid ui
duplicates drop
save `stemcellcore', replace 

cd D:\Research\RAWDATA\MEDLINE\2016\Parsed\MeSH
import delimited "medline16_mesh_ui.txt", clear delimiter(tab) varnames(1)
merge m:1 ui using `stemcellcore'
drop if _merge==2
gen stemcell_=0
replace stemcell_=1 if _merge==3
drop _merge
by pmid, sort: egen stemcell=max(stemcell_)
drop stemcell_
keep if stemcell==1
drop stemcell

compress
cd D:\Research\Projects\StemCells\StemCells3\Data
save stemcellarticles_meshbased_2, replace
*****************************************************************************************
