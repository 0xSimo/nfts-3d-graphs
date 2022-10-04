#!/usr/bin/env python3  Line 1
# -*- coding: utf-8 -*- Line 2
# ----------------------------------------------------------------------------
# Created By  : simo@whaleanalytica.com
# Created Date: 04/10/2022
# version ='1.0'
# ---------------------------------------------------------------------------
""" Generation of 3D NFT transaction graphs

    The graph structure is inspired by my co-authored scientific work presented in:

    S. Casale-Brunet, P. Ribeca, P. Doyle and M. Mattavelli,
    "Networks of Ethereum Non-Fungible Tokens: A graph-based analysis of the ERC-721 ecosystem",
    2021 IEEE International Conference on Blockchain, doi: 10.1109/Blockchain53845.2021.00033

"""
# ---------------------------------------------------------------------------
import os
import dotenv
import json
import datetime
import pandas as pd
import argparse

from tqdm import tqdm
from jinja2 import Environment, FileSystemLoader
from dune_client.types import QueryParameter
from dune_client.client import DuneClient
from dune_client.query import Query


def render_html_page(address, date):
    """Render the HTML template page
        :param address: the nft collection address
        :param date: date in string form
    """
    current_directory = os.path.dirname(os.path.abspath(__file__))
    env = Environment(loader=FileSystemLoader(current_directory))
    return env.get_template('/data/graph.html').render(
        address=address,
        date=date
    )


def nft_graph(address, root_path, debug):
    """Query tha data and generate the graph files
        :param address: the nft collection address
        :param root_path: the root path where output files will be stored. The path shall exist
        :param debug: flag to enable debugging
    """
    if not address or len(address) < 42:
        raise "address not valid"
    if not root_path or not os.path.isdir(root_path) or not os.path.exists(root_path):
        raise "Path of the file is Invalid"

    html = render_html_page(address, str(datetime.datetime.now()))
    query = Query(
        name="WhaleAnalytica graph query",
        query_id=1344718,
        params=[QueryParameter.text_type(name="address", value=address), ],
    )

    print("Results available at", query.url())

    dotenv.load_dotenv()
    dune = DuneClient(os.environ["DUNE_API_KEY"])
    results = dune.refresh(query)

    df = pd.DataFrame(results)
    if debug:
        df.to_csv(os.path.join(root_path, f"{address}.csv"), index=False)

    b = list(df["source"].unique())
    s = list(df["target"].unique())
    w = list(set(b+s))

    nodes = []
    for x in tqdm(w, "build nodes"):
        value = len(df[df["target"] == x][["target"]].index)
        nodes.append({
            "id"   : x,
            "value": value
        })

    links = []
    for _, row in tqdm(df.iterrows(), "build edges"):
        links.append({
            "source": row['source'],
            "target": row['target'],
            "value" : row['value']
        })

    graph = {
        "nodes": nodes,
        "links": links
    }

    with open(os.path.join(root_path, f"{address}.json"), "w") as f:
        f.write(json.dumps(graph, indent=4 if debug else 0))

    with open(os.path.join(root_path, f"{address}.html"), 'w') as f:
        f.write(html)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='NFT transactions graph generation')
    parser.add_argument('address', help="the NFT address",      type=str)
    parser.add_argument('output',  help="the output directory", type=str)
    parser.add_argument('--debug', help="store debug data",     action='store_true')

    args = parser.parse_args()

    nft_graph(
        address=args.address,
        root_path=args.output,
        debug=args.debug,
    )
