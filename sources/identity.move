module btest_identity::ssi {
    use std::signer;
    use std::string;
    use aptos_framework::event;

    struct Identity has key {
        name: string::String,
        dob: string::String,
        verified: bool,
    }

    #[event]
    struct IdentityVerified has drop, store {
        account: address,
        name: string::String,
    }

    public entry fun create_identity(account: signer, name: string::String, dob: string::String) {
        let addr = signer::address_of(&account);
        assert!(!exists<Identity>(addr), 1); // Ensure identity doesn't already exist
        move_to(&account, Identity { name, dob, verified: false });
        }


    public entry fun verify_identity(account: signer) acquires Identity {
        let addr = signer::address_of(&account);
        let identity = borrow_global_mut<Identity>(addr);
        identity.verified = true;
        event::emit(IdentityVerified { account: addr, name: identity.name });
    }

    #[view]
    public fun get_identity(addr: address): Identity acquires Identity {
        assert!(exists<Identity>(addr), 2);
        let identity_ref = borrow_global<Identity>(addr);
        Identity { name: identity_ref.name, dob: identity_ref.dob, verified: identity_ref.verified }
        }

}
