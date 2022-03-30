/**
 *Submitted for verification at BscScan.com on 2022-03-19
*/

// SPDX-License-Identifier: MIP

/**
 *                                                                                @
 *                                                                               @@@
 *                          @@@@@@@                     @@@@@@@@                @ @ @
 *                   @@@@@@@@@@@@@@@@@@@@         @@@@@@@@@@@@@@@@@@@@           @@@
 *                @@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@         @
 *
 *    @@@@@@@@     @@@@@@@@@    @@@@@@@@@@    @@@@@@@       @@@      @@@@@  @@     @@@@@@@@@@
 *    @@@@@@@@@@   @@@@@@@@@@   @@@@@@@@@@   @@@@@@@@@      @@@       @@@   @@@    @@@@@@@@@@
 *    @@@     @@@  @@@     @@@  @@@     @@  @@@     @@@    @@@@@      @@@   @@@@   @@@     @@
 *    @@@     @@@  @@@     @@@  @@@         @@@            @@@@@      @@@   @@@@   @@@
 *    @@@@@@@@@@   @@@@@@@@@@   @@@    @@    @@@@@@@      @@@ @@@     @@@   @@@@   @@@    @@
 *    @@@@@@@@     @@@@@@@@     @@@@@@@@@     @@@@@@@     @@@ @@@     @@@   @@@@   @@@@@@@@@
 *    @@@          @@@   @@@    @@@    @@          @@@   @@@   @@@    @@@   @@@@   @@@    @@
 *    @@@  @@@@    @@@   @@@    @@@                 @@@  @@@   @@@    @@@   @@@@   @@@
 *    @@@   @@@    @@@    @@@   @@@     @@  @@@     @@@  @@@@@@@@@    @@@   @@     @@@     @@
 *    @@@    @@    @@@    @@@   @@@@@@@@@@   @@@@@@@@    @@@   @@@    @@@      @@  @@@@@@@@@@
 *   @@@@@     @  @@@@@   @@@@  @@@@@@@@@@    @@@@@@    @@@@@ @@@@@  @@@@@@@@@@@@  @@@@@@@@@@
 *
 *                @@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@
 *                   @@@@@@@@@@@@@@@@@@@@        @@@@@@@@@@@@@@@@@@@@@
 *                        @@@@@@@@@@                 @@@@@@@@@@@@
 *
 */

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Address.sol";
import "./SafeERC20.sol";
import "./IERC20.sol";
import "./ReentrancyGuard.sol";

/*===================================================
    Crinet Presale Contract - Round 1_3
=====================================================*/

