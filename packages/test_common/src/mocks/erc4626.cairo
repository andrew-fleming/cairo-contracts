#[starknet::contract]
pub mod ERC4626Mock {
    use openzeppelin_token::erc20::extensions::erc4626::DefaultConfig;
    use openzeppelin_token::erc20::extensions::erc4626::ERC4626Component::InternalTrait as ERC4626InternalTrait;
    use openzeppelin_token::erc20::extensions::erc4626::ERC4626Component;
    use openzeppelin_token::erc20::extensions::erc4626::ERC4626HooksEmptyImpl;
    use openzeppelin_token::erc20::{ERC20Component, ERC20HooksEmptyImpl};
    use starknet::ContractAddress;

    component!(path: ERC4626Component, storage: erc4626, event: ERC4626Event);
    component!(path: ERC20Component, storage: erc20, event: ERC20Event);

    // ERC4626
    #[abi(embed_v0)]
    impl ERC4626ComponentImpl = ERC4626Component::ERC4626Impl<ContractState>;
    // ERC4626MetadataImpl is a custom impl of IERC20Metadata
    #[abi(embed_v0)]
    impl ERC4626MetadataImpl = ERC4626Component::ERC4626MetadataImpl<ContractState>;

    // ERC20
    #[abi(embed_v0)]
    impl ERC20Impl = ERC20Component::ERC20Impl<ContractState>;
    #[abi(embed_v0)]
    impl ERC20CamelOnlyImpl = ERC20Component::ERC20CamelOnlyImpl<ContractState>;

    impl ERC4626InternalImpl = ERC4626Component::InternalImpl<ContractState>;
    impl ERC20InternalImpl = ERC20Component::InternalImpl<ContractState>;

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        pub erc4626: ERC4626Component::Storage,
        #[substorage(v0)]
        pub erc20: ERC20Component::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC4626Event: ERC4626Component::Event,
        #[flat]
        ERC20Event: ERC20Component::Event
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: ByteArray,
        symbol: ByteArray,
        underlying_asset: ContractAddress,
        initial_supply: u256,
        recipient: ContractAddress
    ) {
        self.erc20.initializer(name, symbol);
        self.erc20.mint(recipient, initial_supply);
        self.erc4626.initializer(underlying_asset);
    }
}

#[starknet::contract]
pub mod ERC4626OffsetMock {
    use openzeppelin_token::erc20::extensions::erc4626::ERC4626Component::InternalTrait as ERC4626InternalTrait;
    use openzeppelin_token::erc20::extensions::erc4626::ERC4626Component;
    use openzeppelin_token::erc20::extensions::erc4626::ERC4626HooksEmptyImpl;
    use openzeppelin_token::erc20::{ERC20Component, ERC20HooksEmptyImpl};
    use starknet::ContractAddress;

    component!(path: ERC4626Component, storage: erc4626, event: ERC4626Event);
    component!(path: ERC20Component, storage: erc20, event: ERC20Event);

    // ERC4626
    #[abi(embed_v0)]
    impl ERC4626ComponentImpl = ERC4626Component::ERC4626Impl<ContractState>;
    // ERC4626MetadataImpl is a custom impl of IERC20Metadata
    #[abi(embed_v0)]
    impl ERC4626MetadataImpl = ERC4626Component::ERC4626MetadataImpl<ContractState>;

    // ERC20
    #[abi(embed_v0)]
    impl ERC20Impl = ERC20Component::ERC20Impl<ContractState>;
    #[abi(embed_v0)]
    impl ERC20CamelOnlyImpl = ERC20Component::ERC20CamelOnlyImpl<ContractState>;

    impl ERC4626InternalImpl = ERC4626Component::InternalImpl<ContractState>;
    impl ERC20InternalImpl = ERC20Component::InternalImpl<ContractState>;

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        pub erc4626: ERC4626Component::Storage,
        #[substorage(v0)]
        pub erc20: ERC20Component::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC4626Event: ERC4626Component::Event,
        #[flat]
        ERC20Event: ERC20Component::Event
    }

    pub impl OffsetConfig of ERC4626Component::ImmutableConfig {
        const UNDERLYING_DECIMALS: u8 = ERC4626Component::DEFAULT_UNDERLYING_DECIMALS;
        const DECIMALS_OFFSET: u8 = 1;
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: ByteArray,
        symbol: ByteArray,
        underlying_asset: ContractAddress,
        initial_supply: u256,
        recipient: ContractAddress
    ) {
        self.erc20.initializer(name, symbol);
        self.erc20.mint(recipient, initial_supply);
        self.erc4626.initializer(underlying_asset);
    }
}

