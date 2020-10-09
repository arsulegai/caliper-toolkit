# CALIPER TOOLKIT

A toolkit for the Hyperledger Caliper tool.

## Use

Run the `./setup.sh -h` command to find the latest options available.

In case you're experimenting with the Hyperledger Fabric network,
then create a folder with following contents (let's call the created
folder to be `folder` for further explanation)

```
- folder
  - folder:caliper
    - file:network.yaml (HLF configuration)
    - file:config.yaml (Caliper configuration)
  - folder:workloads (Place all your workload files here)
  - folder:chaincode
    - folder:go
      - folder:chaincode1 (This is where you place your chaincode folders)
      - ...
```
