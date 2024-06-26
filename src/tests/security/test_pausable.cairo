use openzeppelin::security::PausableComponent::{InternalImpl, PausableImpl};
use openzeppelin::security::PausableComponent::{Paused, Unpaused};
use openzeppelin::security::PausableComponent;
use openzeppelin::tests::mocks::pausable_mocks::PausableMock;
use openzeppelin::tests::utils::constants::{CALLER, ZERO};
use openzeppelin::tests::utils;
use starknet::ContractAddress;
use starknet::contract_address_const;
use starknet::testing;

type ComponentState = PausableComponent::ComponentState<PausableMock::ContractState>;

fn COMPONENT_STATE() -> ComponentState {
    PausableComponent::component_state_for_testing()
}

//
// is_paused
//

#[test]
fn test_is_paused() {
    let mut state = COMPONENT_STATE();
    assert!(!state.is_paused());

    state.pause();
    assert!(state.is_paused());

    state.unpause();
    assert!(!state.is_paused());
}

//
// assert_paused
//

#[test]
fn test_assert_paused_when_paused() {
    let mut state = COMPONENT_STATE();
    state.pause();
    state.assert_paused();
}

#[test]
#[should_panic(expected: ('Pausable: not paused',))]
fn test_assert_paused_when_not_paused() {
    let state = COMPONENT_STATE();
    state.assert_paused();
}

//
// assert_not_paused
//

#[test]
#[should_panic(expected: ('Pausable: paused',))]
fn test_assert_not_paused_when_paused() {
    let mut state = COMPONENT_STATE();
    state.pause();
    state.assert_not_paused();
}

#[test]
fn test_assert_not_paused_when_not_paused() {
    let state = COMPONENT_STATE();
    state.assert_not_paused();
}

//
// pause
//

#[test]
fn test_pause_when_unpaused() {
    let mut state = COMPONENT_STATE();
    testing::set_caller_address(CALLER());

    state.pause();

    assert_event_paused(CALLER());
    assert!(state.is_paused());
}

#[test]
#[should_panic(expected: ('Pausable: paused',))]
fn test_pause_when_paused() {
    let mut state = COMPONENT_STATE();
    state.pause();
    state.pause();
}

//
// unpause
//

#[test]
fn test_unpause_when_paused() {
    let mut state = COMPONENT_STATE();
    testing::set_caller_address(CALLER());

    state.pause();
    utils::drop_event(ZERO());

    state.unpause();

    assert_event_unpaused(CALLER());
    assert!(!state.is_paused());
}

#[test]
#[should_panic(expected: ('Pausable: not paused',))]
fn test_unpause_when_unpaused() {
    let mut state = COMPONENT_STATE();
    assert!(!state.is_paused());
    state.unpause();
}

//
// Helpers
//

fn assert_event_paused(account: ContractAddress) {
    let event = utils::pop_log::<PausableComponent::Event>(ZERO()).unwrap();
    let expected = PausableComponent::Event::Paused(Paused { account });
    assert!(event == expected);
    utils::assert_no_events_left(ZERO());
}

fn assert_event_unpaused(account: ContractAddress) {
    let event = utils::pop_log::<PausableComponent::Event>(ZERO()).unwrap();
    let expected = PausableComponent::Event::Unpaused(Unpaused { account });
    assert!(event == expected);
    utils::assert_no_events_left(ZERO());
}
