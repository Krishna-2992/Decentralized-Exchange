// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import './LiquidityToken.sol';

pragma solidity ^0.8.20;

error Pool__InvalidTokenRatio();
error Pool__ZeroLiquidityToken();

contract Pool is LiquidityToken, ReentrancyGuard {

    IERC20 private immutable i_token0; 
    IERC20 private immutable i_token1; 

    uint256 private s_reserve0;
    uint256 private s_reserve1;

    uint private immutable i_fee;

    event AddedLiquidity(
        address indexed token0,
        address indexed token1,
        uint256 amount0,
        uint256 amount1,
        uint256 liquidityToken
    );
    event RemovedLiquidity(
        address indexed token0,
        address indexed token1,
        uint256 amount0,
        uint256 amount1,
        uint256 liquidityToken
    );
    event Swapped(
        address indexed tokenIn, 
        address indexed tokenOut,
        uint256 amountIn, 
        uint256 amountOut
    );

    constructor(address _token0, address _token1, uint8 _fee) 
        LiquidityToken("LiquidityToken", "LT") {
        i_token0 = IERC20(_token0); 
        i_token1 = IERC20(_token1);
        i_fee = _fee;
    }

    function _updateLiquidity(uint256 reserve0, uint256 reserve1) internal {
        s_reserve0 = reserve0;
        s_reserve1 = reserve1;
    }

    function swap(address _tokenIn, uint256 _amountIn) external nonReentrant {
        IERC20 token0 = i_token0; 
        IERC20 token1 = i_token1;

        require(
            _tokenIn == address(token0) || _tokenIn == address(token1), 
            "Invalid Token"
        );

        (uint256 amountOut, uint256 resIn, uint256 resOut, bool isFirstToken) = getAmountOut(_tokenIn, _amountIn);

        IERC20 tokenIn = isFirstToken ? token0 : token1; 
        IERC20 tokenOut = isFirstToken ? token1 : token0; 

        bool success = tokenIn.transferFrom(msg.sender, address(this), _amountIn);
        require(success, "Swap Failed");

        _updateLiquidity(resIn + _amountIn, resOut - amountOut);
        tokenOut.transfer(msg.sender, amountOut);

        emit Swapped(
            address(tokenIn), 
            address(tokenOut), 
            _amountIn,
            amountOut
        );
    }

    function addLiquidity(uint256 amount0, uint256 amount1) external nonReentrant {
        uint256 reserve0 = s_reserve0;
        uint256 reserve1 = s_reserve1;

        // x/y = dx/dy
        if(reserve0 > 0 || reserve1 > 0 ){
            if(reserve0/reserve1 != amount0/amount1) {
                revert Pool__InvalidTokenRatio();
            }
        }

        IERC20 token0 = i_token0; 
        IERC20 token1 = i_token1;

        token0.transferFrom(msg.sender, address(this), amount0);
        token1.transferFrom(msg.sender, address(this), amount1);

        uint256 liquidityTokenSupply = totalSupply();
        uint256 liquidityTokens;
        if(liquidityTokenSupply > 0) {
            liquidityTokens = (amount0 * liquidityTokenSupply) / reserve0;
        } else {
            liquidityTokens = _sqrt(amount0 * amount1);
        }

        if(liquidityTokens == 0) revert Pool__ZeroLiquidityToken();

        _mint(msg.sender, liquidityTokens);
        _updateLiquidity(reserve0 + amount0, reserve1 + amount1);

        emit AddedLiquidity(
            address(token0),
            address(token1), 
            amount0, 
            amount1, 
            liquidityTokens
        );
    }

    function removeLiquidity(uint256 liquidityTokens) external nonReentrant {
        require(liquidityTokens > 0, "0 Liquidity Tokens");

        uint256 liquidityTokenSupply = totalSupply();
        uint256 amount0 = (liquidityTokens * s_reserve0) / liquidityTokenSupply;
        uint256 amount1 = (liquidityTokens * s_reserve1) / liquidityTokenSupply;

        _burn(msg.sender, liquidityTokens);

        IERC20 token0 = i_token0; 
        IERC20 token1 = i_token1;

        token0.transfer(msg.sender, amount0);
        token1.transfer(msg.sender, amount1);

        _updateLiquidity(s_reserve0 - amount0, s_reserve1 - amount1);

        emit RemovedLiquidity(
            address(token0),
            address(token1), 
            amount0, 
            amount1, 
            liquidityTokens
        ); 
    }

    function _sqrt(uint256 y) private pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    ///////////////////////////////////
    ////////// VIEW FUNCTIONS /////////
    ///////////////////////////////////

    function getAmountOut(address _tokenIn, uint256 amountIn) public view returns (uint256, uint256, uint256, bool) {
        bool isFirstToken = _tokenIn == address(i_token0) ? true : false;
        uint256 resIn = isFirstToken ? s_reserve0 : s_reserve1;
        uint256 resOut = isFirstToken ? s_reserve1 : s_reserve0;

        // xy = k
        // (x + dx)(y - dy) = k
        // xy - xdy + dxy -dxdy = xy (k=xy)
        // dy(x + dx) = dxy
        // dy = dxy/(x+dx)

        uint256 amountWithFee = (amountIn * (10000 - i_fee)) / 10000;
        uint256 amountOut = (resOut * amountWithFee) / (resIn + amountWithFee);
        return (amountOut, resIn, resOut, isFirstToken);
    }

    function getReserve() public view returns(uint256, uint256) {
        return (s_reserve0, s_reserve1);
    }

    function getLiquidityRatio(address _tokenIn, uint256 amountIn) external view returns(uint256) {
        require(
            _tokenIn == address(i_token0) || _tokenIn == address(i_token1), 
            "Invalid Token"
        );
        (uint256 resIn, uint256 resOut) = _tokenIn == address(i_token0) ? (s_reserve0, s_reserve1) : (s_reserve1, s_reserve0);
        return (amountIn * (resOut / resIn));
    }

    function getTokens() external view returns(address, address) {
        return (address(i_token0), address(i_token1));
    }

    function getFee() external view returns(uint) {
        return i_fee;
    }

}



