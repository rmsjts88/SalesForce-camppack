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


# Create org from this project's json
$OrgParams = ' force:org:create -s -f config/project-scratch-def.json -a TempTestOrg'
$PrmsOeg = $OrgParams.Split(" ")
&sfdx $PrmsOeg

 #  testUser=   test-47vlfektac1l@example.com   newUser = ranjui@me.com   
 #url = https://momentum-business-1795-dev-ed.lightning.force.com

 &sfdx force:user:display -u TempTestOrg
# View org config data
sfdx force:org:display -u TempTestOrg

#Create a user password
sfdx force:user:password:generate -u TempTestOrg

 #Log in
 &sfdx force:org:open -u TempTestOrg


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



#log in with our cached authentication token to default user of scratchpad org
# Should be in the directory of the project. (Under dreamhouse-sfdx)
# test-suxn5umqcsc0@example.com
#sfdx force:config:set defaultusername=test-suxn5umqcsc0@example.com
# sfdx force:org:open
# &sfdx force:org:open -u my-SB1-org

# To push this project to scratch org
&sfdx force:source:push -u TempTestOrg
&sfdx force:user:permset:assign -n DreamInvest
&sfdx force:org:open

# To pull from the scratch org to this project
&sfdx force:source:pull

# To copy some data from scratch org
sfdx force:data:tree:export -q "SELECT Name, Location__Latitude__s, Location__Longitude__s,Description FROM Account WHERE Location__Latitude__s != NULL AND Location__Longitude__s != NULL" -d ./data
# Then to import this
sfdx force:data:tree:import --sobjecttreefiles data/Account.json


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

