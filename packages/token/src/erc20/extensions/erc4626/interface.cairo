// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts for Cairo v0.17.0 (token/erc20/extensions/erc4626/interface.cairo)

use starknet::ContractAddress;

#[starknet::interface]
pub trait IERC4626<TState> {
    /// Returns the address of the underlying token used for the Vault for accounting, depositing, and withdrawing.
    ///
    /// MUST be an ERC20 token contract.
    /// MUST NOT panic.
    fn asset(self: @TState) -> ContractAddress;
    /// Returns the total amount of the underlying asset that is “managed” by Vault.
    ///
    /// SHOULD include any compounding that occurs from yield.
    /// MUST be inclusive of any fees that are charged against assets in the Vault.
    /// MUST NOT panic.
    fn total_assets(self: @TState) -> u256;
    /// Returns the amount of shares that the Vault would exchange for the amount of assets provided,
    /// in an ideal scenario where all the conditions are met.
    ///
    /// MUST NOT be inclusive of any fees that are charged against assets in the Vault.
    /// MUST NOT show any variations depending on the caller.
    /// MUST NOT reflect slippage or other on-chain conditions, when performing the actual exchange.
    /// MUST NOT panic.
    fn convert_to_shares(self: @TState, assets: u256) -> u256;
    /// Returns the amount of assets that the Vault would exchange for the amount of shares provided,
    /// in an ideal scenario where all the conditions are met.
    ///
    /// MUST NOT be inclusive of any fees that are charged against assets in the Vault.
    /// MUST NOT show any variations depending on the caller.
    /// MUST NOT reflect slippage or other on-chain conditions, when performing the actual exchange.
    /// MUST NOT panic.
    fn convert_to_assets(self: @TState, shares: u256) -> u256;
    /// Returns the maximum amount of the underlying asset that can be deposited into the Vault for `receiver`,
    /// through a deposit call.
    ///
    /// MUST return a limited value if receiver is subject to some deposit limit.
    /// MUST return 2 ** 256 - 1 if there is no limit on the maximum amount of assets that may be deposited.
    /// MUST NOT panic.
    fn max_deposit(self: @TState, receiver: ContractAddress) -> u256;
    /// Allows an on-chain or off-chain user to simulate the effects of their deposit at the current block,
    /// given current on-chain conditions.
    ///
    /// MUST return as close to and no more than the exact amount of Vault shares that would be minted in a deposit call
    /// in the same transaction i.e. deposit should return the same or more shares as `preview_deposit` if called in the same
    /// transaction.
    /// MUST NOT account for deposit limits like those returned from `max_deposit` and should always act as though the deposit
    /// would be accepted, regardless if the user has enough tokens approved, etc.
    /// MUST be inclusive of deposit fees. Integrators should be aware of the existence of deposit fees.
    /// MUST NOT panic.
    fn preview_deposit(self: @TState, assets: u256) -> u256;
    /// Mints Vault shares to `receiver` by depositing exactly amount of `assets`.
    ///
    /// MUST emit the Deposit event.
    /// MAY support an additional flow in which the underlying tokens are owned by the Vault contract before the deposit execution,
    /// and are accounted for during deposit.
    /// MUST panic if all of assets cannot be deposited (due to deposit limit being reached, slippage,
    /// the user not approving enough underlying tokens to the Vault contract, etc).
    fn deposit(ref self: TState, assets: u256, receiver: ContractAddress) -> u256;
    /// Returns the maximum amount of the Vault shares that can be minted for the receiver, through a mint call.
    ///
    /// MUST return a limited value if receiver is subject to some mint limit.
    /// MUST return 2 ** 256 - 1 if there is no limit on the maximum amount of shares that may be minted.
    /// MUST NOT panic.
    fn max_mint(self: @TState, receiver: ContractAddress) -> u256;
    /// Allows an on-chain or off-chain user to simulate the effects of their mint at the current block,
    /// given current on-chain conditions.
    ///
    /// MUST return as close to and no fewer than the exact amount of assets that would be deposited in a `mint` call
    /// in the same transaction. I.e. `mint` should return the same or fewer assets as `preview_mint` if called in the same
    /// transaction.
    /// MUST NOT account for mint limits like those returned from `max_mint` and should always act as though the mint would be accepted,
    /// regardless if the user has enough tokens approved, etc.
    /// MUST be inclusive of deposit fees. Integrators should be aware of the existence of deposit fees.
    /// MUST NOT panic.
    ///
    /// NOTE: Any unfavorable discrepancy between convertToAssets and previewMint SHOULD be considered slippage in share price
    /// or some other type of condition, meaning the depositor will lose assets by minting.
    fn preview_mint(self: @TState, shares: u256) -> u256;
    fn mint(ref self: TState, shares: u256, receiver: ContractAddress) -> u256;
    fn max_withdraw(self: @TState, owner: ContractAddress) -> u256;
    fn preview_withdraw(self: @TState, assets: u256) -> u256;
    fn withdraw(
        ref self: TState, assets: u256, receiver: ContractAddress, owner: ContractAddress
    ) -> u256;
    fn max_redeem(self: @TState, owner: ContractAddress) -> u256;
    fn preview_redeem(self: @TState, shares: u256) -> u256;
    fn redeem(
        ref self: TState, shares: u256, receiver: ContractAddress, owner: ContractAddress
    ) -> u256;
}

