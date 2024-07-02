import "@stdlib/deploy";
import "./messages.tact";

fun content(item_index_nft: Int): String{
        let res: StringBuilder = beginString();
        res.append("This is number: ");
        res.append(item_index_nft.toString());
        return res.toString(); 
    }

contract NftItem with Deployable {
    owner: Address;
    collection_address: Address;
    item_index_nft: Int as uint32;
    custom_content: String;
    init(owner: Address, item_index_nft: Int, collection_address: Address ) {
        self.owner = owner;
        self.collection_address = collection_address;
        self.item_index_nft = item_index_nft;
        self.custom_content = content(item_index_nft);
    }
    receive(msg: Transfer){
        require(sender() == self.collection_address,"Only owner");
        self.owner = msg.new_owner;
    }
    get fun itemData(): ItemData{
        return ItemData{
        owner_address: self.owner,
        collection_address: self.collection_address,
        item_index_nft: self.item_index_nft,
        content: self.custom_content.asSlice().asCell(),
        item_address: myAddress()
        };
    }
}
