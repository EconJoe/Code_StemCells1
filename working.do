
cd B:\Research\RAWDATA\TorvikGroup
import delimited "mapaffil2015.tsv", clear delimiter(tab) varnames(1)
compress
save mapaffil2015, replace

use mapaffil2015, clear
gen count=1
collapse (sum) count, by(country) fast
gsort -count

use mapaffil2015, clear
keep if regexm(country, "USA")
compress
cd D:\Research\Projects\StemCells
save mapaffil2015_USA, replace

*cd D:\Research\Projects\StemCells\StemCells1\Data\DataFiles
*import delimited "stemcellarticles_meshbased.csv", clear varnames(1) delimiter(comma)
cd D:\Research\Projects\StemCells\StemCells3\Data
use stemcellarticles_meshbased_2, clear
keep if version==1
gen major_=(majortopic=="Y")
by pmid version meshgroup, sort: egen major=max(major_)
drop major_
keep if type=="Descriptor"
collapse (max) major, by(pmid) fast
duplicates drop
compress
cd D:\Research\Projects\StemCells
save stemcellarticles_meshbased_pmids, replace

use mapaffil2015_USA, clear
gen state_=""
replace state_="CA" if regexm(state, "CA")
replace state_="NY" if regexm(state, "NY")
replace state_="MA" if regexm(state, "MA")
replace state_="MD" if regexm(state, "MD")
replace state_="PA" if regexm(state, "PA")
replace state_="TX" if regexm(state, "TX")
replace state_="IL" if regexm(state, "IL")
replace state_="NC" if regexm(state, "NC")
replace state_="OH" if regexm(state, "OH")
replace state_="MI" if regexm(state, "MI")
replace state_="MN" if regexm(state, "MN")
replace state_="WA" if regexm(state, "WA")
replace state_="FL" if regexm(state, "FL")
replace state_="GA" if regexm(state, "GA")
replace state_="MO" if regexm(state, "MO")
replace state_="CT" if regexm(state, "CT")
replace state_="TN" if regexm(state, "TN")
replace state_="WI" if regexm(state, "WI")
replace state_="NJ" if regexm(state, "NJ")
replace state_="VA" if regexm(state, "VA")
replace state_="CO" if regexm(state, "CO")
replace state_="IN" if regexm(state, "IN")
replace state_="DC" if regexm(state, "DC")
replace state_="IA" if regexm(state, "IA")
replace state_="AL" if regexm(state, "AL")
replace state_="AZ" if regexm(state, "AZ")
replace state_="OR" if regexm(state, "OR")
replace state_="LA" if regexm(state, "LA")
replace state_="UT" if regexm(state, "UT")
replace state_="KY" if regexm(state, "KY")
replace state_="SC" if regexm(state, "SC")
replace state_="KS" if regexm(state, "KS")
replace state_="NE" if regexm(state, "NE")
replace state_="RI" if regexm(state, "RI")
replace state_="OK" if regexm(state, "OK")
replace state_="AR" if regexm(state, "AR")
replace state_="NH" if regexm(state, "NH")
replace state_="MS" if regexm(state, "MS")
replace state_="HI" if regexm(state, "HI")
replace state_="VT" if regexm(state, "VT")
replace state_="DE" if regexm(state, "DE")
replace state_="WV" if regexm(state, "WV")
replace state_="ME" if regexm(state, "ME")
replace state_="MT" if regexm(state, "MT")
replace state_="NV" if regexm(state, "NV")
replace state_="ND" if regexm(state, "ND")
replace state_="ID" if regexm(state, "ID")
replace state_="SD" if regexm(state, "SD")
replace state_="WY" if regexm(state, "WY")
replace state_="AK" if regexm(state, "AK")
replace state_="NM" if regexm(state, "NM")
drop if state_==""

destring pmid, replace
merge m:1 pmid using stemcellarticles_meshbased_pmids
drop if _merge==2
keep if _merge==3
keep pmid au_order major state_
save test2, replace

cd B:\Research\RAWDATA\MEDLINE\2016\Parsed\Dates\Clean
use medline16_all_dates, clear
keep if version==1
keep pmid year
cd D:\Research\Projects\StemCells
merge 1:m pmid using test2
drop if _merge==1
drop _merge
save test2, replace

cd D:\Research\Projects\StemCells
use article_forwardcites, clear
keep pmid fc_2yr
merge 1:m pmid using test2
drop if _merge==1
replace fc_2yr=0 if _merge==2
drop _merge
save test2, replace

use test2, clear
keep if year>=1995 & year<=2013
gen pubs=1
by pmid, sort: egen total=total(pubs)
gen pubs_frac=pubs/total
destring au_order, replace
gen pubs_1stauth = (au_order==1)
by pmid, sort: egen totalauth=max(au_order)
gen pubs_lastauth = (au_order==totalauth)

