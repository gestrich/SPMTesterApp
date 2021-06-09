This test app will demonstate a failure when using local swift packages with binary targets. If the swift packages attempt to update or resolve while there is no internet connection, the package workspace seems to become corrupted.

To reproduce

- Open the xcode workspace and build 1 time successfully.
- Inspect your `<derived data>/SourcePackages/artifacts` directory. You should see a `BinaryFrameworks/Stripe.xcframework` entry. 
- Inpect the `<derived data>/SourcePackages/workspace-state.json` file. You should see json, like in example 1 below.
- Go offline with `networksetup -setairportpower en0 off` from mac command line.
- File -> Swift Packages -> Update to Latest Package Versions
- Inspect the <derived data>/SourcePackages/artifacts/ and observe a directory "MyFramework" with the Stripe.xcframework inside. This is surprising as the MyFramework swift package should not have a relation to the Stripe framework. 
- Also inspect the <derived data>/SourcePackages/workspace-state.json. Observe it also lists the Stripe.xcframework as being a member of the "MyFramework" directory.
- Note, if you are not seeing these issues, try peforming File -> Swift Packages -> Reset Packages while offline. It seems interminate when you will land in this state but it seems triggered by some swift package updates that occur wil offline.
- Go back online with `networksetup -setairportpower en0 on` from mac command line.
- File -> Swift Packages -> Update to Latest Package Versions
- Try to build: You may receive errors that it cannot find the Stripe framework.

**Example 1 workspace-state.json**
  
  ```
  {
  "object": {
    "artifacts": [
      {
        "packageRef": {
          "identity": "binaryframeworks",
          "kind": "root",
          "name": "BinaryFrameworks",
          "path": "/Users/bill/Downloads/SPMTesterApp/BinaryFrameworks"
        },
        "source": {
          "checksum": "fe459dd443beee5140018388fd6933e09b8787d5b473ec9c2234d75ff0d968bd",
          "subpath": "BinaryFrameworks/Stripe.xcframework",
          "type": "remote",
          "url": "https://github.com/stripe/stripe-ios/releases/download/v19.3.0/Stripe.xcframework.zip"
        },
        "targetName": "Stripe"
      }
    ],
    "dependencies": []
  },
  "version": 4
}
```
