# DO NOT EDIT
# This makefile makes sure all linkable targets are
# up-to-date with anything they link to
default:
	echo "Do not invoke directly"

# Rules to remove targets that are older than anything to which they
# link.  This forces Xcode to relink the targets from scratch.  It
# does not seem to check these dependencies itself.
PostBuild.TTDemoApp.Debug:
/Users/zing/Demo/DDLTG/build/TTDemo/Debug${EFFECTIVE_PLATFORM_NAME}/TTDemoApp.app/TTDemoApp:
	/bin/rm -f /Users/zing/Demo/DDLTG/build/TTDemo/Debug${EFFECTIVE_PLATFORM_NAME}/TTDemoApp.app/TTDemoApp


PostBuild.TTDemoApp.Release:
/Users/zing/Demo/DDLTG/build/TTDemo/Release${EFFECTIVE_PLATFORM_NAME}/TTDemoApp.app/TTDemoApp:
	/bin/rm -f /Users/zing/Demo/DDLTG/build/TTDemo/Release${EFFECTIVE_PLATFORM_NAME}/TTDemoApp.app/TTDemoApp


PostBuild.TTDemoApp.MinSizeRel:
/Users/zing/Demo/DDLTG/build/TTDemo/MinSizeRel${EFFECTIVE_PLATFORM_NAME}/TTDemoApp.app/TTDemoApp:
	/bin/rm -f /Users/zing/Demo/DDLTG/build/TTDemo/MinSizeRel${EFFECTIVE_PLATFORM_NAME}/TTDemoApp.app/TTDemoApp


PostBuild.TTDemoApp.RelWithDebInfo:
/Users/zing/Demo/DDLTG/build/TTDemo/RelWithDebInfo${EFFECTIVE_PLATFORM_NAME}/TTDemoApp.app/TTDemoApp:
	/bin/rm -f /Users/zing/Demo/DDLTG/build/TTDemo/RelWithDebInfo${EFFECTIVE_PLATFORM_NAME}/TTDemoApp.app/TTDemoApp




# For each target create a dummy ruleso the target does not have to exist
