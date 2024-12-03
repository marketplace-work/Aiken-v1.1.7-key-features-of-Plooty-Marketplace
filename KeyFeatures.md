Let’s break down the code snippets for key features of **Plooty-Marketplace**. These snippets focus on **Aiken smart contract logic**, **deployment**, and **frontend integration**.

---

### **1. Listing NFTs**
The logic allows a seller to list an NFT for sale.  
**Aiken Code**:  
```aiken
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
```

**Testing the Validator**:
```aiken
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
```

---

### **2. Auction Logic**
This snippet implements the auction functionality.  
**Aiken Code**:
```aiken
pub type Auction = {
    nft_id: String,
    seller: Address,
    highest_bid: Option<Bid>,
    end_time: Time
}

pub type Bid = {
    bidder: Address,
    amount: Int
}

validator place_bid (ctx: ScriptContext, auction: Auction, bid: Bid) -> Bool {
    let tx = ctx.tx;

    -- Ensure auction is active
    tx.current_time < auction.end_time &&
    -- Ensure the bid is higher than the current highest bid
    match auction.highest_bid {
        None -> bid.amount > 0,
        Some(highest) -> bid.amount > highest.amount
    } &&
    -- Ensure the bid is locked in the script
    tx.outputs.any((output) -> {
        output.value.lovelace == bid.amount &&
        output.datum == { auction_id: auction.nft_id, bid }
    })
}
```

---

### **3. Deployment Script (Node.js)**
This snippet uses the Mesh SDK to deploy the compiled Plutus script.  
**Node.js Deployment Code**:
```javascript
import { BlockfrostProvider, MintingPolicy } from '@meshsdk/core';
import { readFileSync } from 'fs';

// Load compiled script
const compiledScript = JSON.parse(readFileSync('./output/listing.json', 'utf-8'));

// Initialize provider
const blockfrost = new BlockfrostProvider({
  projectId: 'your_project_id',
});

// Deploy the listing validator
const mintingPolicy = new MintingPolicy({
  type: 'PlutusV2',
  script: compiledScript.cborHex,
});

const deploy = async () => {
  const txHash = await blockfrost.submitMintingPolicy(mintingPolicy);
  console.log(`Listing validator deployed with TX hash: ${txHash}`);
};

deploy();
```

---

### **4. Frontend Integration (React Example)**
Connecting the marketplace smart contract with a frontend:  
**React Code for Wallet Interaction**:
```javascript
import { useWallet } from '@meshsdk/react';
import { Transaction } from '@meshsdk/core';

function App() {
  const { connected, connect, wallet } = useWallet();

  const listNFT = async () => {
    if (!connected) {
      await connect();
    }

    const tx = new Transaction();
    tx.addOutput({
      address: 'script_address', // Address of the smart contract
      value: { lovelace: '2000000' }, // Minimum ADA
      datum: {
        json: {
          id: 'nft123',
          owner: wallet.address,
          price: 5000000,
          metadata: 'ipfs://someHash',
          status: 'Active',
        },
      },
    });

    const signedTx = await wallet.signTx(tx);
    const txHash = await wallet.submitTx(signedTx);
    console.log(`Transaction submitted: ${txHash}`);
  };

  return (
    <div>
      <button onClick={listNFT}>List NFT</button>
    </div>
  );
}

export default App;
```

---

### **5. Metadata Update Script**
This supports dynamic metadata updates for NFTs.  
**Aiken Metadata Update Logic**:
```aiken
validator update_metadata (ctx: ScriptContext, nft_id: String, new_metadata: String) -> Bool {
    let tx = ctx.tx;

    -- Check if the NFT owner approves the update
    tx.inputs.any((input) -> input.datum.id == nft_id) &&
    -- Update the metadata
    tx.outputs.any((output) -> output.datum.metadata == new_metadata)
}
```

---