gen fc=fc_2yr
gen fc_frac=fc/total
gen fc_1stauth = fc if au_order==1
replace fc_1stauth=0 if au_order!=1
gen fc_lastauth = fc if au_order==totalauth
replace fc_lastauth=0 if au_order!=totalauth
drop fc_2yr
tempfile hold
save `hold', replace

keep pmid fc year state_
duplicates drop
by year state_, sort: egen fc_med = median(fc)
keep year state_ fc_med
duplicates drop
tempfile hold2
save `hold2', replace

use `hold', clear
collapse (sum) pubs* fc*, by(state_ year)
merge 1:1 year state_ using `hold2'
drop _merge

tempfile hold
save `hold', replace

clear
set obs 14
gen year=_n+1994
tempfile hold2
save `hold2', replace

use test2, clear
keep state_
duplicates drop
cross using `hold2'
merge 1:1 state_ year using `hold'
replace pubs=0 if _merge==1
replace pubs_frac=0 if _merge==1
replace pubs_1stauth=0 if _merge==1
replace pubs_lastauth=0 if _merge==1
replace fc=0 if _merge==1
replace fc_frac=0 if _merge==1
replace fc_1stauth=0 if _merge==1
replace fc_lastauth=0 if _merge==1
replace fc_med=0 if _merge==1
drop _merge


keep if state_=="CA" | state_=="MA" | state_=="NY" | state_=="MD"
gen ca=(state_=="CA")
gen post1=(year>2004)
gen post2=(year>2006)
gen post3=(year>2008)
reg pubs_frac i.ca i.post1 i.ca#i.post1 i.year, cluster(state_)
reg pubs_frac i.ca i.post1 i.ca#i.post1 i.year
reg pubs_frac i.ca i.post2 i.ca#i.post2 i.year, cluster(state_)
reg pubs_frac i.ca i.post2 i.ca#i.post2 i.year
reg pubs_frac i.ca i.post3 i.ca#i.post3 i.year, cluster(state_)
reg pubs_frac i.ca i.post3 i.ca#i.post3 i.year

reg pubs_1stauth i.ca i.post1 i.ca#i.post1 i.year, cluster(state_)
reg pubs_1stauth i.ca i.post1 i.ca#i.post1 i.year
reg pubs_1stauth i.ca i.post2 i.ca#i.post2 i.year, cluster(state_)
reg pubs_1stauth i.ca i.post2 i.ca#i.post2 i.year
reg pubs_1stauth i.ca i.post3 i.ca#i.post3 i.year, cluster(state_)
reg pubs_1stauth i.ca i.post3 i.ca#i.post3 i.year

reg pubs_lastauth i.ca i.post1 i.ca#i.post1 i.year, cluster(state_)
reg pubs_lastauth i.ca i.post1 i.ca#i.post1 i.year
reg pubs_lastauth i.ca i.post2 i.ca#i.post2 i.year, cluster(state_)
reg pubs_lastauth i.ca i.post2 i.ca#i.post2 i.year
reg pubs_lastauth i.ca i.post3 i.ca#i.post3 i.year, cluster(state_)
reg pubs_lastauth i.ca i.post3 i.ca#i.post3 i.year


parmby "reg pubs_frac i.year i.ca#i.year, cluster(state_)", norestore
keep if regexm(parm, "1.ca")
gen year=regexs(0) if regexm(parm, "[0-9][0-9][0-9][0-9]")
destring year, replace
twoway (connected estimate year) ///
       (connected min95 year) ///
       (connected max95 year), ///
	   xtitle("") ytitle("Fractionalized Publications") ///
	   xlabel(1995(1)2013, angle(forty_five)) ///
	   graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

encode state, gen(state)
tsset state year
synth pubs pubs(2000(1)2005), trunit(5) trperiod(2006) fig
synth fc_med fc(2000(1)2007), trunit(5) trperiod(2006) fig

twoway (connected pubs year if state_=="CA" & year>=1995 & year<=2014, msymbol(circle_hollow)) ///
       (connected pubs year if state_=="MA" & year>=1995 & year<=2014, msymbol(triangle_hollow)) ///
       (connected pubs year if state_=="WA" & year>=1995 & year<=2014, msymbol(square_hollow)), ///
	   legend(order(1 "CA" 2 "MA" 3 "WA")) ///
	   xtitle("") ytitle("Publications") ///
	   xlabel(1995(1)2013, angle(forty_five)) ///
	   graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export pubs.tif, replace
	   
twoway (connected pubs_frac year if state_=="CA" & year>=1995 & year<=2014, msymbol(circle_hollow)) ///
       (connected pubs_frac year if state_=="MA" & year>=1995 & year<=2014, msymbol(triangle_hollow)) ///
       (connected pubs_frac year if state_=="WA" & year>=1995 & year<=2014, msymbol(square_hollow)), ///
	   legend(order(1 "CA" 2 "MA" 3 "WA")) ///
	   xtitle("") ytitle("Fractionalized Publications") ///
	   xlabel(1995(1)2013, angle(forty_five)) ///
	   graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export pubs_frac.tif, replace
	   	   	   