#[starknet::contract]
pub mod ERC4626LimitsMock {
    use openzeppelin_token::erc20::extensions::erc4626::ERC4626Component::InternalTrait as ERC4626InternalTrait;
    use openzeppelin_token::erc20::extensions::erc4626::ERC4626Component;
    use openzeppelin_token::erc20::extensions::erc4626::ERC4626Component::ExchangeType;
    use openzeppelin_token::erc20::{ERC20Component, ERC20HooksEmptyImpl};
    use starknet::ContractAddress;

    component!(path: ERC4626Component, storage: erc4626, event: ERC4626Event);
    component!(path: ERC20Component, storage: erc20, event: ERC20Event);

    // ERC4626
    #[abi(embed_v0)]
    impl ERC4626ComponentImpl = ERC4626Component::ERC4626Impl<ContractState>;
    // ERC4626MetadataImpl is a custom impl of IERC20Metadata
    #[abi(embed_v0)]
    impl ERC4626MetadataImpl = ERC4626Component::ERC4626MetadataImpl<ContractState>;

    // ERC20
    #[abi(embed_v0)]
    impl ERC20Impl = ERC20Component::ERC20Impl<ContractState>;
    #[abi(embed_v0)]
    impl ERC20CamelOnlyImpl = ERC20Component::ERC20CamelOnlyImpl<ContractState>;

    impl ERC4626InternalImpl = ERC4626Component::InternalImpl<ContractState>;
    impl ERC20InternalImpl = ERC20Component::InternalImpl<ContractState>;

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        pub erc4626: ERC4626Component::Storage,
        #[substorage(v0)]
        pub erc20: ERC20Component::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC4626Event: ERC4626Component::Event,
        #[flat]
        ERC20Event: ERC20Component::Event
    }

    pub impl OffsetConfig of ERC4626Component::ImmutableConfig {
        const UNDERLYING_DECIMALS: u8 = ERC4626Component::DEFAULT_UNDERLYING_DECIMALS;
        const DECIMALS_OFFSET: u8 = 1;
    }

    const MAX_DEPOSIT: u256 = 100_000_000_000_000_000_000;
    const MAX_MINT: u256 = 100_000_000_000_000_000_000;

    impl ERC4626HooksEmptyImpl of ERC4626Component::ERC4626HooksTrait<ContractState> {
        fn adjust_limits(
            self: @ERC4626Component::ComponentState<ContractState>, exchange_type: ExchangeType, raw_amount: u256
        ) -> u256 {
            match exchange_type {
                ExchangeType::Mint => { MAX_MINT },
                ExchangeType::Deposit => { MAX_DEPOSIT },
                _ => { raw_amount }
            }
        }
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: ByteArray,
        symbol: ByteArray,
        underlying_asset: ContractAddress,
        initial_supply: u256,
        recipient: ContractAddress
    ) {
        self.erc20.initializer(name, symbol);
        self.erc20.mint(recipient, initial_supply);
        self.erc4626.initializer(underlying_asset);
    }
}

#[starknet::contract]
pub mod ERC4626FeesMock {
    use openzeppelin_token::erc20::extensions::erc4626::ERC4626Component::InternalTrait as ERC4626InternalTrait;
    use openzeppelin_token::erc20::extensions::erc4626::ERC4626Component;
    use openzeppelin_token::erc20::extensions::erc4626::ERC4626Component::ExchangeType;
    use openzeppelin_token::erc20::{ERC20Component, ERC20HooksEmptyImpl};
    use openzeppelin_utils::math;
    use openzeppelin_utils::math::Rounding;
    use starknet::ContractAddress;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    component!(path: ERC4626Component, storage: erc4626, event: ERC4626Event);
    component!(path: ERC20Component, storage: erc20, event: ERC20Event);

    // ERC4626
    #[abi(embed_v0)]
    impl ERC4626ComponentImpl = ERC4626Component::ERC4626Impl<ContractState>;
    // ERC4626MetadataImpl is a custom impl of IERC20Metadata
    #[abi(embed_v0)]
    impl ERC4626MetadataImpl = ERC4626Component::ERC4626MetadataImpl<ContractState>;

