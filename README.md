# NFTs 3D Transactions Graph
Generation of a transaction graph where each node represents a wallet and each direct arc represents at least one 
sale/purchase transaction of a token from the given NFT collection between two wallets. 

Data is retrieved using the [Dune API](https://dune.com/docs/api/) using the Dune query [https://dune.com/queries/1344718](https://dune.com/queries/1344718)
(a local copy is available in [data/query.sql](./data/query.sql)). 
From the collected data, a directed graph is constructed assigning as weight of each node its in-degree, 
and as weight of each arc the number of unique tokens transferred from the source wallet to the destination wallet.

![grab-landing-page](./data/graph.gif)

The graph structure is inspired by my co-authored scientific work presented in: 
S. Casale-Brunet, P. Ribeca, P. Doyle and M. Mattavelli, 
**"Networks of Ethereum Non-Fungible Tokens: A graph-based analysis of the ERC-721 ecosystem"**,
2021 IEEE International Conference on Blockchain, doi: [10.1109/Blockchain53845.2021.00033](https://ieeexplore.ieee.org/document/9680594).


```tex
@INPROCEEDINGS{2021_casalebrunet_nft_graphs,
  author={Casale-Brunet, S. and Ribeca, P. and Doyle, P. and Mattavelli, M.},
  booktitle={2021 IEEE International Conference on Blockchain (Blockchain)}, 
  title={Networks of Ethereum Non-Fungible Tokens: A graph-based analysis of the ERC-721 ecosystem}, 
  year={2021},
  pages={188-195},
  doi={10.1109/Blockchain53845.2021.00033}
}
```

## Generate the graph
To generate the graph, simply run (after building the environment, see below) the following script:
```bash
./scripts/nft_graph.sh -a <ADDRESS> -o <OUT_ROOT_PATH>
```
where ```ADDRESS``` is the address of the NFT Ethereum collection, and ```OUT_ROOT_PATH``` is the destination path 
(it must exist) where the generated files are stored. The generated files are in the form:
```bash
OUT_ROOT_PATH/ADDRESS.html # that contains the HTML file that load the graph
OUT_ROOT_PATH/ADDRESS.json # that contains the data file used by the html file
```

Look at the files available in the [./example](./example) directory to see how these have been structured. 
The files have been generated for the address [0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d](https://etherscan.io/address/0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d)
that corresponds to the [Bored Ape Yacht Club](https://opensea.io/collection/boredapeyachtclub) collection.


## Build and configure the execution environment

You have to copy the  ```.env.copy``` file as ```.env``` and fill it with your [Dune API key](https://dune.com/docs/api/).
```bash
# copy the env file
cp .env.copy .env

# modify the env file by entering your DUNE_API_KEY
nano .env
```

To build (or clean) the execution environment just launch the following scripts:

```bash
# build the execution environment
./build.sh

# clean the execution environment
./clean.sh
```
