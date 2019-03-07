# You will need an org that is set as the DevHub, currently is trailhead-2


# look for devhub first has a (D)
&Sfdx force:org:list
&sfdx force:alias:list
# If no devhub then make a connection
# connect to a Dev Hub org and set it as your default 
# Use  the fox user and password when connecting
sfdx force:auth:web:login --setdefaultdevhubusername --setalias my-devhub-org
# or
# try to set name of the 'Dev Hub'  org
sfdx force:config:set defaultdevhubusername=my-devhub-org


# Create org from this project's json
$MyTempTestOrgName = "TempTestOrg-2"  # This var is used in the pull and push of code (metadata)
#$MyTempTestOrgName = "my-devhub-org"
$OrgParams = ' force:org:create -s -f config/project-scratch-def.json -a ' + $MyTempTestOrgName
$PrmsOrg = $OrgParams.Split(" ")
&sfdx $PrmsOrg

{
  &sfdx force:user:display -u $MyTempTestOrgName
# View org config data
  sfdx force:org:display -u $MyTempTestOrgName
#Create a user password, if desired
  sfdx force:user:password:generate -u $MyTempTestOrgName
}

#Log in to scratch org
&sfdx force:org:open -u $MyTempTestOrgName

############ get and push metedata and real data

# To push this project to scratch org add -f to --forceoverwrite an overwrite for any conflicts
&sfdx force:source:push -u $MyTempTestOrgName
&sfdx force:user:permset:assign -n CampPackAccess

# Push data to scratch org
# sfdx force:data:tree:import -h  # Just to show help
sfdx force:data:tree:import -u $MyTempTestOrgName --plan data/export3-Camp-Camper__c-CampPrep__c-plan.json

sfdx force:data:tree:import -u $MyTempTestOrgName --sobjecttreefiles data/export2-Camp-Camper__c.json

sfdx force:data:tree:import -u $MyTempTestOrgName --plan data/exportFox-Camp-CampSite__c-Camp_Visit__c-plan.json


# To pull metadata from the scratch org to this project
&sfdx force:source:pull -u $MyTempTestOrgName

# To copy some data from scratch org
$QueryStringCamperPrep = '(SELECT Name, Bathroom__c, Bedding__c,Camper__c,Food__c, Front_Storage__c,State__c,Water__c FROM CampPreps__r)'
$QueryStringCamper = '"SELECT Name, Features__c, Fresh_Water_Tank_Capacity__c, Trailer_Height__c, Empty_Weight__c, Length__c, Purchase_Date__c, ' + $QueryStringCamperPrep + ' FROM Camper__c"'
$QueryStringCampVisit = '(SELECT Name, CampSite__c, Checkin_Date__c, Length_of_Stay__c, Site_Features__c, Site_Number__c  FROM CampVisits__r)'
$CombindedVisitSite = '"SELECT Name, Best_Sties__c, Electric_Hookup__c, General_Notes__c, Last_Stay__c, Location__c, '+ $QueryStringCampVisit +' FROM CampSite__c"';

$Commands = "force:data:tree:export;--query;$CombindedVisitSite;-u;$MyTempTestOrgName;--prefix;exportFox-Camp;--outputdir;./data;--plan"
$QueryPrms = $Commands.Split(";")
$QueryPrms 
&sfdx $QueryPrms

$Commands = "force:data:tree:export;--query;$QueryStringCamper;-u;$MyTempTestOrgName;--prefix;export3-Camp;--outputdir;./data;--plan"
$QueryPrms = $Commands.Split(";")
$QueryPrms 
&sfdx $QueryPrms


################################
##  will push to TrailHead-3  ##
################################

$salesForceUrl = "https://resourceful-fox-8xva4d-dev-ed.lightning.force.com"
$User = 'rmsjts@resourceful-fox-8xva4d.com'
 # eat  2

 #Trail 3 rmsjts@resourceful-otter-omj6ne.com  eat 2

#Connect to the trailhead 2 and create alias if not already created
$Params = "force:auth:web:login -a Trail2 -r https://resourceful-fox-8xva4d-dev-ed.my.salesforce.com/"
$Prms = $Params.Split(" ")
&sfdx $Prms


# Convert source so the mdapi can use it (Create child folder named mdapioutput)
&sfdx force:source:convert -d mdapioutput/

# To push this projects converted source to trailhead 3
&sfdx force:mdapi:deploy -d mdapioutput/ -u Trail3 -w 100

# Assing the permission set
&sfdx force:user:permset:assign -n CampPackAccess -u Trail3

# Launch the org
sfdx force:org:open -u Trail3

sfdx force:package:install -h

sfdx force:data:tree:import -u  Trail3 --sobjecttreefiles data/Camper__c.json
sfdx force:data:tree:import -u Trail3 --plan data/export-Camp-CampSite__c-Camp_Visit__c-plan.json

