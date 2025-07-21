
Test Case :

Dialpad UI Behavior from Lead Tile Card:
When a user taps on a mobile number from the Lead Tile Card widget, the dialer should be triggered. Based on specific conditions, certain UI elements must be shown or hidden accordingly.

Integration of kWillPopScope Widget:
Implement the kWillPopScope widget to control back navigation behavior. If any form field has been modified and not saved, a confirmation dialog should appear, warning the user about unsaved changes.

with out saving loan details , any tab  should not be active:
Verify that all other tabs (Dedupe, Personal, Address, Co-Applicant, Lead Submit) are inaccessible unless the Loan tabs status is SaveStatus.success .

Scaffold UI:
User must not be able to switch to any tab (Dedupe, Personal, Address, Co-Applicant, Submit) unless the Loan tab is saved .

Co-Applicant page field has "No" selected by default.


