# Sample statements

# Show the scratch orgs under a Devhub. Be sure to connect to the devhub first
&Sfdx force:org:list
# If no devhub then make a connection

# connect to a Dev Hub org and set it as your default 
# USe  the fox user and password when connecting
$DevHubAlias = "my-devhub-org"
sfdx force:auth:web:login --setdefaultdevhubusername --setalias $DevHubAlias
# or
# try to set name of the 'Dev Hub'  org
sfdx force:config:set defaultdevhubusername=my-devhub-org

# or
$DevhubLogin = 'force:auth:web:login -d -a DevHub'
$Prms3 = $DevhubLogin.Split(" ")
&sfdx $Prms3

#Connect to the trailhead 2
$salesForceUrl = "https://resourceful-fox-8xva4d-dev-ed.my.salesforce.com"
$salesForceUrl = "https://resourceful-otter-omj6ne-dev-ed.my.salesforce.com"
$User = 'rmsjts@resourceful-fox-8xva4d.com'
#$Pass = 'eat1taco'
$UserTrail3 = "rmsjts@resourceful-otter-omj6ne.com"
$Params = "force:auth:web:login -a Trail3 -r " + $salesForceUrl 
$Prms = $Params.Split(" ")
&sfdx $Prms
  #on the dev hub goto Active Scratch orgs


 #Create a scratch org, adujst the json file name... don't use
sfdx force:org:create --definitionfile my-org-def.json --setdefaultusername --setalias my-scratch-org-1
# or
# Create org from this project's json
$MyTempTestOrgName = "TempTestOrg-2"

$OrgParams = ' force:org:create -s -f config/project-scratch-def.json -a ' + $MyTempTestOrgName
$PrmsOeg = $OrgParams.Split(" ")
&sfdx $PrmsOeg

 #  testUser=   test-cmo4pikefbgn@example.com
 # pass  (19M)G$vh1
 #url = https://flow-saas-5299-dev-ed.cs60.my.salesforce.com/

 &sfdx force:user:display -u $MyTempTestOrgName
# View org config data
sfdx force:org:display -u $MyTempTestOrgName

#Create a user password, if desired
sfdx force:user:password:generate -u $MyTempTestOrgName

 #Log in
 &sfdx force:org:open -u $MyTempTestOrgName

# Install this https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5A00000295Ce
# Show the scratch orgs under a Devhub. Be sure to connect to the devhub first
&Sfdx force:org:list

&sfdx force:alias:list

&sfdx force:org:open -u $MyTempTestOrgName
return

# Retreive the package metadata
# run from within a folder and relative path to the folder to extract to
$SubPath = '.\ExtractedCamppack'

$call = "force:mdapi:retrieve -s -r $SubPath -u $user -p CampPack"
$Prms2 = $call.Split(" ")
&sfdx $Prms2
return

# Pull metadata from an installed package
sfdx force:mdapi:retrieve -s -r ./mdapipackage -p DreamInvest -u $MyTempTestOrgName -w 10
# Extract the zip, delete the zip then restructure
sfdx force:mdapi:convert -r mdapipackage/
# This puts the files under force-app, once done deletd the original folder of the extract

# try to log into devhub the -d sets as devhub org
$DevhubLogin = 'force:auth:web:login -d -a DevHub'
$Prms3 = $DevhubLogin.Split(" ")
&sfdx $Prms3

# Can close the broser, log back via sfdx force:org:open -u DevHub
return


$Shortcommand = 'force:source:status'
&sfdx $Shortcommand
return

############ get and push metedata
#----------------------------------- 
# Pull from installed packages to local folder
sfdx force:mdapi:retrieve  -s -r ./MDapipackage -p CampPackUnmanaged -u $MyTempTestOrgName -w 10
# Then unzip, remove zip file and run
sfdx force:mdapi:convert -r mdapipackage/
# Now remove the extracted foder and files, test by deploying to new scratch org

# To push this project to scratch org
&sfdx force:source:push -u $MyTempTestOrgName  -f
&sfdx force:user:permset:assign -n CampPackAccess

# Push data to scratch org
sfdx force:data:tree:import -h
sfdx force:data:tree:import -u TempTestOrg-2 --sobjecttreefiles data/Camper__c.json
sfdx force:data:tree:import -u $MyTempTestOrgName --plan data/export-Camp-CampSite__c-Camp_Visit__c-plan.json

&sfdx force:org:open

####################
# To pull from the scratch org to this project
################
&sfdx force:source:status -u $MyTempTestOrgName
&sfdx force:source:pull -u $MyTempTestOrgName

# To copy some data from scratch org
sfdx force:data:tree:export -h
sfdx force:data:tree:export -q "SELECT Name, Location__Latitude__s, Location__Longitude__s,Description FROM Account WHERE Location__Latitude__s != NULL AND Location__Longitude__s != NULL" -d ./data


