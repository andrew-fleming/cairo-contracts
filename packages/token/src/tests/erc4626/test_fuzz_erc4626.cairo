use core::num::traits::{Bounded, Pow};
use crate::erc20::ERC20Component::InternalImpl as ERC20InternalImpl;
use crate::erc20::extensions::erc4626::DefaultConfig;
use crate::erc20::extensions::erc4626::ERC4626Component;
use crate::erc20::extensions::erc4626::ERC4626Component::{
    ERC4626Impl, ERC4626MetadataImpl, InternalImpl,
};
use crate::erc20::extensions::erc4626::interface::{ERC4626ABIDispatcher, ERC4626ABIDispatcherTrait};
use openzeppelin_test_common::mocks::erc20::Type;
use openzeppelin_test_common::mocks::erc20::{
    IERC20ReentrantDispatcher, IERC20ReentrantDispatcherTrait,
};
use openzeppelin_test_common::mocks::erc4626::{ERC4626LimitsMock, ERC4626Mock};
use openzeppelin_testing as utils;
use openzeppelin_testing::constants::{NAME, OTHER, RECIPIENT, SPENDER, SYMBOL, ZERO};
use openzeppelin_utils::serde::SerializedAppend;
use snforge_std::{CheatSpan, cheat_caller_address, start_mock_call, stop_mock_call};
use starknet::{ContractAddress, contract_address_const};

fn ASSET() -> ContractAddress {
    contract_address_const::<'ASSET'>()
}

fn HOLDER() -> ContractAddress {
    contract_address_const::<'HOLDER'>()
}

fn CALLER2() -> ContractAddress {
    contract_address_const::<'CALLER2'>()
}

fn TREASURY() -> ContractAddress {
    contract_address_const::<'TREASURY'>()
}

fn VAULT_NAME() -> ByteArray {
    "VAULT"
}

fn VAULT_SYMBOL() -> ByteArray {
    "V"
}

const DEFAULT_DECIMALS: u8 = 18;
const NO_OFFSET_DECIMALS: u8 = 0;
const OFFSET_DECIMALS: u8 = 1;

fn parse_token(token: u256) -> u256 {
    token * 10_u256.pow(DEFAULT_DECIMALS.into())
}

fn parse_share_offset(shares: u256) -> u256 {
    shares * 10_u256.pow(DEFAULT_DECIMALS.into() + OFFSET_DECIMALS.into())
}

//
// Setup
//

type ComponentState = ERC4626Component::ComponentState<ERC4626Mock::ContractState>;

fn COMPONENT_STATE() -> ComponentState {
    ERC4626Component::component_state_for_testing()
}

fn CONTRACT_STATE() -> ERC4626Mock::ContractState {
    ERC4626Mock::contract_state_for_testing()
}

//
// Dispatchers
//

fn deploy_asset() -> IERC20ReentrantDispatcher {
    let mut asset_calldata: Array<felt252> = array![];
    asset_calldata.append_serde(NAME());
    asset_calldata.append_serde(SYMBOL());

    let contract_address = utils::declare_and_deploy("ERC20ReentrantMock", asset_calldata);
    IERC20ReentrantDispatcher { contract_address }
}

fn deploy_vault(asset_address: ContractAddress) -> ERC4626ABIDispatcher {
    let no_shares = 0_u256;

    let mut vault_calldata: Array<felt252> = array![];
    vault_calldata.append_serde(VAULT_NAME());
    vault_calldata.append_serde(VAULT_SYMBOL());
    vault_calldata.append_serde(asset_address);
    vault_calldata.append_serde(no_shares);
    vault_calldata.append_serde(HOLDER());

    let contract_address = utils::declare_and_deploy("ERC4626Mock", vault_calldata);
    ERC4626ABIDispatcher { contract_address }
}

fn deploy_vault2(asset_address: ContractAddress, shares: u256) -> ERC4626ABIDispatcher {
    let mut vault_calldata: Array<felt252> = array![];
    vault_calldata.append_serde(VAULT_NAME());
    vault_calldata.append_serde(VAULT_SYMBOL());
    vault_calldata.append_serde(asset_address);
    vault_calldata.append_serde(shares);
    vault_calldata.append_serde(HOLDER());

    let contract_address = utils::declare_and_deploy("ERC4626Mock", vault_calldata);
    ERC4626ABIDispatcher { contract_address }
}

fn fuzz_felt_to_address_or_0(x: felt252) -> ContractAddress {
    match x.try_into() {
        Option::Some(a) => a,
        Option::None(_) => starknet::contract_address_const::<0>()
    }
}

//
// asset
//

#[test]
fn test_asset_doesnt_panic(felt_addr: felt252) {
    let mut state = COMPONENT_STATE();
    let asset_address = fuzz_felt_to_address_or_0(felt_addr);

    if asset_address != ZERO() {
        state.initializer(asset_address);

        let _asset_address = state.asset();
        assert_eq!(_asset_address, asset_address);
    }
}

//
// total_assets
//

#[test]
fn test_total_assets_doesnt_panic(felt_addr: felt252, caller_address: felt252, asset_amt: u256) {
    let mut state = COMPONENT_STATE();
    let asset_address = ASSET();

    state.initializer(asset_address);
    start_mock_call(ASSET(), selector!("balance_of"), asset_amt);

    let caller = fuzz_felt_to_address_or_0(caller_address);
    cheat_caller_address(ZERO(), caller, CheatSpan::TargetCalls(1));
    let total_assets = state.total_assets();
    assert_eq!(asset_amt, total_assets);
}

//
// convert
//

#[test]
fn test_convert_to_shares_no_variation_with_caller(felt_caller_1: felt252, felt_caller_2: felt252, total_assets: u256) {
}

#[test]
fn test_convert_to_assets_no_variation_with_caller(felt_addr: felt252, asset_amt: u256) {
}