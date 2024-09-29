# Eventible README

* Ruby version\
`ruby-2.7.0`
* Rails Version\
`6.0.3`

* System dependencies\
//TODO
* Database creation\
`rails db:create`\
`rails db:migrate`

* Database initialization\
`rails db:seed`

* How to run the test suite\
`rspec spec/`

* Deployment instructions

* Sample ENV file\
`./env.sample`


### Setup Steps:
1. Ruby Version: `2.7.0`
2. Rails Version: `6.0.3`
3. Install gems
  - Run command on your terminal: `bundle install`
4. Configure [**database.sample.yml**](https://github.com/eventible2021/eventible-backend/blob/readme-setup-changes/config/database.yml.sample) file in config/ 
5. Configure [**audited.sample.yml**](https://github.com/eventible2021/eventible-backend/blob/readme-setup-changes/config/audited.yml.sample) file in config/
6. Database creation:
  - Run command on your terminal:
    - > `rake db:create`
    - > `rake db:migrate`
7. Start rails server:
  - Run command on your terminal: `rake server`


# Development and deployment steps
### Development steps:
  1. Branching strategy:
   - > If you are going to work on new feature then create a branch from **master**
   - > If you are going to work on bug then create a branch from **master**
  2. PR labeling:
   - > after completed development of feature. raise PR against **staging** and labeled that PR according to feature/bug/enhancement/hold
   - > when PR gets approved then labeled it like staging ready/ production ready so that developer will get know to which PR is going to staging and which is production.
  3. Merge:
   - > every PR will get merge in staging first and after testing it will get merge into master and then delete the featured or bug branch from repo.


### Releases management step:
  > For Release management Follow [Git release management kit](https://intranet.joshsoftware.com/uploads/attachment/document/5fc762e46f4eea522300001d/Github_Release_Management.pdf)


### Deployment Steps:
  1. Using Mina:
  -  Run command on terminal **mina deploy server=production**
  - default server is staging don't pass server for staging deployment

  2. Using Jenkins:
   - Contact to manager for jenkins credentials. and login to jenkins and deploy the code  

### Some useful commands:
  * Start puma:
    - > mina puma:start server=*server name*
  * Stop puma:
    - > mina puma:stop server=*server name*
  * Restart puma:
    - > mina puma:phased_restart server=*server name*

### Tips to use postman collection
  * Set Environment
    - > to set environment [Click Here](https://learning.postman.com/docs/sending-requests/managing-environments/)
  * set endpoint as environment variable
    - > while creating environment set endpoint variable according to environment
  * set accept header to collection
    1. to set headers to collection
      - click on collection folder
      - click on edit
      - add below line in pre-request script section
      - > pm.request.headers.add({key: 'Accept', value: 'application/vnd.eventible.com; version=1' })
    2. add below line in pre-request script section of every request which is require authorization header
    - > pm.request.headers.add({Key:"Authorization", value: pm.collectionVariables.get("Authorization")})
   3. add below line in test script od sign in requests
       - > pm.test("Set JWT Token",function(){ var jsonData = pm.response.json() pm.collectionVariables.set("Authorization",jsonData.token) })

### To skip git pre hooks
  - > use --no-verify flag when you create commit
