import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Float "mo:base/Float";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Result "mo:base/Result";

persistent actor LiquidBTC {
    // ===== STATE =====
    
    // Exchange rate: how much BTC one stBTC is worth
    stable var exchangeRate : Float = 1.0;
    
    // User balances: Principal -> stBTC amount
    // HashMaps can't be stable, so marked as transient
    transient var balances = HashMap.HashMap<Principal, Nat>(
        10, 
        Principal.equal, 
        Principal.hash
    );
    
    // Total supply of stBTC
    stable var totalSupply : Nat = 0;
    
    // Total BTC staked (for stats)
    stable var totalBTCStaked : Nat = 0;
    
    // ===== CONSTANTS =====
    transient let SATS_PER_BTC : Nat = 100_000_000;
    transient let APY : Float = 0.10; // 10% annual yield
    
    // ===== CORE FUNCTIONS =====
    
    // STAKE: User deposits BTC, gets stBTC
    public shared(msg) func stake(amountSats: Nat) : async Result.Result<Text, Text> {
        let caller = msg.caller;
        
        if (amountSats == 0) {
            return #err("Amount must be greater than 0");
        };
        
        // Get current balance
        let currentBalance = switch (balances.get(caller)) {
            case null { 0 };
            case (?bal) { bal };
        };
        
        // Mint stBTC 1:1
        let newBalance = currentBalance + amountSats;
        balances.put(caller, newBalance);
        
        // Update totals
        totalSupply += amountSats;
        totalBTCStaked += amountSats;
        
        #ok("Successfully staked " # Nat.toText(amountSats) # " sats")
    };
    
    // UNSTAKE: User burns stBTC, gets BTC back with rewards
    public shared(msg) func unstake(stBtcAmount: Nat) : async Result.Result<Nat, Text> {
        let caller = msg.caller;
        
        // Get user balance
        let balance = switch (balances.get(caller)) {
            case null { 0 };
            case (?bal) { bal };
        };
        
        // Check sufficient balance
        if (balance < stBtcAmount) {
            return #err("Insufficient stBTC balance");
        };
        
        // Calculate BTC to return (with rewards via exchange rate)
        let btcToReturn = Int.abs(Float.toInt(Float.fromInt(stBtcAmount) * exchangeRate));
        
        // Burn stBTC
        let newBalance = balance - stBtcAmount;
        if (newBalance == 0) {
            balances.delete(caller);
        } else {
            balances.put(caller, newBalance);
        };
        
        // Update totals - use safe subtraction
        totalSupply := Nat.sub(totalSupply, stBtcAmount);
        if (totalBTCStaked >= btcToReturn) {
            totalBTCStaked := Nat.sub(totalBTCStaked, btcToReturn);
        } else {
            totalBTCStaked := 0;
        };
        
        #ok(btcToReturn)
    };
    
    // SIMULATE REWARDS: Increase exchange rate (for demo)
    public func simulateRewards(days: Nat) : async () {
        // 10% APY ≈ 0.0261% daily
        let dailyMultiplier : Float = 1.000261;
        
        var i = 0;
        while (i < days) {
            exchangeRate := exchangeRate * dailyMultiplier;
            i += 1;
        };
    };
    
    // ===== QUERY FUNCTIONS =====
    
    // Get user's stBTC balance
    public query func getBalance(user: Principal) : async Nat {
        switch (balances.get(user)) {
            case null { 0 };
            case (?bal) { bal };
        }
    };
    
    // Get user's BTC value (stBTC * exchange rate)
    public query func getBTCValue(user: Principal) : async Nat {
        let stBtcBalance = switch (balances.get(user)) {
            case null { 0 };
            case (?bal) { bal };
        };
        
        Int.abs(Float.toInt(Float.fromInt(stBtcBalance) * exchangeRate))
    };
    
    // Get current exchange rate
    public query func getExchangeRate() : async Float {
        exchangeRate
    };
    
    // Get protocol stats
    public query func getStats() : async {
        totalSupply: Nat;
        totalStaked: Nat;
        exchangeRate: Float;
        apy: Float;
    } {
        {
            totalSupply = totalSupply;
            totalStaked = totalBTCStaked;
            exchangeRate = exchangeRate;
            apy = APY;
        }
    };
}