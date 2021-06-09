This test app will demonstate a failure when using local swift packages with binary targets. If the swift packages attempt to update or resolve while on a bad network (ex: VPN down), the package workspace seems to become corrupted.

To reproduce

- Open the xcode workspace and build 1 time successfully.
- Inspect your `<derived data>/SourcePackages/artifacts` directory. You should see a `BinaryFrameworks/Stripe.xcframework` entry (expected)
- Inspect the `<derived data>/SourcePackages/workspace-state.json` file. You should see json, like in example 1 below (expected).
- Go offline with `networksetup -setairportpower en0 off` from mac command line.
- File -> Swift Packages -> Update to Latest Package Versions. You should see an error in Xcode "artifact of binary target 'Stripe' failed to download".
- Inspect your `<derived data>/SourcePackages/artifacts` directory again and observe a new directory "MyFramework" that now lives along side the aforementioned BinaryFrameworks directory. This is surprising as the MyFramework swift package does not have any artifacts/binary targets associated with it.
- Also inspect the `<derived data>/SourcePackages/workspace-state.json` file again. It should look like like in example 2 below. Observe it lists the Stripe.xcframework as being a member of the "MyFramework" directory which also seems incorrect. 
- Go back online with `networksetup -setairportpower en0 on` from mac command line.
- File -> Swift Packages -> Update to Latest Package Versions
- Try to build: You may receive errors that it cannot find the Stripe framework. 

It may build ok in this state but the extra Stripe.xcframework entry will persist in the workspace json file. The failure potential seems to depend on the ordering of that artifacts in the json file. There are various scnearios where this added entry will cause problems later with additional workspace changes. You can even land into states where the Stripe Framework is _only_ in the MyFramework directory. In that case things will seem to work for  a while and then suddenly fail when it tries to find the artifact in the BinaryFrameworks directory, which doens't exists. This issue is confusing but hopefully the example above can at least reproduce the bad state that seems to be triggering various problems.

**Example 1 workspace-state.json** 

This is before encountering any problems.
  
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

**Example 2 workspace-state.json**


This is after the packages updates on a bad network. Note the stripe framework is now being associated with the MyLibrary package, which should have no relation.
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
      },
      {
        "packageRef": {
          "identity": "binaryframeworks",
          "kind": "root",
          "name": "MyLibrary",
          "path": "/Users/bill/Downloads/SPMTesterApp/MyLibrary"
        },
        "source": {
          "checksum": "fe459dd443beee5140018388fd6933e09b8787d5b473ec9c2234d75ff0d968bd",
          "subpath": "MyLibrary/Stripe.xcframework",
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
