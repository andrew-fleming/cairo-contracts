#[starknet::interface]
trait InitializableABI<TStorage> {
    fn is_initialized(self: @TStorage) -> bool;
    fn initialize(ref self: TStorage);
}

#[contract]
mod Initializable {
    #[starknet::storage]
    struct Storage {
        initialized: bool
    }

    #[external]
    impl InitializableImpl of super::InitializableABI<Storage> {
        fn is_initialized(self: @Storage) -> bool {
            self.is_initialized()
        }

        fn initialize(ref self: Storage) {
            self.initialize();
        }
    }

    #[generate_trait]
    impl StorageImpl of StorageTrait {
        fn is_initialized(self: @Storage) -> bool {
            self.initialized.read()
        }

        fn initialize(ref self: Storage) {
            assert(!self.is_initialized(), 'Initializable: is initialized');
            self.initialized.write(true);
        }
    }
}
