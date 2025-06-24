## co applicant and guarantor feature

    in newleadpage , add co-applicant tab next to address tab
    show co-applicant form and bottom right corner place fab button with  badge
    badge will show the count of coapp count
    click on fab button , open bottomsheet to show coapp list
    click coapp listtile , update the form with coapp details

## Modal

    Modal - CoAppData Dataclass - should be in sync with CoAppDetailsForm

## state

    SaveStatus - init,success,update,failure
    List<CoAppData> coAppList - conatins all the saved coapp
    CoAppData selectedCoApp   - select the coapp from bottomsheet to update the details

## event

    CoAppDetailsInitEvent - set lov's for dropdowns
    CoAppDetailsSaveEvent - save coappdetails form