    // ERC20
    #[abi(embed_v0)]
    impl ERC20Impl = ERC20Component::ERC20Impl<ContractState>;
    #[abi(embed_v0)]
    impl ERC20CamelOnlyImpl = ERC20Component::ERC20CamelOnlyImpl<ContractState>;

    impl ERC4626InternalImpl = ERC4626Component::InternalImpl<ContractState>;
    impl ERC20InternalImpl = ERC20Component::InternalImpl<ContractState>;

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        pub erc4626: ERC4626Component::Storage,
        #[substorage(v0)]
        pub erc20: ERC20Component::Storage,
        pub entry_fee_basis_point_value: u256,
        pub entry_fee_recipient: ContractAddress,
        pub exit_fee_basis_point_value: u256,
        pub exit_fee_recipient: ContractAddress
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC4626Event: ERC4626Component::Event,
        #[flat]
        ERC20Event: ERC20Component::Event
    }

    pub impl OffsetConfig of ERC4626Component::ImmutableConfig {
        const UNDERLYING_DECIMALS: u8 = ERC4626Component::DEFAULT_UNDERLYING_DECIMALS;
        const DECIMALS_OFFSET: u8 = 1;
    }

    const _BASIS_POINT_SCALE: u256 = 1_000;

    impl ERC4626HooksEmptyImpl of ERC4626Component::ERC4626HooksTrait<ContractState> {
        fn adjust_assets_or_shares(
            self: @ERC4626Component::ComponentState<ContractState>, exchange_type: ExchangeType, raw_amount: u256
        ) -> u256 {
            match exchange_type {
                ExchangeType::Mint => {
                    self.preview_mint(raw_amount)
                },
                ExchangeType::Deposit => {
                    self.preview_deposit(raw_amount)
                },
                ExchangeType::Withdraw => {
                    self.preview_withdraw(raw_amount)
                },
                ExchangeType::Redeem => {
                    self.preview_redeem(raw_amount)
                }
            }
        }
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: ByteArray,
        symbol: ByteArray,
        underlying_asset: ContractAddress,
        initial_supply: u256,
        recipient: ContractAddress,
        entry_fee: u256,
        entry_treasury: ContractAddress,
        exit_fee: u256,
        exit_treasury: ContractAddress
    ) {
        self.erc20.initializer(name, symbol);
        self.erc20.mint(recipient, initial_supply);
        self.erc4626.initializer(underlying_asset);

        self.entry_fee_basis_point_value.write(entry_fee);
        self.entry_fee_recipient.write(entry_treasury);
        self.exit_fee_basis_point_value.write(exit_fee);
        self.exit_fee_recipient.write(exit_treasury);
    }

    #[generate_trait]
    pub impl InternalImpl of InternalTrait {
        fn preview_deposit(self: @ContractState, assets:u256) -> u256 {
            let fee = self._fee_on_total(assets, self.entry_fee_basis_point_value.read());
            assets - fee
        }

        fn preview_mint(self: @ContractState, assets: u256) -> u256 {
            assets + self._fee_on_raw(assets, self.entry_fee_basis_point_value.read())
        }

        fn preview_withdraw(self: @ContractState, assets:u256) -> u256 {
            let fee = self._fee_on_raw(assets, self.exit_fee_basis_point_value.read());
            assets + fee
        }

        fn preview_redeem(self: @ContractState, assets: u256) -> u256 {
            assets - self._fee_on_total(assets, self.exit_fee_basis_point_value.read())
        }

        // === Fee operations ===

        /// Calculates the fees that should be added to an amount `assets` that does not already include fees.
        /// Used in IERC4626::mint and IERC4626::withdraw operations.
        fn _fee_on_raw(self: @ContractState, assets: u256, fee_basis_points: u256) -> u256 {
            math::u256_mul_div(assets, fee_basis_points, _BASIS_POINT_SCALE, Rounding::Ceil)
        }

        /// Calculates the fee part of an amount `assets` that already includes fees.
        /// Used in IERC4626::deposit and IERC4626::redeem operations.
        fn _fee_on_total(self: @ContractState, assets: u256, fee_basis_points: u256) -> u256 {
            math::u256_mul_div(assets, fee_basis_points, fee_basis_points + _BASIS_POINT_SCALE, Rounding::Ceil)
        }
    }
}
