#[starknet::interface]
trait IPausable<TStorage> {
    fn is_paused(self: @TStorage) -> bool;
}

#[contract]
mod Pausable {
    use starknet::ContractAddress;
    use starknet::get_caller_address;

    #[starknet::storage]
    struct Storage {
        paused: bool
    }

    #[derive(Drop, starknet::Event)]
    enum Event {
        #[event]
        Paused: Paused,
        #[event]
        Unpaused: Unpaused,
    }
    #[derive(Drop, starknet::Event)]
    struct Paused {
        account: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct Unpaused {
        account: ContractAddress,
    }

    #[external]
    impl PausableImpl of super::IPausable<Storage> {
        fn is_paused(self: @Storage) -> bool {
            self.is_paused()
        }
    }

    #[generate_trait]
    impl StorageImpl of StorageTrait {
        fn is_paused(self: @Storage) -> bool {
            self.paused.read()
        }

        fn assert_not_paused(self: @Storage) {
            assert(!self.is_paused(), 'Pausable: paused');
        }

        fn assert_paused(self: @Storage) {
            assert(self.is_paused(), 'Pausable: not paused');
        }

        fn _pause(ref self: Storage) {
            self.assert_not_paused();
            self.paused.write(true);
            self.emit(
                Event::Paused(Paused {account: get_caller_address()})
            );
        }

        fn _unpause(ref self: Storage) {
            self.assert_paused();
            self.paused.write(false);
            self.emit(
                Event::Unpaused(Unpaused {account: get_caller_address()})
            );
        }
    }
}
