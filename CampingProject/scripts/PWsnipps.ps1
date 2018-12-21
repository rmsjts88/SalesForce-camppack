# Sample statements


# try to log into devhub the -d sets as devhub org
$DevhubLogin = 'force:auth:web:login -d -a DevHub'
$Prms3 = $DevhubLogin.Split(" ")
&sfdx $Prms3

#Connect to the trailhead 2
$salesForceUrl = "https://resourceful-fox-8xva4d-dev-ed.lightning.force.com"
$User = 'rmsjts@resourceful-fox-8xva4d.com'
$Pass = 'eat2taco'
$Params = "force:auth:web:login -a Trail2 -r https://resourceful-fox-8xva4d-dev-ed.my.salesforce.com/"
$Prms = $Params.Split(" ")
&sfdx $Prms

# connect to a Dev Hub org and set it as your default 
# USe  the fox user and password when connecting
sfdx force:auth:web:login --setdefaultdevhubusername --setalias my-devhub-org
 #Create a scratch org
sfdx force:org:create --definitionfile my-org-def.json --setdefaultusername --setalias my-scratch-org


# Create org from this project's json
$OrgParams = ' force:org:create -s -f config/project-scratch-def.json -a TempTestOrg'
$PrmsOeg = $OrgParams.Split(" ")
&sfdx $PrmsOeg

 #  testUser=   test-cmo4pikefbgn@example.com
 # pass  (19M)G$vh1
 #url = https://flow-saas-5299-dev-ed.cs60.my.salesforce.com/

 &sfdx force:user:display -u TempTestOrg
# View org config data
sfdx force:org:display -u TempTestOrg

#Create a user password
sfdx force:user:password:generate -u TempTestOrg

 #Log in
 &sfdx force:org:open -u TempTestOrg

# Install this https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5A00000295Ce
# Show the scratch orgs under a Devhub. Be sure to connect to the devhub first
$ConnectedOrgs = "force:org:list" 
&Sfdx $ConnectedOrgs
# $OrgUser = 'test-e6roxldiynk3@example.com' or test-7gdxt0juwhr1@example.com
# sfdx force:config:set defaultusername=test-7gdxt0juwhr1@example.com

&sfdx force:alias:list
#   &sfdx force:alias:set my-SB1-org=test-suxn5umqcsc0@example.com
&sfdx force:org:open -u TempTestOrg
return

# Retreive the package metadata
# run from within a folder and relative path to the folder to extract to
$SubPath = '.\ExtractedCamppack'

$call = "force:mdapi:retrieve -s -r $SubPath -u $user -p CampPack"
$Prms2 = $call.Split(" ")
&sfdx $Prms2
return

# Pull metadata from installed package
sfdx force:mdapi:retrieve -s -r ./mdapipackage -p DreamInvest -u TempTestOrg -w 10
# Extract the zip, delete the zip hen restructure
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
sfdx force:mdapi:retrieve -s -r ./MDapipackage -p CampPackUnmanaged -u TempTestOrg -w 10
# Then unzip, remove zip file and run
sfdx force:mdapi:convert -r mdapipackage/
# Now remove the extracted foder and files, test by deploying to new scratch org

# To push this project to scratch org
&sfdx force:source:push -u TempTestOrg
&sfdx force:user:permset:assign -n DreamInvest
&sfdx force:org:open

# To pull from the scratch org to this project
&sfdx force:source:pull -u TempTestOrg

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


# Then to import this, REmoved the 'lostmoose__' strings
sfdx force:data:tree:import --sobjecttreefiles data/Camper__c.json

sfdx force:data:tree:import --plan data/export-Camp-CampSite__c-Camp_Visit__c-plan.json


#sfdx force:data:tree:import --sobjecttreefiles data/lostmoose__CampSite__c.json
#sfdx force:data:tree:import --sobjecttreefiles data/lostmoose__Camp_Visit__c.json


########
### will push to TrailHead-2
#######

$salesForceUrl = "https://resourceful-fox-8xva4d-dev-ed.lightning.force.com"
$User = 'rmsjts@resourceful-fox-8xva4d.com'
$Pass = 'eat2taco'

#Connect to the trailhead 2
$Params = "force:auth:web:login -a Trail2 -r https://resourceful-fox-8xva4d-dev-ed.my.salesforce.com/"
$Prms = $Params.Split(" ")
&sfdx $Prms


&sfdx force:org:list
&sfdx force:alias:list

# Convert source so the mdapi can use it
&sfdx force:source:convert -d mdapioutput/

# To push this projects converted source to trailhead 2
&sfdx force:mdapi:deploy -d mdapioutput/ -u Trail2 -w 100

# Assing the permission set
&sfdx force:user:permset:assign -n DreamInvest -u Trail2

# Launch the org
sfdx force:org:open -u Trail2

