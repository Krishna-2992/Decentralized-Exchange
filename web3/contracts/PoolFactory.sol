// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "./Pool.sol";

contract PoolFactory {

    address[3][] private s_poolsList;
    mapping(address => mapping(address => PoolStruct)) private s_tokensToPool;

    struct PoolStruct {
        address poolAddress; 
        uint8 fee;
    }

    event PoolCreated(
        address indexed token0, 
        address indexed token1, 
        uint8 fee,
        address indexed poolAddress
    );

    function createPool(address _token0, address _token1, uint8 _fee) external {
        require(_fee < 100, "Fee should be <1%");
        require(_token0 != _token1, "Same token not allowed");
        require(
            s_tokensToPool[_token0][_token1].fee != _fee && 
            s_tokensToPool[_token1][_token0].fee != _fee,
            "Token pair already exist" 
        );

        Pool pool = new Pool(_token0, _token1, _fee);
        address poolAddress = address(pool);

        s_tokensToPool[_token0][_token1] = PoolStruct(poolAddress, _fee);
        s_poolsList.push([_token0, _token1, poolAddress]);

        emit PoolCreated(_token0, _token1, _fee, poolAddress);
    }

    function getPool(
        address _token0, 
        address _token1, 
        uint8 _fee
    ) external view returns(address) {
        if(s_tokensToPool[_token0][_token1].fee == _fee) 
            return s_tokensToPool[_token0][_token1].poolAddress;
        else if(s_tokensToPool[_token1][_token0].fee == _fee)
            return s_tokensToPool[_token1][_token0].poolAddress;
        else return address(0);
    }

    function getAllPools() external view returns (address[3][] memory) {
        return s_poolsList;
    }

}