contract CNTPresale is ReentrancyGuard, Ownable {

    using SafeERC20 for IERC20;

    event TokenPurchase(address indexed beneficiary, uint256 amount);

    // CNT and BUSD token
    IERC20 private cnt;
    IERC20 private busd;

    // Round Information
    struct RoundInfo {
        uint256 cntPrice;
        uint256 hardCap;
        uint256 startTime;
        uint256 endTime;
        uint256 busdAmount;
        uint256 investors;
        bool    active;
    }
    
    mapping(uint8 => RoundInfo) public roundInfos;

    uint8 public constant maxRoundLV = 1;
    uint8 public currentRound;

    // time to start claim.
    uint256 public claimStartTime = 1649894400; // Thu Apr 14 2022 00:00:00 UTC

    // user information
    mapping (address => uint256) public claimableAmounts;

    // Referral Information
    mapping(address => uint16) public referralCount;

    uint256[] public REFERRAL_PERCENTS = [200, 250, 300, 400];

    // price and percent divisor
    uint256 constant public divisor = 10000;

    // wallet to withdraw
    address public wallet;

    /**
     * @dev Initialize with token address and round information.
     */
    constructor (address _cnt, address _busd, address _wallet) Ownable() {
        require(_cnt != address(0), "presale-err: invalid address");
        require(_busd != address(0), "presale-err: invalid address");
        require(_wallet != address(0), "presale-err: invalid address");

        cnt = IERC20(_cnt);
        busd = IERC20(_busd);
        wallet = _wallet;
  
        roundInfos[1].cntPrice = 75;

        roundInfos[1].hardCap = 500_000 * 10**18;
    }

    /**
     * @dev Initialize ICO data. Only for test
     */
    function Initialize() external onlyOwner {
        roundInfos[1].startTime = 0;
        roundInfos[1].endTime = 0;
        roundInfos[1].busdAmount = 0;
        roundInfos[1].investors = 0;
        roundInfos[1].active = false;

        currentRound = 0;
    }

    /**
     * @dev Set token price for a round.
     */
    function setPrice(uint256 _price) external onlyOwner {
        roundInfos[1].cntPrice = _price;
    }

    /**
     * @dev Set hardcap for a round.
     */
    function setHardCap(uint256 _hardCap) external onlyOwner {
        require(_hardCap >= roundInfos[1].busdAmount , "presale-err: _hardCap should be greater than deposit amount");

        roundInfos[1].hardCap = _hardCap;
        roundInfos[1].active = true;
    }

    /**
     * @dev Start ICO with end time and hard cap.
     */
    function startICO() external onlyOwner {
        require(roundInfos[1].active == false, "presale-err: Round is already running");

        currentRound = 1;
        roundInfos[1].active = true;
        roundInfos[1].startTime = block.timestamp;
    }

    /**
     * @dev Stop current round.
     */
    function stopICO() external onlyOwner {
        require(roundInfos[1].active == true, "presale-err: no active ico-round");

        roundInfos[1].active = false;
        roundInfos[1].endTime = block.timestamp;
        roundInfos[1].hardCap = roundInfos[1].busdAmount;
    }

    /**
     * @dev Calculate token amount for busd amount.
     */
    function _getTokenAmount(uint256 _busdAmount) internal view returns (uint256) {
        return _busdAmount / roundInfos[1].cntPrice * divisor / (10**9);
    }

    /**
     * @dev Calculate referral bonus amount with refCount.
     */
    function _getReferralAmount(uint16 _refCount, uint256 _busdAmount) internal view returns (uint256) {
        uint256 referralAmount = 0;
        if (_refCount < 4) {
            referralAmount = _busdAmount * REFERRAL_PERCENTS[0] / divisor;
        } else if (_refCount < 10) {
            referralAmount = _busdAmount * REFERRAL_PERCENTS[1] / divisor;
        } else if (_refCount < 26) {
            referralAmount = _busdAmount * REFERRAL_PERCENTS[2] / divisor;
        } else {
            referralAmount = _busdAmount * REFERRAL_PERCENTS[3] / divisor;
        }

        return referralAmount;
    }

    /**
     * @dev Buy tokens with busd and referral address.
     */
    function buyTokens(uint256 _amount, address _referrer) external nonReentrant {
        _preValidatePurchase(msg.sender, _amount);

        uint256 referralAmount;
        if (_referrer != address(0)) {
            referralCount[_referrer] += 1;
            uint16 refCount = referralCount[_referrer];
            
            referralAmount = _getReferralAmount(refCount, _amount);

            _amount -= referralAmount;
        }

        if (roundInfos[1].busdAmount + _amount > roundInfos[1].hardCap) {
            _amount = roundInfos[1].hardCap - roundInfos[1].busdAmount;
            roundInfos[1].endTime = block.timestamp;
            roundInfos[1].active = false;

            if (referralAmount > 0) {
                uint16 refCount = referralCount[_referrer];
                referralAmount = _getReferralAmount(refCount, _amount);
                _amount -= referralAmount;
            }
        }

        busd.safeTransferFrom(msg.sender, address(this), _amount + referralAmount);
        
        if (referralAmount > 0) {
            busd.safeTransfer(_referrer, referralAmount);
        }

        roundInfos[1].busdAmount += _amount;
        roundInfos[1].investors += 1;

        uint256 purchaseAmount = _getTokenAmount(_amount);
        claimableAmounts[msg.sender] += purchaseAmount;

        emit TokenPurchase(msg.sender, purchaseAmount);
    }

    /**
     * @dev Check the possibility to buy token.
     */
    function _preValidatePurchase(address _beneficiary, uint256 _amount) internal view {
        require(_beneficiary != address(0), "presale-err: beneficiary is the zero address");
        require(_amount != 0, "presale-err: _amount is 0");
        require(roundInfos[1].active == true, "presale-err: no active round");
        this; 
    }

    /**
     * @dev Claim tokens after ICO.
     */
    function claimTokens() external {
        require(block.timestamp > 1649894400, "presale-err: can claim after Apr 14 2022 UTC");
        require(roundInfos[1].active == false, "presale-err: ICO is not finished yet");
        require(claimableAmounts[msg.sender] > 0, "presale-err: no token to claim");

        claimableAmounts[msg.sender] = 0;
        cnt.safeTransfer(msg.sender, claimableAmounts[msg.sender]);
    }

    /**
     * @dev Withdraw busd or cnt token from this contract.
     */
    function withdrawTokens(address _token) external onlyOwner {
        IERC20(_token).safeTransfer(wallet, IERC20(_token).balanceOf(address(this)));
    }

    /**
     * @dev Set referral percent on referral level.
     */
    function setReferralPercent(uint8 _referralLV, uint256 _refPercent) external onlyOwner {
        require(_referralLV < 4, "presale-err: referralLV should be less than 4");
        require(_refPercent < 1000, "presale-err: refPercent should be less than 10%");
        
        REFERRAL_PERCENTS[_referralLV] = _refPercent;
    }

    /**
     * @dev Set wallet to withdraw.
     */
    function setWalletReceiver(address _newWallet) external onlyOwner {
        wallet = _newWallet;
    }
}