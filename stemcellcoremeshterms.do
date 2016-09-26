
clear
gen meshid=""
cd D:\Research\Projects\StemCells\StemCells2\Data
tempfile stemcellcore
save `stemcellcore', replace

cd B:\Research\RAWDATA\MeSH\2016\Parsed
import delimited "desc2016_meshtreenumbers.txt", clear delimiter(tab) varnames(1)
tempfile hold1
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
	
	cd D:\Research\Projects\StemCells\StemCells2\Data
	append using `stemcellcore'
	save `stemcellcore', replace
 }
 
keep meshid mesh
duplicates drop
sort meshid
cd D:\Research\Projects\StemCells\StemCells2\Data
export delimited using "stemcellcoremeshterms", replace
