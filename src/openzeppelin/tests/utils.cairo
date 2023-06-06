use array::ArrayTrait;
use core::result::ResultTrait;
use option::OptionTrait;
use serde::Serde;
use starknet::class_hash::Felt252TryIntoClassHash;
use starknet::ContractAddress;
use traits::TryInto;

fn deploy(contract_class_hash: felt252, calldata: Array<felt252>) -> ContractAddress {
    let (address, _) = starknet::deploy_syscall(
        contract_class_hash.try_into().unwrap(), 0, calldata.span(), false
    )
        .unwrap();
    address
}

fn serialized_element<T, impl TSerde: serde::Serde<T>, impl TDestruct: Destruct<T>>(
    value: T
) -> Span<felt252> {
    let mut arr = Default::default();
    value.serialize(ref arr);
    arr.span()
}

fn single_deserialize<T, impl TSerde: serde::Serde<T>>(ref data: Span::<felt252>) -> T {
    serde::Serde::deserialize(ref data).expect('missing data')
}
