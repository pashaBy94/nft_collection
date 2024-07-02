message Transfer{
    query_id: Int;
    new_owner: Address;
}
struct CollectionData{
    owner_address: Address;
    collection_address: Address;
    content: Cell;
    item_index_nft: Int;
}
struct ItemData{
    owner_address: Address;
    collection_address: Address;
    content: Cell;
    item_index_nft: Int;
    item_address: Address;
}