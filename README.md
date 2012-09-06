fitforce
========

Installation
============

1. Checkout or download the [Fitforce](https://github.com/shobyabdi/fitforce) library from GitHub.

    ```bash
    $ git clone git@github.com:shobyabdi/fitforce.git
    ```

1. Install the [Force.com Migration Tool](http://www.salesforce.com/us/developer/docs/daas/Content/forcemigrationtool_install.htm) plugin for Ant, if you don't already have it.

1. Edit `install/build.properties` to insert your Salesforce username and password.  Since you will be using the API to access Salesforce, remember to [append your Security Token](http://www.salesforce.com/us/developer/docs/api/Content/sforce_api_concepts_security.htm#topic-title_login_token) to your password.

1. Open your command line to the `install` folder, then deploy using Ant:

    ```bash
    $ ant deployFitforce
    ```

Now all the library code is in your org and you're ready to start coding!

Profile Setup
===============
   * Custom App Settings
      * OAuth Consumer Playground: Visible
   * Tab Settings
      * API Tester: Default On
      * My Fitbit Profile: Default On
      * OAuth Services: Default On
      * Authorize: Default On
   * Verify that your Profile has read/write permissions to the following objects
      * OAuth Services
      * OAuth Tokens
      * Saved URLs

Application Setup
===============
   * Register your application with Fitbit
      * https://dev.fitbit.com/apps/new
      * Provide Application information and hit Register
      * Once you have registered and have application params, return to Fitforce application
   * Create your OAuth Service in the App
      * Go to OAuth Services tab
      * Click New
         * Service Name: fitforce
         * Other fields from App I registered in dev.fitbit.com
            * Request Token URL
            * Access Token URL
            * Consumer Key
            * Consumer Secret
            * Authorization URL
      * Hit Save
      * Now you can start signing up users!
   * Get your user signed up in the app
      * Go to My Fitbit Profile tab
      * Click the link: Click Here if you would like to Authorize
      * Make sure select drop down is on fit force and click authorize
      * Login with your Fitbit record and Authorize Application
   * Share with Chatter!!
      * Create a Collaboration Group called "Fitbit Owners" without the quotes
      * Go back to My Fitbit Profile tab
      * Chatter starts out Hidden
      * Click Broadcast My Results to show off your results!


Additional Info
============
   * Recent version of Jespers sfdc oath playground on Github
      * https://github.com/jesperfj/sfdc-oauth-playground
      * Not needed as the codebase is included in this repo, but a good reference
   * Whats been modified to the sfdc_oauth_playground?
      * Custom field Fitbit User Id added to OAuth Token
      * OAuth.cls with one line at 154: t.Fitbit_User_Id__c = rp.get('encoded_user_id');
      * Thats it!!
   * Dependencies
      * Chatter needs to be activated
