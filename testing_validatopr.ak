test list_nft_validator {
    let ctx = mock_script_context();
    let listing = Listing {
        id: "nft123",
        owner: mock_address(),
        price: Some(5000000),
        metadata: "ipfs://someHash",
        status: Active
    };

    assert(list_nft(ctx, listing));
}