twoway (connected pubs_1stauth year if state_=="CA" & year>=2000 & year<=2014, msymbol(circle_hollow)) ///
       (connected pubs_1stauth year if state_=="MA" & year>=2000 & year<=2014, msymbol(triangle_hollow)) ///
       (connected pubs_1stauth year if state_=="WA" & year>=2000 & year<=2014, msymbol(square_hollow)), ///
	   legend(order(1 "CA" 2 "MA" 3 "WA")) ///
	   xtitle("") ytitle("First Author Publications") ///
	   xlabel(2000(1)2013, angle(forty_five)) ///
	   graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export pubs_1stauth.tif, replace
	  	   	   	   
twoway (connected pubs_lastauth year if state_=="CA" & year>=2000 & year<=2014, msymbol(circle_hollow)) ///
       (connected pubs_lastauth year if state_=="MA" & year>=2000 & year<=2014, msymbol(triangle_hollow)) ///
       (connected pubs_lastauth year if state_=="WA" & year>=2000 & year<=2014, msymbol(square_hollow)), ///
	   legend(order(1 "CA" 2 "MA" 3 "WA")) ///
	   xtitle("") ytitle("Last Author Publications") ///
	   xlabel(2000(1)2013, angle(forty_five)) ///
	   graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export pubs_lastauth.tif, replace
	  	   	   	   
twoway (connected fc year if state_=="CA" & year>=2000 & year<=2011, msymbol(circle_hollow)) ///
       (connected fc year if state_=="MA" & year>=2000 & year<=2011, msymbol(triangle_hollow)) ///
       (connected fc year if state_=="WA" & year>=2000 & year<=2011, msymbol(square_hollow)), ///
	   legend(order(1 "CA" 2 "MA" 3 "WA")) ///
	   xtitle("") ytitle("2-Year Forward Cites") ///
	   xlabel(2000(1)2011, angle(forty_five)) ///
	   graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

twoway (connected fc_frac year if state_=="CA" & year>=2000 & year<=2011, msymbol(circle_hollow)) ///
       (connected fc_frac year if state_=="MA" & year>=2000 & year<=2011, msymbol(triangle_hollow)) ///
       (connected fc_frac year if state_=="WA" & year>=2000 & year<=2011, msymbol(square_hollow)), ///
	   legend(order(1 "CA" 2 "MA" 3 "WA")) ///
	   xtitle("") ytitle("2-Year Forward Cites Per Publication") ///
	   xlabel(2000(1)2011, angle(forty_five)) ///
	   graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

twoway (connected fc_med year if state_=="CA" & year>=2000 & year<=2011, msymbol(circle_hollow)) ///
       (connected fc_med year if state_=="MA" & year>=2000 & year<=2011, msymbol(triangle_hollow)) ///
       (connected fc_med year if state_=="WA" & year>=2000 & year<=2011, msymbol(square_hollow)), ///
	   legend(order(1 "CA" 2 "MA" 3 "WA")) ///
	   xtitle("") ytitle("Median 2-Year Forward Cites") ///
	   xlabel(2000(1)2011, angle(forty_five)) ///
	   graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	   
	   
twoway (connected test year if state_=="CA" & year>=2000 & year<=2014, msymbol(circle_hollow)) ///
       (connected test year if state_=="MA" & year>=2000 & year<=2014, msymbol(triangle_hollow)) ///
       (connected test year if state_=="WA" & year>=2000 & year<=2014, msymbol(square_hollow)), ///
	   legend(order(1 "CA" 2 "MA" 3 "WA")) ///
	   xtitle("") ytitle("2-Year Forward Cites") ///
	   xlabel(2000(1)2013, angle(forty_five)) ///
	   graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))


	   
twoway (connected pubs_frac year if state_=="CA" & year>=2000 & year<=2014, msymbol(circle_hollow)) ///
       (connected pubs_frac year if state_=="MA" & year>=2000 & year<=2014, msymbol(triangle_hollow)) ///
	   (connected pubs_frac year if state_=="NY" & year>=2000 & year<=2014,) ///
       (connected pubs_frac year if state_=="MD" & year>=2000 & year<=2014,) ///
       (connected pubs_frac year if state_=="WA" & year>=2000 & year<=2014, msymbol(square_hollow)), ///
	   legend(order(1 "CA" 2 "MA" 3 "NY" 4 "MD" 5 "WA")) ///
	   xtitle("") ytitle("Fractionalized Publications") ///
	   xlabel(2000(1)2013, angle(forty_five)) ///
	   graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export pubs_frac_.tif, replace
