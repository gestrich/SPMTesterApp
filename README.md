This test app will demonstate a failure when using local swift packages with binary targets. If the swift packages attempt to update or resolve while there is no internet connection, the package workspace seems to become corrupted.

To reproduce

- Open the xcode workspace and build 1 time successfully.
- Go offline with `networksetup -setairportpower en0 off` from mac command line.
- File -> Swift Packages -> Update to Latest Package Versions
- Inspect the <derived data>/SourcePackages/artifacts/ and observe a directory "MyFramework" with the Stripe.xcframework inside. This is surprising as the MyFramework swift package should not have a relation to the Stripe framework. 
- Also inspect the <derived data>/SourcePackages/workspace-state.json. Observe it also lists the Stripe.xcframework as being a member of the "MyFramework" directory.
- Note, if you are not seeing these issues, try peforming File -> Swift Packages -> Reset Packages while offline. It seems interminate when you will land in this state but it seems triggered by some swift package updates that occur wil offline.
- Go back online with `networksetup -setairportpower en0 on` from mac command line.
- File -> Swift Packages -> Update to Latest Package Versions
- Try to build: You may receive errors that it cannot find the Stripe framework.