#[starknet::interface]
pub trait ERC4626ABI<TState> {
    // IERC4626
    fn asset(self: @TState) -> ContractAddress;
    fn total_assets(self: @TState) -> u256;
    fn convert_to_shares(self: @TState, assets: u256) -> u256;
    fn convert_to_assets(self: @TState, shares: u256) -> u256;
    fn max_deposit(self: @TState, receiver: ContractAddress) -> u256;
    fn preview_deposit(self: @TState, assets: u256) -> u256;
    fn deposit(ref self: TState, assets: u256, receiver: ContractAddress) -> u256;
    fn max_mint(self: @TState, receiver: ContractAddress) -> u256;
    fn preview_mint(self: @TState, shares: u256) -> u256;
    fn mint(ref self: TState, shares: u256, receiver: ContractAddress) -> u256;
    fn max_withdraw(self: @TState, owner: ContractAddress) -> u256;
    fn preview_withdraw(self: @TState, assets: u256) -> u256;
    fn withdraw(
        ref self: TState, assets: u256, receiver: ContractAddress, owner: ContractAddress
    ) -> u256;
    fn max_redeem(self: @TState, owner: ContractAddress) -> u256;
    fn preview_redeem(self: @TState, shares: u256) -> u256;
    fn redeem(
        ref self: TState, shares: u256, receiver: ContractAddress, owner: ContractAddress
    ) -> u256;

    // IERC20
    fn total_supply(self: @TState) -> u256;
    fn balance_of(self: @TState, account: ContractAddress) -> u256;
    fn allowance(self: @TState, owner: ContractAddress, spender: ContractAddress) -> u256;
    fn transfer(ref self: TState, recipient: ContractAddress, amount: u256) -> bool;
    fn transfer_from(
        ref self: TState, sender: ContractAddress, recipient: ContractAddress, amount: u256
    ) -> bool;
    fn approve(ref self: TState, spender: ContractAddress, amount: u256) -> bool;

    // IERC20Metadata
    fn name(self: @TState) -> ByteArray;
    fn symbol(self: @TState) -> ByteArray;
    fn decimals(self: @TState) -> u8;

    // IERC20CamelOnly
    fn totalSupply(self: @TState) -> u256;
    fn balanceOf(self: @TState, account: ContractAddress) -> u256;
    fn transferFrom(
        ref self: TState, sender: ContractAddress, recipient: ContractAddress, amount: u256
    ) -> bool;
}
