# CIC CHECK PAGE

    refer techical documentation [here] (lib\feature\cic_check\cic_check_page.dart)

## Test Cases covered:

            Applicant – Button label as *"Check CIBIL/CRIF"* - Click Check button - Button label turns to *"View CIBIL/CRIF"*  - Click View button - Downloads and opens PDF in viewer. - **TEST PASS**
            Co-Applicant – Button label as *"Check CIBIL/CRIF"* - Click Check button - Button turns to *"View CIBIL/CRIF"* - Click View button - Downloads and opens PDF in viewer. - **TEST PASS**
            When download fails - **SysmoAlert** is shown. - **TEST PASS**

# CROP DEDAILS PAGE UPDATE AND DELETE

## Test Cases covered:

            * Go Crop Details page added new to crop data and push to server. and go back and agian open crop 
              details page. it fetched the crop data and show in list. when open bottom sheet list of crop data show and click the oe crop data. these crop data details auto populate in form fidlds and now i madified and save and now check the modified data fetched perfectly and delete the crop data. it works fine.

            * Go to home page and in completed leads page. click proposal creation button, it call api shows   
              proposal creation failed. after that i do pull do refresh black screen not appear now and everything workig fine.     
