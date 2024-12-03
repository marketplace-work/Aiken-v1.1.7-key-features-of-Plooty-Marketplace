### Deployment Instructions

1. Save this script as listing.ak.

2. Compile:

...
aiken build --optimize
...

3. Deploy: Use the compiled .plutus file to create transactions with cardano-cli or integrate it with the Mesh SDK for a seamless deployment.

4. Testing:

     a. Use cardano-cli for manual testing.
     b. Automate tests with Blockfrost APIs or Aiken fuzzing tools.
