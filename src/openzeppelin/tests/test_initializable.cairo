use array::ArrayTrait;
use openzeppelin::security::initializable::Initializable;
use openzeppelin::tests::utils::single_deserialize;

#[test]
#[available_gas(2000000)]
fn test_initialize() {
    let mut retdata = Initializable::__external::is_initialized(Default::default().span());
    assert(single_deserialize(ref retdata) == false, 'Should not be initialized');

    Initializable::__external::initialize(Default::default().span());

    let mut retdata = Initializable::__external::is_initialized(Default::default().span());
    assert(single_deserialize(ref retdata) == true, 'Should be initialized');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('Initializable: is initialized', ))]
fn test_initialize_when_initialized() {
    Initializable::__external::initialize(Default::default().span());
    Initializable::__external::initialize(Default::default().span());
}