$QueryStringCamperList = '"SELECT Id, Name, lostmoose__Features__c, lostmoose__Length__c, lostmoose__Purchase_Date__c FROM lostmoose__Camper__c"'


$QueryStringCampVisit = '(SELECT Name, lostmoose__CampSite__c, lostmoose__Checkin_Date__c, lostmoose__Length_of_Stay__c, lostmoose__Site_Features__c, lostmoose__Site_Number__c  FROM lostmoose__CampVisits__r)'

$CombindedVisitSite = '"SELECT Name, lostmoose__Best_Sties__c, lostmoose__Electric_Hookup__c, lostmoose__General_Notes__c, lostmoose__Last_Stay__c, lostmoose__Location__c, '+ $QueryStringCampVisit +' FROM lostmoose__CampSite__c"';


$Commands = "force:data:tree:export;--query;$CombindedVisitSite;-u;Trail1;--prefix;export-Camp;--outputdir;./data;--plan"
$QueryPrms = $Commands.Split(";")
$QueryPrms 
&sfdx $QueryPrms

$Commands = "force:data:tree:export;--query;$QueryStringCamperList;-u;Trail1;--outputdir;./data"
$QueryPrms = $Commands.Split(";")
$QueryPrms 
&sfdx $QueryPrms


# Then to import this, Removed the 'lostmoose__' strings
sfdx force:data:tree:import --sobjecttreefiles data/Camper__c.json
sfdx force:data:tree:import --plan data/export-Camp-CampSite__c-Camp_Visit__c-plan.json


#sfdx force:data:tree:import --sobjecttreefiles data/lostmoose__CampSite__c.json
#sfdx force:data:tree:import --sobjecttreefiles data/lostmoose__Camp_Visit__c.json


##########################
### will push to TrailHead-2
### with MetaData api
#########################

$salesForceUrl = "https://resourceful-fox-8xva4d-dev-ed.lightning.force.com"
$User = 'rmsjts@resourceful-fox-8xva4d.com'
#$Pass = 'eat2taco'

#Connect to the trailhead 2
$TrailHeadAlias = "Trail2"
$Params = "force:auth:web:login -a $TrailHeadAlias -r https://resourceful-fox-8xva4d-dev-ed.my.salesforce.com/"
$Prms = $Params.Split(" ")
&sfdx $Prms


&sfdx force:org:list
&sfdx force:alias:list

#### Deploy to a trailhead  ####
# 1. Convert source so the mdapi can use it (Create child folder named mdapioutput)
&sfdx force:source:convert --outputdir mdapioutput/

# 2. To push this projects converted source to trailhead 2 or Trail3
&sfdx force:mdapi:deploy -d mdapioutput/ -u $TrailHeadAlias -w 100
&sfdx force:source:deploy -h  # not a reccomended deploy, will pull from force-app folder

# 3. Assign the permission set
&sfdx force:user:permset:assign -n CampPackAccess -u $TrailHeadAlias

# Launch the org
sfdx force:org:open -u $TrailHeadAlias

# Unlocked package which can be pushed to SBX or prod, really is only manual process to create and push
sfdx force:package:version:create -h
sfdx force:package:install -h

# Sample unlock package create, set in the sfdx-package.json 
# 1. 
$PackageAlias = "unlockedCampPack"
# sfdx force:package2:create -h I don't know what the package2 is.
sfdx force:package:create  --name $PackageAlias --description "My first sample  package" --packagetype Unlocked --path force-app --nonamespace --targetdevhubusername $DevHubAlias
# the sfdx-project.json will be updated

# Change the version name and number, (if desired)

# 2.
$KeyForPackage = "test1234"
# could use --installationkeybypass
sfdx force:package:version:create  -p $PackageAlias -d force-app -k $KeyForPackage  --wait 10 -v $DevHubAlias

# now you can install, use the package alias from the json 
# 3.
# force: :version:list :version:display
sfdx force:package:list

sfdx force:source:status -u $MyTempTestOrgName

&sfdx force:package:version:list # -h 
$PackageNameVerAlias = "unlockedCampPack@0.1.0-1"
$PackageNameVerAlias = "unlockedCampPack@0.1.0-2"
sfdx force:package:install --wait 10 --publishwait 10 --package $PackageNameVerAlias -k $KeyForPackage -r -u $TrailHeadAlias
sfdx force:package:install --wait 10 --publishwait 10 --package $PackageNameVerAlias -k $KeyForPackage -r -u $MyTempTestOrgName

sfdx force:data:tree:import -u  $TrailHeadAlias --sobjecttreefiles data/Camper__c.json

sfdx force:data:tree:import -u $TrailHeadAlias --plan data/export-Camp-CampSite__c-Camp_Visit__c-plan.json