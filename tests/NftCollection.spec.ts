import { Blockchain, SandboxContract, TreasuryContract } from '@ton/sandbox';
import { toNano } from '@ton/core';
import { NftCollection } from '../wrappers/NftCollection';
import '@ton/test-utils';
import { NftItem } from '../wrappers/NftItem';

describe('NftCollection', () => {
    let blockchain: Blockchain;
    let deployer: SandboxContract<TreasuryContract>;
    let nftCollection: SandboxContract<NftCollection>;

    beforeEach(async () => {
        blockchain = await Blockchain.create();

        nftCollection = blockchain.openContract(await NftCollection.fromInit());

        deployer = await blockchain.treasury('deployer');

        const deployResult = await nftCollection.send(
            deployer.getSender(),
            {
                value: toNano('0.05'),
            },
            {
                $$type: 'Deploy',
                queryId: 0n,
            }
        );

        expect(deployResult.transactions).toHaveTransaction({
            from: deployer.address,
            to: nftCollection.address,
            deploy: true,
            success: true,
        });
    });

    it('should deploy collection', async () => {
        await nftCollection.send(
            deployer.getSender(),
            {
                value: toNano('0.5')
            },
            "Mint" 
        );
        let itemAddress = await nftCollection.getGetNftItemAddress();
        let itemNft: SandboxContract<NftItem> = blockchain.openContract(NftItem.fromAddress(itemAddress));
        console.log(itemAddress, itemNft.address );
        let user = await blockchain.treasury('user');

        
    });
});
