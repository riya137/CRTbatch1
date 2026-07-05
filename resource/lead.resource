*** Settings ***
Documentation             Example resource file with custom keywords. NOTE: Some keywords below may need
...                       minor changes to work in different instances.
Library                   QForce
Library                   String
Library                   DateTime
Library                   Collections
Library                   FakerLibrary


*** Variables ***
# IMPORTANT: Please read the readme.txt to understand needed variables and how to handle them!!
${BROWSER}                chrome
${home_url}               ${login_url}/lightning/page/home

     # Salesforce instance. NOTE: Should be overwritten in CRT variables



*** Keywords ***
LeadCreation_page
    #author               Riya Neema
    [Documentation]        It is to create the lead in salesforce from lead.resource
    
    VerifyText                Home
    LaunchApp                 Sales
    ClickText                 Leads
    VerifyText                Change Owner
    ClickText                 New                         partial_match=False
    VerifyText                Lead Information
    UseModal                  On                          # Only find fields from open modal dialog

    Picklist                  Salutation                  Ms.
    TypeText                  First Name                  Riya
    TypeText                  Last Name                   Neema
    Picklist                  Lead Status                 Open - Not Contacted
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

    Picklist                  Lead Source                 Web
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

