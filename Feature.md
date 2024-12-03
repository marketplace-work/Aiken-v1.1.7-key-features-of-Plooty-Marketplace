### Features


1. Datum Structure:

    a. Includes NFT ID, status, owner, and price.

2. Redeemer Actions:

    a. ListNFT: Marks the NFT as listed.
    b. CancelNFT: Allows the current owner to cancel the listing.
    c. PurchaseNFT: Facilitates transferring the correct amount to the seller.

3. On-Chain Validation:

     a. Ensures only valid listing, cancellation, or purchase actions.
     b. Prevents unauthorized actions, such as purchases below the listed price.


### Usages

1. Listing NFT
Deploy the validator with ListNFT as the redeemer and status = "Listed" in the Datum.

2. Canceling Listing
Submit a transaction with the redeemer CancelNFT:

The tx.signatories must include the owner.
3. Purchasing NFT
Submit a transaction with the redeemer PurchaseNFT:

Validates that the buyer pays the required price (metadata.price).
Ensures funds are transferred to the owner (metadata.owner).
