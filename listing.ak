pub type Listing = {
    id: String,
    owner: Address,
    price: Option<Int>, -- Price in lovelaces
    metadata: String,   -- IPFS hash or metadata reference
    status: ListingStatus
}

pub type ListingStatus =
    | Active
    | Cancelled

validator list_nft (ctx: ScriptContext, listing: Listing) -> Bool {
    let tx = ctx.tx;

    -- Ensure the transaction has the required inputs
    tx.inputs.contains(listing.owner) &&
    -- Ensure the output references the NFT metadata and price
    tx.outputs.any((output) -> {
        output.datum == listing &&
        output.value.lovelace >= 2000000  -- Minimum ADA for locking
    })
}
