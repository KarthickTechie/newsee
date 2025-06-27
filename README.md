# newsee

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## NEW - LOGIN - UI

branch : new branch new-login-ui
created : 16/05/2025
purpose : to integrated and test new-login-ui created by developer @gayathri.b

## New Lead Feature

## Branch Name : new-lead-func

this branch contains UI and features with regards to New Lead - Detalis capturing
which includes forms for sourcing details , personal details , address details , loan details form design

# Ganesh Real Device Testing Comment

flutter run -d RZ8TA0WL7KW

git pull https://github.com/KarthickTechie/newsee.git download-progress-indicator

## proposal workflow

after a successful lead upload , bottom sheet will be open with leadId

step 1 : there show two button left button - Goto LeadInbox Right - CreateProposal

Step 2 : when CreateProposal is clicked show a bottom sheet with circular loader
saying creating proposal for lead Id - Lead/xxxx/xxxxx
Step 3 : once proposal creation is successful show success icon show two buttons
left button - goto proposal Inbox
Rightbutton - goto LandHolding Details

## Master Update

step 1:
to meticulously trace the logs to monitor master update lifecycle
create a auditlog table when login is successful.
id | log_date | time | feature | logdata | errorresponse

---

1 | 26-06-2025 | 10:44 | masterdowload | json string | api / runtime error

logdata = { 'page':'masterdownload','request':'','action':'tabledelete-lovmaster' , data:''}
logdata = { 'page':'masterdownload','request':'apirequest','action':'api-lovmaster' , data:''}
logdata = { 'page':'masterdownload','request':'','action':'tableinsert-lovmaster' , data:''}

step 2 :
create audit log page , have provision to choose date and time window and feature
query auditlog table and show reault as list
on click listtile , show a logdata in table , keep logdata json key to the left of the table
and value to the right column

this way user can see the auditlog data and can identify the rootcause at ease

further download logdata provision and upload to lendperfect server backend to be added

---
