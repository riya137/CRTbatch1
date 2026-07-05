# NOTE: readme.txt contains important information you need to take into account
# before running this suite.

*** Settings ***
Resource                        ../../resource/common.resource
Resource                        ../../resource/lead.resource
Suite Setup                     Setup Browser
Suite Teardown                  End Suite


*** Test Cases ***
Entering A Lead
    Appstate                  Home
    LeadCreation_page

Converting A Lead To Opportunity-Account-Contact
    [tags]                    Lead
    Appstate                  Home
    LaunchApp                 Sales

    ClickText                 Leads
    ClickText                 Tina Smith

    ClickUntil                Convert Lead                Convert
    ClickText                 Opportunity                 2
    TypeText                  Opportunity Name            Growmore Pace
    ClickText                 Convert                     2
    VerifyText                Your lead has been converted                            timeout=30

    ClickText                 Go to Leads
    VerifyNoText              Go to Leads
    ClickText                 Opportunities
    VerifyText                Growmore Pace
    ClickText                 Accounts
    VerifyText                Growmore
    ClickText                 Contacts
    VerifyText                Tina Smith


Creating An Account
    [tags]                    Account
    Appstate                  Home
    LaunchApp                 Sales

    ClickText                 Accounts
    ClickUntil                Account Information         New    partial_match=False

    TypeText                  Account Name                Salesforce                  anchor=Parent Account
    TypeText                  Phone                       +12258443456789             anchor=Fax
    TypeText                  Fax                         +12258443456766
    TypeText                  Website                     https://www.salesforce.com
    Picklist                  Type                        Partner
    Picklist                  Industry                    Finance

    TypeText                  Employees                   35000
    TypeText                  Annual Revenue              12 billion
    ClickText                 Save                        partial_match=False

    ClickText                 Details
    VerifyText                Salesforce
    VerifyText                35,000


Creating An Opportunity For The Account
    [tags]                    Account
    Appstate                  Home
    LaunchApp                 Sales
    ClickText                 Accounts
    VerifyText                Salesforce
    VerifyText                Opportunities

    ClickUntil                Stage                       Opportunities
    ClickUntil                Opportunity Information     New    partial_match=False
    TypeText                  Opportunity Name            Safesforce Pace             anchor=Cancel   delay=2
    Combobox                  Search Accounts...          Salesforce
    Picklist                  Type                        New Business
    ClickText                 Close Date                  Opportunity Information
    ClickText                 Next Month
    ClickText                 Today

    Picklist                  Stage                       Prospecting
    TypeText                  Amount                      5000000
    Picklist                  Lead Source                 Partner
    TypeText                  Next Step                   Qualification
    TypeText                  Description                 This is first step
    ClickText                 Save                        partial_match=False         # Do not accept partial match, i.e. "Save All"

    Sleep                     1
    ClickText                 Opportunities
    VerifyText                Safesforce Pace


Change status of opportunity
    [tags]                    status_change
    Appstate                  Home
    ClickText                 Opportunities
    VerifyPageHeader          Opportunities
    ClickText                 Safesforce Pace             delay=2                     # intentionally delay action - 2 seconds
    VerifyText                Contact Roles

    ClickText                 Show actions for Contact Roles
    ClickText                 Add Contact Roles

    # verify all following texts from the dialog that opens
    VerifyAll                 Cancel, Show Selected, Name, Add Contact Roles
    ComboBox                  Search Contacts...          Tina Smith                  selection_delay=2
    ClickText                 Next                        delay=3
    ClickText                 Edit Role: Item
    ClickText                 --None--
    ClickText                 Decision Maker
    ClickText                 Save                        partial_match=False
    VerifyText                Tina Smith

    ClickText                 Mark Stage as Complete
    ClickText                 Opportunities               delay=2
    ClickText                 Safesforce Pace
    ClickText                 Details
    VerifyField               Stage                       Qualification
    VerifyStage               Qualification               true
    VerifyStage               Prospecting                 false
    VerifyStageColor          Qualification               navy
    VerifyStageColor          Prospecting                 green



Create A Contact For The Account
    [tags]                    salesforce.Account
    Appstate                  Home
    LaunchApp                 Sales
    ClickText                 Accounts
    VerifyText                Salesforce
    VerifyText                Contacts

    ClickUntil                Email                       Contacts
    ClickUntil                Contact Information         New    partial_match=False
    Picklist                  Salutation                  Mr.
    TypeText                  First Name                  Richard
    TypeText                  Last Name                   Brown
    TypeText                  Phone                       +00150345678134             anchor=Mobile
    TypeText                  Mobile                      +00150345678178
    Combobox                  Search Accounts...          Salesforce                  selection_delay=2

    TypeText                  Email                       richard.brown@gmail.com     anchor=Reports To
    TypeText                  Title                       Manager
    ClickText                 Save                        partial_match=False
    Sleep                     1
    ClickText                 Contacts
    VerifyText                Richard Brown


Delete Test Data
    [tags]                    Test data
    Appstate                  Home
    LaunchApp                 Sales
    ClickText                 Accounts
    VerifyText                Account Name

    Set Suite Variable        ${data}                     Salesforce
    RunBlock                  NoData                      timeout=180s                exp_handler=DeleteAccounts
    Set Suite Variable        ${data}                     Growmore
    RunBlock                  NoData                      timeout=180s                exp_handler=DeleteAccounts

    ClickText                 Opportunities
    VerifyPageHeader          Opportunities
    VerifyNoText              Safesforce Pace
    VerifyNoText              Growmore Pace
    VerifyNoText              Richard Brown
    VerifyNoText              Tina Smith

    # Delete Leads
    ClickText                 Leads
    VerifyText                Change Owner
    Set Suite Variable        ${data}                     Tina Smith
    RunBlock                  NoData                      timeout=180s                exp_handler=DeleteLeads
    Set Suite Variable        ${data}                     John Doe
    RunBlock                  NoData                      timeout=180s                exp_handler=DeleteLeads


