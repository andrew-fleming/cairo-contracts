const IERC165_ID: u32 = 0x01ffc9a7_u32;
const INVALID_ID: u32 = 0xffffffff_u32;

#[starknet::interface]
trait IERC165<TStorage> {
    fn supports_interface(self: @TStorage, interface_id: u32) -> bool;
}

#[contract]
mod ERC165 {
    use openzeppelin::introspection::erc165;

    #[starknet::storage]
    struct Storage {
        supported_interfaces: LegacyMap<u32, bool>
    }

    #[external]
    impl ERC165Impl of super::IERC165<Storage> {
        fn supports_interface(self: @Storage, interface_id: u32) -> bool {
            if interface_id == super::IERC165_ID {
                return true;
            }
            self.supports_interface(interface_id)
        }
    }

    #[generate_trait]
    impl StorageImpl of StorageTrait {
        fn supports_interface(self: @Storage, interface_id: u32) -> bool {
            self.supported_interfaces.read(interface_id)
        }

        fn register_interface(ref self: Storage, interface_id: u32) {
            assert(interface_id != erc165::INVALID_ID, 'Invalid id');
            self.supported_interfaces.write(interface_id, true);
        }

        fn deregister_interface(ref self: Storage, interface_id: u32) {
            assert(interface_id != erc165::IERC165_ID, 'Invalid id');
            self.supported_interfaces.write(interface_id, false);
        }
    }
}
