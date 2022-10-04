with data as(
    select
      seller   as source,
      buyer    as target,
      token_id as tokenID
    from
      nft.trades
    where
      blockchain = 'ethereum'
      and nft_contract_address = '{{address}}'

    UNION

    select
      from    as source,
      to      as target,
      tokenId as tokenID
    from
       erc721_ethereum.evt_Transfer
    where
    from = '0x0000000000000000000000000000000000000000'
     and contract_address = '{{address}}'
 )

select
 source,
 target,
 COUNT(DISTINCT tokenID) as value
from data
GROUP by 1,2
