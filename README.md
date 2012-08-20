fitforce
========

   * Recent version of Jespers sfdc oath playground on Github
      * https://github.com/jesperfj/sfdc-oauth-playground
   * Whats been modified to the sfdc_oauth_playground?
      * Custom field Fitbit User Id added to OAuth Token
      * OAuth.cls with one line at 154: t.Fitbit_User_Id__c = rp.get('encoded_user_id');
      * Thats it!!
   * Dependencies
      * Chatter needs to be activated
   * Add to your Profile
   * Custom App Settings
      * OAuth Consumer Playground: Visible
   * Tab Settings
      * API Tester: Default On
      * My Fitbit Profile: Default On
      * OAuth Services: Default On
      * Authorize: Default On
   * Verify that your Profile has access to the following objects
      * OAuth Services
      * OAuth Tokens
      * Saved URLs
   * Create your OAuth Service
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
   * Get your user signed up
      * Go to My Fitbit Profile tab
      * Click the link: Click Here if you would like to Authorize
      * Make sure select drop down is on fit force and click authorize
      * Login with your Fitbit record and Authorize Application
   * Share with Chatter!!
      * Create a Collaboration Group called "Fitbit Owners" without the quotes
      * Go back to My Fitbit Profile tab
      * Chatter starts out Hiddem
      * Click Broadcast My Results to show off your results!
