# NOTE: readme.txt contains important information you need to take into account
# before running this suite.

*** Settings ***
Resource                        ../../resource/common.resource
Suite Setup                     Setup Browser
Suite Teardown                  End Suite


*** Variables ***
${day}=   Friday
@{nameOfMonths}=    January Feb Mar Apr
@{nameOfDays}=      Mon Tue Wed Thu Fri Sat Sun 
&{userInfo}=    Name=Riya    City=Indore    State=Madhya Pradesh    Area=Cloth Market


*** Test Cases ***
PrintingDayName
    [Setup]        Log To Console     this is testcase level setup side           #this is override the global level setting specific to test case
    [Teardown]     Log To Console     this is from test case level teardown side  #this is override the global level setting specific to test case
    Log To Console                    This is PrintingDayName TC

PrintingDateName
    [Setup]        NONE           #now setup is none, so it is override with global setting test setup
    [Teardown]     NONE           #now setup is none, so it is override with global setting test teardown
    Log To Console                    This is PrintingDateName TC

Variable n List Learning
    ${nameInTestCase}         Set Variable  Riya
    Log To Console            Name of the User defined in Test Case - ${nameInTestCase}
    
    ${weekDays}               Create List    Monday    Tuesday    Wednesday    Thursday    Friday    Saturday Sunday
    Log To Console            ${weekDays}[0]

    Log To Console            ${day}
    Log To Console            @{nameOfMonths}

    Lists Should Be Equal     ${nameOfMonths}  ${nameOfDays}
    List Should Not Contain Value              ${nameOfMonths}  June

    ${UserName}=             Get Dictionary Keys  ${userInfo} Name
    Log To Console           ${UserName}

Exercise 4 login with MFA   
    Appstate                  Home
    Login
    VerifyText                Home
    LogScreenshot

Exercise 5 Navigate and Verify App
    LaunchApp                 Sales
    ClickText                 Accounts
    VerifyPageHeader          Accounts
    VerifyText                New    
    ClickText                 Contacts
    VerifyPageHeader          Contacts
    VerifyText                New

Exercise 6 Create Contact And Verify
   LaunchApp                   Sales
   ClickText                   Contacts
   ClickText                   New
   UseModal
   TypeText                    First Name    CRT2
   TypeText                    Last Name     Demo User
   PickList                    Salutation    Mr.
   TypeText                    Email         crt2.demo@test.com
   ClickText                   Save  2
   ClickText                   Details
   VerifyField                 First Name    CRT2
   VerifyField                 Last Name     Demo User
   VerifyField                 Email         crt2.demo@test.com
   VerifyText                  CRT2 Demo User

Entering A Lead
    [tags]                    Lead
    Appstate                  Home
    Login
    VerifyText                Home
    LaunchApp                 Sales
    ClickText                 Leads
    VerifyText                Change Owner
    ClickText                 New                         partial_match=False
    VerifyText                Lead Information
    UseModal                  On                          # Only find fields from open modal dialog

    Picklist                  Salutation                  Ms.
    TypeText                  First Name                  Tina
    TypeText                  Last Name                   Smith
    Picklist                  Lead Status                 New
    # generate random phone number, just as an example
    # NOTE: initialization of random number generator is done on suite setup
    ${rand_phone}=            Generate Random String      14                          [NUMBERS]
    # concatenate leading "+" and random numbers
    ${phone}=                 SetVariable                 +${rand_phone}
    TypeText                  Phone                       ${phone}                    First Name
    TypeText                  Company                     Growmore                    Last Name
    TypeText                  Title                       Manager                     Address Information
    TypeText                  Email                       tina.smith@gmail.com        Rating
    TypeText                  Website                     https://www.growmore.com/

    Picklist                  Lead Source                 Partner
    ClickText                 Save                        partial_match=False
    UseModal                  Off
    Sleep                     1
    
    ClickText                 Details
    VerifyField               Name                        Ms. Tina Smith
    VerifyField               Lead Status                 New
    VerifyField               Phone                       ${phone}
    VerifyField               Company                     Growmore
    VerifyField               Website                     https://www.growmore.com/

    # as an example, let's check Phone number format. Should be "+" and 14 numbers
    ${phone_num}=             GetFieldValue               Phone
    Should Match Regexp	      ${phone_num}	              ^[+]\\d{14}$
    
    ClickText                 Leads
    VerifyText                Tina Smith
    VerifyText                Manager
    VerifyText                Growmore
    # just an example of using DateTime Library, let's just log today's date on the Log
    ${date} =	              Get Current Date
    Log                       Test run on: ${date}


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


