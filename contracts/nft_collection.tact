import "@stdlib/deploy";
import "@stdlib/ownable";
import "./nft_item.tact";
import "./messages.tact";

contract NftCollection with Deployable, Ownable {
    owner: Address;
    custom_content: String;
    item_index_nft: Int as uint32;
    init() {
        self.owner = sender();
        self.custom_content = "It is my first NFT collection.";
        self.item_index_nft = 0;
    }
    receive("Mint"){
        self.requireOwner();
        self.mint(sender());
    }
    fun mint(to: Address){
        let init: StateInit = self.getNftItemInit();
        let ctx: Context = context();
        dump(myBalance());
        let f: Int = myBalance() - ctx.value;
        let result: Int = min(f, ton("0.03"));
        send(SendParameters{
            to: contractAddress(init),
            value: ctx.value - ton("0.2"),
            code: init.code,
            data: init.data,
            body: Transfer{
                query_id: 0,
                new_owner: to
            }.toCell()
        });
        self.item_index_nft = self.item_index_nft + 1;
                dump(myBalance());
    }
    get fun getNftItemInit(): StateInit{
        return initOf NftItem(self.owner, self.item_index_nft, myAddress());
    }
    get fun getNftItemAddress(): Address{
        return contractAddress(self.getNftItemInit());
    }
    get fun collection_data(): CollectionData{
        return CollectionData{
        owner_address: self.owner,
        collection_address: myAddress(),
        content: self.custom_content.asSlice().asCell(),
        item_index_nft: self.item_index_nft
        };
    }
}
