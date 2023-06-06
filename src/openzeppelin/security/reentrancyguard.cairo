#[contract]
mod ReentrancyGuard {
    use starknet::get_caller_address;

    #[starknet::storage]
    struct Storage {
        entered: bool
    }

    #[generate_trait]
    impl StorageImpl of StorageTrait {
        fn start(ref self: Storage) {
            assert(!self.entered.read(), 'ReentrancyGuard: reentrant call');
            self.entered.write(true);
        }

        fn end(ref self: Storage) {
            self.entered.write(false);
        }
    }
}
