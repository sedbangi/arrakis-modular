// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {IArrakisLPModule} from "./IArrakisLPModule.sol";

/// @title IArrakisMetaVault
/// @notice IArrakisMetaVault is a vault that is able to invest dynamically deposited
/// tokens into protocols through his module.
interface IArrakisMetaVault {
    // #region errors.

    /// @dev triggered when an address that should not
    /// be zero is equal to address zero.
    error AddressZero(string property);

    /// @dev triggered when the caller is different than
    /// the manager.
    error OnlyManager(address caller, address manager);

    /// @dev triggered when a low level call failed during
    /// execution.
    error CallFailed();

    /// @dev triggered when manager try to set the active
    /// module as active.
    error SameModule();

    /// @dev triggered when owner of the vault try to set the
    /// manager with the current manager.
    error SameManager();

    /// @dev triggered when all tokens withdrawal has been done
    /// during a switch of module.
    error ModuleNotEmpty(uint256 amount0, uint256 amount1);

    /// @dev triggered when owner try to whitelist a module
    /// that has been already whitelisted.
    error AlreadyWhitelisted(address module);

    /// @dev triggered when owner try to blacklist a module
    /// that has not been whitelisted.
    error NotWhitelistedModule(address module);

    /// @dev triggered when owner try to blacklist the active module.
    error ActiveModule();

    /// @dev triggered during vault creation if token0 address is greater than
    /// token1 address.
    error Token0GtToken1();

    /// @dev triggered during vault creation if token0 address is equal to
    /// token1 address.
    error Token0EqToken1();

    // #endregion errors.

    // #region events.

    /// @notice Event describing a deposit done by an user inside this vault.
    /// @param proportion percentage of the current position that depositor want to increase.
    /// @param amount0 amount of token0 needed to increase the portfolio of "proportion" percent.
    /// @param amount1 amount of token1 needed to increase the portfolio of "proportion" percent.
    event LogDeposit(uint256 proportion, uint256 amount0, uint256 amount1);

    /// @notice Event describing a withdrawal of participation by an user inside this vault.
    /// @param proportion percentage of the current position that user want to withdraw.
    /// @param amount0 amount of token0 withdrawn due to withdraw action.
    /// @param amount1 amount of token1 withdrawn due to withdraw action.
    event LogWithdraw(uint256 proportion, uint256 amount0, uint256 amount1);

    /// @notice Event describing a manager fee withdrawal.
    /// @param amount0 amount of token0 that manager has earned and will be transfered.
    /// @param amount1 amount of token1 that manager has earned and will be transfered.
    event LogWithdrawManagerBalance(uint256 amount0, uint256 amount1);

    /// @notice Event describing owner setting the manager.
    /// @param oldManager address of manager that was managing the portfolio.
    /// @param newManager address of manager that will manage the portfolio.
    event LogSetManager(address oldManager, address newManager);

    /// @notice Event describing manager setting the module.
    /// @param module address of the new active module.
    /// @param payloads data payloads for initializing positions on the new module.
    event LogSetModule(address module, bytes[] payloads);

    /// @notice Event describing default module that the vault will be initialized with.
    /// @param module address of the default module.
    event LogSetFirstModule(address module);

    /// @notice Event describing list of modules that has been whitelisted by owner.
    /// @param modules list of addresses corresponding to new modules now available
    /// to be activated by manager.
    event LogWhiteListedModules(address[] modules);

    /// @notice Event describing whitelisted of the first module during vault creation.
    /// @param module default activation.
    event LogWhitelistedModule(address module);

    /// @notice Event describing blacklisting action of modules by owner.
    /// @param modules list of addresses corresponding to old modules that has been
    /// blacklisted.
    event LogBlackListedModules(address[] modules);

    // #endregion events.

    /// @notice function used by owner to set the Manager
    /// responsible to rebalance the position.
    /// @param newManager_ address of the new manager.
    function setManager(address newManager_) external;

    /// @notice function used to set module
    /// @param module_ address of the new module
    /// @param payloads_ datas to initialize/rebalance on the new module
    function setModule(address module_, bytes[] calldata payloads_) external;

    /// @notice function used to whitelist modules that can used by manager.
    /// @param modules_ array of module addresses to be whitelisted.
    function whitelistModules(address[] calldata modules_) external;

    /// @notice function used to blacklist modules that can used by manager.
    /// @param modules_ array of module addresses to be blacklisted.
    function blacklistModules(address[] calldata modules_) external;

    // #region view functions.

    /// @notice function used to get the list of modules whitelisted.
    /// @return modules whitelisted modules addresses.
    function whitelistedModules()
        external
        view
        returns (address[] memory modules);

    /// @notice function used to get the amount of token0 and token1 sitting
    /// on the position.
    /// @return amount0 the amount of token0 sitting on the position.
    /// @return amount1 the amount of token1 sitting on the position.
    function totalUnderlying()
        external
        view
        returns (uint256 amount0, uint256 amount1);

    /// @notice function used to get the amounts of token0 and token1 sitting
    /// on the position for a specific price.
    /// @param priceX96 price at which we want to simulate our tokens composition
    /// @return amount0 the amount of token0 sitting on the position for priceX96.
    /// @return amount1 the amount of token1 sitting on the position for priceX96.
    function totalUnderlyingAtPrice(
        uint160 priceX96
    ) external view returns (uint256 amount0, uint256 amount1);

    /// @notice function used to get the initial amounts needed to open a position.
    /// @return init0 the amount of token0 needed to open a position.
    /// @return init1 the amount of token1 needed to open a position.
    function getInits() external view returns (uint256 init0, uint256 init1);

    /// @notice function used to get the type of vault.
    /// @return vaultType as bytes32.
    function vaultType() external pure returns (bytes32);

    /// @notice function used to get the address of token0.
    function token0() external view returns (address);

    /// @notice function used to get the address of token1.
    function token1() external view returns (address);

    /// @notice function used to get manager address.
    function manager() external view returns (address);

    /// @notice function used to get module used to
    /// open/close/manager a position.
    function module() external view returns (IArrakisLPModule);

    // #endregion view functions.
}
