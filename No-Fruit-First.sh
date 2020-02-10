#!/bin/bash
#
###############################################################################################################################################
#
# ABOUT THIS PROGRAM
#
#	No-Fruit-First.sh
#	https://github.com/Headbolt/No-Fruit-First
#
#   - This script will ...
#			Open and update the defualt user template, disabling the Prompt for an Apple ID for 
#			New User Accounts
#
###############################################################################################################################################
#
# HISTORY
#
#	Version: 1.0 - 13/12/2018
#
#	- 13/12/2018 - V1.0 - Created by Headbolt by combining and modifying Multiple Pe-Exsting Scripts and ideas from Web Research
#
#	- 10/22/2020 - V1.1 - Updated By Headbolt, better commenting.
#
###############################################################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
###############################################################################################################################################
#
ScriptName="append prefix here as needed - Disable Apple ID Sign-In Box for New Users"
#
# Determine OS version
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')
sw_vers=$(sw_vers -productVersion)
#
###############################################################################################################################################
#
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
###############################################################################################################################################
#
# Defining Functions
#
###############################################################################################################################################
#
# Update System Templates Function
#
SystemTemplates (){
#
for USER_TEMPLATE in "/System/Library/User Template"/* # Cycle through the User Templates and process each one
	do
		/bin/echo Processing Template $USER_TEMPLATE
		#
		# Set settings to pretend each action has already been performed.
		#
		defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE
		defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant DidSeeiCloudLoginForStorageServices -bool TRUE
		defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant DidSeeSiriSetup -bool TRUE
		defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant DidSeePrivacy -bool TRUE
		defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant GestureMovieSeen none
		defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion "${sw_vers}"
	done
#
}
#
###############################################################################################################################################
#
# Update the User Templates
#
# Check the existing user folders in /Users
# for the presence of the Library/Preferences directory.
#
# If the directory is not found, it is created and then the
# iCloud pop-up settings are set to be disabled.
#
UserTemplates (){
#
for USER_HOME in /Users/*
	do
		USER_UID=`basename "${USER_HOME}"`
		if [ ! "${USER_UID}" = "Shared" ] 
			then 
				if [ ! -d "${USER_HOME}"/Library/Preferences ]
					then
						mkdir -p "${USER_HOME}"/Library/Preferences
						chown "${USER_UID}" "${USER_HOME}"/Library
						chown "${USER_UID}" "${USER_HOME}"/Library/Preferences
				fi
				#
				if [ -d "${USER_HOME}"/Library/Preferences ]
					then
						/bin/echo Processing User $USER_UID
						defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE
						defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant GestureMovieSeen none
						defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion "${sw_vers}"
						chown "${USER_UID}" "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant.plist
				fi
		fi
	done
#
}
#
###############################################################################################################################################
#
# Section End Function
#
SectionEnd(){
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
/bin/echo  ----------------------------------------------- # Outputting a Dotted Line for Reporting Purposes
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
}
#
###############################################################################################################################################
#
# Script End Function
#
ScriptEnd(){
#
/bin/echo Ending Script '"'$ScriptName'"'
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
/bin/echo  ----------------------------------------------- # Outputting a Dotted Line for Reporting Purposes
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
exit $ExitCode
}
#
###############################################################################################################################################
#
# End Of Function Definition
#
###############################################################################################################################################
#
# Beginning Processing
#
###############################################################################################################################################
#
SectionEnd
SystemTemplates
#
SectionEnd
UserTemplates
#
sudo diskutil resetUserPermissions / `id -u`
#
SectionEnd
ScriptEnd
